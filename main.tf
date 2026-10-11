resource "aws_secretsmanager_secret_rotation" "secretsmanager_secret_rotations" {
  for_each = var.secretsmanager_secret_rotations

  secret_id                         = each.value.secret_id
  external_secret_rotation_role_arn = each.value.external_secret_rotation_role_arn
  region                            = each.value.region
  rotate_immediately                = each.value.rotate_immediately
  rotation_lambda_arn               = each.value.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = each.value.rotation_rules.automatically_after_days
    duration                 = each.value.rotation_rules.duration
    schedule_expression      = each.value.rotation_rules.schedule_expression
  }

  dynamic "external_secret_rotation_metadata" {
    for_each = each.value.external_secret_rotation_metadata != null ? each.value.external_secret_rotation_metadata : []
    content {
      key   = external_secret_rotation_metadata.value.key
      value = external_secret_rotation_metadata.value.value
    }
  }
}

