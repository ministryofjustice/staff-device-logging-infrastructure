output "kinesis_stream_arn" {
  value = aws_kinesis_stream.shared_services_destination_stream.arn
}
