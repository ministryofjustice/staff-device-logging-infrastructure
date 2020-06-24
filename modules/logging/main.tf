resource "aws_api_gateway_rest_api" "logging_gateway" {
  name = "CustomLogGateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
