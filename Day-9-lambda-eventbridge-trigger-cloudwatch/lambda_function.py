def lambda_handler(event, context):
    print("Lambda triggered by EventBridge schedule!")
    return {"statusCode": 200, "body": "Hello from Lambda"}
