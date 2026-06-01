data "aws_ssoadmin_instances" "this" {}

locals {
  identity_center_instance_arn = coalesce(
    var.identity_center_instance_arn,
    try(data.aws_ssoadmin_instances.this.arns[0], null)
  )

  permission_set_names = {
    for k, v in var.permission_sets : k => "${var.permission_set_name_prefix}${k}"
  }

  managed_policy_attachments = merge([
    for ps_key, ps in var.permission_sets : {
      for policy_arn in try(ps.managed_policy_arns, []) :
      "${ps_key}:${policy_arn}" => {
        permission_set_key = ps_key
        policy_arn         = policy_arn
      }
    }
  ]...)

  customer_managed_policy_attachments = merge([
    for ps_key, ps in var.permission_sets : {
      for p in try(ps.customer_managed_policies, []) :
      "${ps_key}:${try(p.path, "/")}:${p.name}" => {
        permission_set_key = ps_key
        name               = p.name
        path               = try(p.path, "/")
      }
    }
  ]...)

  inline_policies = {
    for ps_key, ps in var.permission_sets :
    ps_key => ps
    if try(ps.inline_policy_json, null) != null
  }
}
