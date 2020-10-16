#!/usr/bin/env python

"""
Move all the messages from one SQS queue to another.

Usage: Run from Makefile. Run make process-dead-letter-queue and add required values
"""

import boto3
import itertools
import os
import sys
import uuid

def get_messages_from_queue(sqs_client, queue_url):
    while True:
        resp = sqs_client.receive_message(
            QueueUrl=queue_url, AttributeNames=["All"], MaxNumberOfMessages=10
        )

        try:
            yield from resp["Messages"]
        except KeyError:
            return

        entries = [
            {"Id": msg["MessageId"], "ReceiptHandle": msg["ReceiptHandle"]}
            for msg in resp["Messages"]
        ]

        resp = sqs_client.delete_message_batch(QueueUrl=queue_url, Entries=entries)

        if len(resp["Successful"]) != len(entries):
            raise RuntimeError(
                f"Failed to delete messages: entries={entries!r} resp={resp!r}"
            )


def chunked_iterable(iterable, *, size):
    it = iter(iterable)
    while True:
        chunk = tuple(itertools.islice(it, size))
        if not chunk:
            break
        yield chunk


if __name__ == "__main__":
    src_queue_url = os.environ.get("DLQ_SQS_URL")
    dst_queue_url = os.environ.get("SQS_DESTINATION_URL")

    if src_queue_url == dst_queue_url:
        sys.exit("Source and destination queues cannot be the same.")

    sqs_client = boto3.client("sqs")

    messages = get_messages_from_queue(sqs_client, queue_url=src_queue_url)

    # The SendMessageBatch API supports sending up to ten messages at once.
    for message_batch in chunked_iterable(messages, size=10):
        print(f"Writing {len(message_batch):2d} messages to {dst_queue_url}")
        sqs_client.send_message_batch(
            QueueUrl=dst_queue_url,
            Entries=[
                {"Id": str(uuid.uuid4()), "MessageBody": message["Body"]}
                for message in message_batch
            ],
        )
