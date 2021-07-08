resource "aws_apigatewayv2_api" "chat-app-web-socket" {
  name = "ChatAppWebSocked"
  protocol_type = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "web-socket-onconnect" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  route_key = "$connect"
  authorization_type = "NONE"
  operation_name = "ConnectRoute"
  target = aws_apigatewayv2_integration.web-socket-onconnect-integration.id
}

resource "aws_apigatewayv2_integration" "web-socket-onconnect-integration" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  integration_type = "AWS"
  integration_uri = module.functions["onconnect"].function-invoke-arn
}

resource "aws_apigatewayv2_route" "web-socket-ondisconnect" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  route_key = "$disconnect"
  authorization_type = "NONE"
  operation_name = "DisconnectRoute"
  target = aws_apigatewayv2_integration.web-socket-onconnect-integration.id
}

resource "aws_apigatewayv2_integration" "web-socket-disconnect-integration" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  integration_type = "AWS"
  integration_uri = module.functions["ondisconnect"].function-invoke-arn
}

resource "aws_apigatewayv2_route" "web-socket-sendmessage" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  route_key = "sendmessage"
  operation_name = "SendRoute"
  target = aws_apigatewayv2_integration.web-socket-sendmessage-integration.id
}

resource "aws_apigatewayv2_integration" "web-socket-sendmessage-integration" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  integration_type = "AWS"
  integration_uri = module.functions["sendmessage"].function-invoke-arn
}

resource "aws_apigatewayv2_deployment" "web-socket-deployment" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
}

resource "aws_apigatewayv2_stage" "web-socket-stage" {
  api_id = aws_apigatewayv2_api.chat-app-web-socket.id
  name = "Prod"
  deployment_id =aws_apigatewayv2_deployment.web-socket-deployment.id
}