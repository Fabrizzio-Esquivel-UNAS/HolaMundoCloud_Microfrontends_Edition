# API GATEWAY DEFINITION
resource "aws_api_gateway_rest_api" "my_api" {
  name = "hola-mundo-api"
  description = "My API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

###### gateway_1
resource "aws_api_gateway_resource" "gateway_1" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "{proxy+}"
}

### gateway_1_method_1
resource "aws_api_gateway_method" "gateway_1_method_1" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.gateway_1.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "gateway_1_method_1" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.gateway_1.id
  http_method = aws_api_gateway_method.gateway_1_method_1.http_method
  type                    = "HTTP"
  integration_http_method = "ANY"
  uri                     = "http://${aws_instance.ecs_instance_1.public_ip}:3030/"  
}

resource "aws_api_gateway_method_response" "gateway_1_method_1" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.gateway_1.id
  http_method = aws_api_gateway_method.gateway_1_method_1.http_method
  status_code = "200"
  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  } 
}

resource "aws_api_gateway_integration_response" "gateway_1" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.gateway_1.id
  http_method = aws_api_gateway_method.gateway_1_method_1.http_method
  status_code = aws_api_gateway_method_response.gateway_1_method_1.status_code

  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  //Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = "#set($inputRoot = $input.path('$'))\n$inputRoot" # This simply returns the raw body from the backend
  }

  depends_on = [
    aws_api_gateway_method.gateway_1_method_1,
    aws_api_gateway_integration.gateway_1_method_1
  ]
}

# API GATEWAY DEPLOYMENT
resource "aws_api_gateway_deployment" "deployment" {
  //Agregar todos los metodos que deben crearse antes del deployment
  depends_on = [
    aws_api_gateway_integration.gateway_1_method_1,
  ]
  rest_api_id = aws_api_gateway_rest_api.my_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.my_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = "dev"
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}