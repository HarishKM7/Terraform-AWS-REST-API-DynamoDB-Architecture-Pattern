data "aws_region" "region" {}

locals {
  openAPI_spec = {
    "/item" : {
      post : {
        responses : {
          200 : { content : { "application/json" : { schema : {} } } }
        }
        x-amazon-apigateway-integration : {
          type : "aws"
          httpMethod : "POST"
          credentials : aws_iam_role.iam_role.arn
          responses : { default : { statusCode : "200" } }
          uri : "arn:aws:apigateway:${data.aws_region.region.name}:dynamodb:action/PutItem"
        }
      }

      get : {
        parameters : [{
          name : "id"
          in : "query"
          required : true
          schema : { type : "string" }
          }, {
          name : "table"
          in : "query"
          required : true
          schema : { type : "string" }
        }]
        responses : {
          200 : { content : { "application/json" : { schema : {} } } }
        }
        x-amazon-apigateway-integration : {
          type : "aws"
          httpMethod : "POST"
          credentials : aws_iam_role.iam_role.arn
          responses : { default : { statusCode : "200" } }
          uri : "arn:aws:apigateway:${data.aws_region.region.name}:dynamodb:action/GetItem"
          requestTemplates : {
            "application/json" : jsonencode({
              TableName : "$input.params('table')"
              Key : { id : { S : "$input.params('id')" } }
            })
          }
        }
      }

      delete : {
        parameters : [{
          name : "id"
          in : "query"
          required : true
          schema : { type : "string" }
          }, {
          name : "table"
          in : "query"
          required : true
          schema : { type : "string" }
        }]
        responses : {
          200 : { content : { "application/json" : { schema : {} } } }
        }
        x-amazon-apigateway-integration : {
          type : "aws"
          httpMethod : "POST"
          credentials : aws_iam_role.iam_role.arn
          responses : { default : { statusCode : "200" } }
          uri : "arn:aws:apigateway:${data.aws_region.region.name}:dynamodb:action/DeleteItem"
          requestTemplates : {
            "application/json" : jsonencode({
              TableName : "$input.params('table')"
              Key : { id : { S : "$input.params('id')" } }
            })
          }
        }
      }
    }
  }
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  body = jsonencode({
    openapi = "3.0.1"
    paths   = local.openAPI_spec
  })
}
