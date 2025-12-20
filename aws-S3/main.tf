resource "random_id" "randomHex" {
    byte_length = 8
}

resource "aws_s3_bucket" "awsS3" {
    bucket=format("%s-%s",var.bucketName,random_id.randomHex.hex)
    tags = {
      Name="S3-Tf-via-Jenkins"
      Environment=Dev
    }
}
