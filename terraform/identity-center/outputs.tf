output "identity_center_instance_arn" {
  description = "IAM Identity Center instance ARN used by this unit."
  value       = local.identity_center_instance_arn
}

output "permission_set_names" {
  description = "Permission set names created by this unit (keyed by logical name)."
  value       = local.permission_set_names
}

output "permission_set_arns" {
  description = "Permission set ARNs created by this unit (keyed by logical name)."
  value       = { for k, v in aws_ssoadmin_permission_set.this : k => v.arn }
}
