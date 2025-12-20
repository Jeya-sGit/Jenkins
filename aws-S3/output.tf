output "s3_bucket_id" {
  description = "The name/ID of the bucket"
  value       = aws_s3_bucket.awsS3.id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.awsS3.arn
}