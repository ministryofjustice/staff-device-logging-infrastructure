FROM python:3.8-alpine3.12
WORKDIR /code

COPY process_dlq.py process_dlq.py
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

CMD ["python", "process_dlq.py"]
