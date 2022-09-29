output "role" {
  value = aws_iam_role.role.id
}

output "instance_profile"{
    value = aws_iam_instance_profile.instance_profile.name
}

output "policies" {
  value = aws_iam_policy_attachment.attach
}