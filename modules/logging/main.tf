resource "aws_api_gateway_rest_api" "logging_gateway" {
  name = "CustomLogGateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  parent_id   = aws_api_gateway_rest_api.logging_gateway.root_resource_id
  path_part   = "logs"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.logging_gateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "POST"
  authorization = "NONE"
}
