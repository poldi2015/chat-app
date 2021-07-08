#
# API Registration
#

resource "aws_api_gateway_account" "chat-app-api-gateway" {
  cloudwatch_role_arn = aws_iam_role.apigateway-cloudwatch-log-role.arn
}

resource "aws_apigatewayv2_api" "chat-app-web-socket" {
  name = "ChatAppWebSocked"
  protocol_type = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
  depends_on = [aws_api_gateway_account.chat-app-api-gateway]

  tags = {
    Source = "chat-app"
  }
}

#
# onconnect route
#

resource "aws_apigatewayv2_route" "web-socket-onconnect" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  route_key = "$connect"
  authorization_type = "NONE"
  operation_name = "ConnectRoute"
  target = "integrations/${aws_apigatewayv2_integration.web-socket-onconnect-integration.id}"
  depends_on = [aws_apigatewayv2_integration.web-socket-onconnect-integration]
}

resource "aws_apigatewayv2_integration" "web-socket-onconnect-integration" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  integration_type = "AWS_PROXY"
  integration_uri = module.functions["onconnect"].function-invoke-arn
}

#
# disconnect route
#

resource "aws_apigatewayv2_route" "web-socket-ondisconnect" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  route_key = "$disconnect"
  authorization_type = "NONE"
  operation_name = "DisconnectRoute"
  target = "integrations/${aws_apigatewayv2_integration.web-socket-onconnect-integration.id}"
  depends_on = [aws_apigatewayv2_integration.web-socket-disconnect-integration]
}

resource "aws_apigatewayv2_integration" "web-socket-disconnect-integration" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  integration_type = "AWS_PROXY"
  integration_uri = module.functions["ondisconnect"].function-invoke-arn
}

#
# sendmessage route
#

resource "aws_apigatewayv2_route" "web-socket-sendmessage" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  route_key = "sendmessage"
  operation_name = "SendRoute"
  target = "integrations/${aws_apigatewayv2_integration.web-socket-sendmessage-integration.id}"
  depends_on = [aws_apigatewayv2_integration.web-socket-sendmessage-integration]
}

resource "aws_apigatewayv2_integration" "web-socket-sendmessage-integration" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  integration_type = "AWS_PROXY"
  integration_uri = module.functions["sendmessage"].function-invoke-arn
}

#
# deployment and stage
#

resource "aws_apigatewayv2_deployment" "web-socket-deployment" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id

  depends_on = [
    aws_apigatewayv2_route.web-socket-onconnect,
    aws_apigatewayv2_route.web-socket-ondisconnect,
    aws_apigatewayv2_route.web-socket-sendmessage
  ]
  lifecycle {
    create_before_destroy = true

  }
}

resource "aws_apigatewayv2_stage" "web-socket-stage" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  name = "Prod"
  deployment_id =aws_apigatewayv2_deployment.web-socket-deployment.id
  route_settings {
    route_key = aws_apigatewayv2_route.web-socket-sendmessage.route_key
    data_trace_enabled = true
    detailed_metrics_enabled = true
    logging_level = "INFO"
  }

  tags = {
    Source = "chat-app"
  }
}