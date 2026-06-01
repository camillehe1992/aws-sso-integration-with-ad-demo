aws_region = "ap-southeast-1"

default_tags = {
  Repository = "aws-sso-integration-with-ad-demo"
  Unit       = "IdentityCenter"
}

permission_sets = {
  ReadOnlyAccess = {
    description         = "AWS managed ReadOnlyAccess"
    session_duration    = "PT8H"
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }
  AdministratorAccess = {
    description         = "AWS managed AdministratorAccess"
    session_duration    = "PT8H"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }
  PowerUserAccess = {
    description         = "AWS managed PowerUserAccess"
    session_duration    = "PT8H"
    managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
  }
}
