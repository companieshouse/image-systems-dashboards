data "aws_caller_identity" "current" {}

data "aws_instance" "all" {
  for_each = toset(concat(
    data.aws_instances.tuxedo.ids,
    data.aws_instances.dps.ids
  ))

  instance_id = each.key
}

data "aws_instances" "dps" {
  instance_tags = {
    Environment = var.environment
    Service     = "dps"
  }
}

data "aws_instances" "tuxedo" {
  instance_tags = {
    Environment = var.environment
    Service     = "tuxedo"
  }
}

data "aws_lb" "frontend" {
  name = "frontend-tuxedo-${var.environment}"
}

data "aws_resourcegroupstaggingapi_resources" "frontend_alb_target_groups" {
  resource_type_filters = ["elasticloadbalancing:targetgroup"]

  tag_filter {
    key    = "Service"
    values = ["tuxedo"]
  }
}

data "aws_lb_target_group" "frontend_alb" {
  for_each = toset(data.aws_resourcegroupstaggingapi_resources.frontend_alb_target_groups.resource_tag_mapping_list[*].resource_arn)
  arn      = each.key
}
