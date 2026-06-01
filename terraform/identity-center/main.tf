resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  instance_arn = local.identity_center_instance_arn

  name             = local.permission_set_names[each.key]
  description      = try(each.value.description, null)
  session_duration = try(each.value.session_duration, null)
  relay_state      = try(each.value.relay_state, null)
  tags             = try(each.value.tags, {})

  lifecycle {
    precondition {
      condition     = local.identity_center_instance_arn != null
      error_message = "No IAM Identity Center instance found in this account/region. Set identity_center_instance_arn explicitly."
    }
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = local.managed_policy_attachments

  instance_arn       = local.identity_center_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set_key].arn
  managed_policy_arn = each.value.policy_arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each = local.customer_managed_policy_attachments

  instance_arn       = local.identity_center_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set_key].arn

  customer_managed_policy_reference {
    name = each.value.name
    path = each.value.path
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = local.inline_policies

  instance_arn       = local.identity_center_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  inline_policy      = each.value.inline_policy_json
}
