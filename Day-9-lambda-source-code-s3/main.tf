# ---- IAM Role for Lambda ----
resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# ---- Attach basic execution policy ----
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Lambda ZIP file is uploaded to S3 automatically before creating the Lambda function.
# ---- S3 Bucket for Lambda Code ----
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-code-bucket-rajashri"  # must be globally unique
}

# ---- Upload Lambda ZIP to S3 ----
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id     # upload into this S3 bucket
  key    = "lambda-code.zip"                   # name of the file in S3 (you can change this)
  
  source = "lambda-code.zip"            # Ensure this file exists 
  etag   = filemd5("lambda-code.zip")                      # helps Terraform know if the local ZIP changed
}

# ---- Lambda Function from S3 ----
resource "aws_lambda_function" "from_s3" {
  function_name = "lambda-from-s3"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda-code.lambda_handler"
  runtime       = "python3.12"
  timeout      = 10
  memory_size  = 128
  
  #with using exsiting bucket and upload manually zip file
  # S3 bucket details where your code is stored
  #s3_bucket = "my-lambda-code-bucket"
  #s3_key    = "lambda-code.zip"
  
  source_code_hash = filebase64sha256("lambda-code.zip")

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

 #This hash is a checksum that triggers a deployment.


  #creating s3 and automatically upload zip file into s3
  s3_bucket =aws_s3_bucket.lambda_bucket.bucket
  s3_key = aws_s3_object.lambda_zip.key

  
}



#Note:
#1)Keep lambda-code.zip in same folder as main.tf (simplest way). 
#Terraform looks for file in current folder where you run 'terraform apply'. 
#2)Or if your ZIP is stored elsewhere (like Downloads folder), give full correct path using / or \\ (avoid single \  —> Terraform treats it as escape character  
#Both 'source' and 'etag' must same ZIP file path.  
  
