def lambda_handler(event, context):
    
    name = event.get("name", "shri")
    message = f"Hello, {name}! Welcome to AWS Lambda."
    
    return {
        "statusCode": 200,
        "body": message
    }
