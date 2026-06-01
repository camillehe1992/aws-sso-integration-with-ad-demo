variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)."
  type        = string
}

variable "default_tags" {
  description = "User-supplied tags merged with mandatory tags in providers.tf."
  type        = map(string)
  default     = {}
}

variable "identity_center_instance_arn" {
  description = "Optional override for the IAM Identity Center instance ARN. If null, the first instance in the account/region is used."
  type        = string
  default     = null
}

variable "permission_set_name_prefix" {
  description = "Prefix applied to all permission set names."
  type        = string
  default     = ""
}

variable "permission_sets" {
  description = "Map of permission sets to create, keyed by a logical name. The actual name is permission_set_name_prefix + key."
  type = map(object({
    description               = optional(string)
    session_duration          = optional(string)
    relay_state               = optional(string)
    managed_policy_arns       = optional(list(string), [])
    inline_policy_json        = optional(string)
    customer_managed_policies = optional(list(object({ name = string, path = optional(string) })), [])
    tags                      = optional(map(string), {})
  }))
  default = {}
}
