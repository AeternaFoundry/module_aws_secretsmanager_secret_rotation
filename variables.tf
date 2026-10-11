variable "secretsmanager_secret_rotations" {
  description = <<EOT
Map of secretsmanager_secret_rotations, attributes below
Required:
    - secret_id
    - rotation_rules (block):
        - automatically_after_days (optional)
        - duration (optional)
        - schedule_expression (optional)
Optional:
    - external_secret_rotation_role_arn
    - region
    - rotate_immediately
    - rotation_lambda_arn
    - external_secret_rotation_metadata (block):
        - key (required)
        - value (required)
EOT

  type = map(object({
    secret_id                         = string
    external_secret_rotation_role_arn = optional(string)
    region                            = optional(string)
    rotate_immediately                = optional(bool)
    rotation_lambda_arn               = optional(string)
    rotation_rules = object({
      automatically_after_days = optional(number)
      duration                 = optional(string)
      schedule_expression      = optional(string)
    })
    external_secret_rotation_metadata = optional(list(object({
      key   = string
      value = string
    })))
  }))
  validation {
    condition = alltrue([
      for k, v in var.secretsmanager_secret_rotations : (
        v.rotation_rules.automatically_after_days == null || (v.rotation_rules.automatically_after_days >= 1 && v.rotation_rules.automatically_after_days <= 1000)
      )
    ])
    error_message = "must be between 1 and 1000"
  }
  # Note: 4 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

