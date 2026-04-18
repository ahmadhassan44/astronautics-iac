data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_key_pair" "managed_key" {
  key_name   = "astro-ec2s-kp"
  public_key = ""

  lifecycle {
    ignore_changes = [public_key]
  }
}
