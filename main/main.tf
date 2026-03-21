import {
  to = aws_key_pair.managed_key
  id = "astro-ec2s-kp"
}


resource "aws_key_pair" "managed_key" {
  key_name   = "astro-ec2s-kp"
  public_key = ""

  lifecycle {
    ignore_changes = [public_key]
  }
}
