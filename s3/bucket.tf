resource "aws_s3_bucket" "doctolib_technical_test_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "doctolib_technical_test_bucket_acl" {
    bucket = aws_s3_bucket.doctolib_technical_test_bucket.id
    acl = var.acl_value  
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.doctolib_technical_test_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
        Sid       = "Allowputobjecttocanbewrittenonly"
        Principal = "*"
        Effect    = "Deny"
        Action    = "s3:PutObject"
        NotResource = [
          "${aws_s3_bucket.doctolib_technical_test_bucket.arn}/can_be_written/*",
        ]
    },
    {
        Sid       = "AllowAllforIPMachine"
        Principal = "*"
        Effect    = "Allow"
        Action    = "s3:PutObject"
        Resource = [
          "${aws_s3_bucket.doctolib_technical_test_bucket.arn}/can_be_written/*",
        ],
        Condition = {
            IpAddress = {
                "aws:SourceIp": var.ip
            }
        }
    },
    {
        Sid       = "DenyAllNotIPMachine"
        Principal = "*"
        Effect    = "Deny"
        Action    = "s3:PutObject"
        Resource = [
          "${aws_s3_bucket.doctolib_technical_test_bucket.arn}/can_be_written/*",
        ],
        Condition = {
            NotIpAddress = {
                "aws:SourceIp": var.ip
            }
        }
      }
    ]
  })
}

