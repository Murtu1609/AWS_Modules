resource "aws_iam_role" "role" {
name = var.role
assume_role_policy = var.assume_role_policy

}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.role
  role = aws_iam_role.role.name
}

resource "aws_iam_policy_attachment" "attach" {
    for_each = {for object in var.policies : object.name => object }

  name       = each.value.name
  roles      = [aws_iam_role.role.name]
  policy_arn = "arn:aws:iam::aws:policy/${each.value.policy}"
}
