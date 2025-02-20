resource "aws_cloudwatch_dashboard" "tuxedo" {
  dashboard_name = "image-systems"

  dashboard_body = jsonencode({
    "widgets" : [
      {
        "height" : 8,
        "width" : 10,
        "y" : 21,
        "x" : 1,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                namespace,
                "mem_used_percent",
                "host",
                instance.tags["Name"],
                { "region" : var.region }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : var.region,
          "title" : "Memory usage (%)",
          "period" : 300,
          "stat" : "Average"
        }
      },
      {
        "height" : 8,
        "width" : 10,
        "y" : 21,
        "x" : 11,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                namespace,
                "processes_total",
                "host",
                instance.tags["Name"],
                { "region" : var.region }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "eu-west-2",
          "title" : "Process count (total)",
          "period" : 300,
          "stat" : "Average"
        }
      },
      {
        "height" : 8,
        "width" : 10,
        "y" : 5,
        "x" : 1,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                "AWS/EC2",
                "StatusCheckFailed_Instance",
                "InstanceId",
                instance.id,
                { "region" : var.region }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "eu-west-2",
          "title" : "Status Check Failures (Instance)",
          "period" : 300,
          "stat" : "Average"
        }
      },
      {
        "height" : 8,
        "width" : 10,
        "y" : 5,
        "x" : 11,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                "AWS/EC2",
                "StatusCheckFailed_System",
                "InstanceId",
                instance.id,
                { "region" : var.region }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "eu-west-2",
          "title" : "Status Check Failures (System)",
          "period" : 300,
          "stat" : "Average"
        }
      },
      {
        "height" : 8,
        "width" : 10,
        "y" : 13,
        "x" : 11,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                namespace,
                "disk_used_percent",
                "path",
                "/",
                "host",
                instance.tags["Name"],
                "fstype",
                "xfs",
                { "region" : var.region }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "eu-west-2",
          "title" : "Disk Usage (root volume)",
          "period" : 300,
          "stat" : "Average"
        }
      },
      {
        "height" : 5,
        "width" : 7,
        "y" : 0,
        "x" : 1,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            [[{ "expression" : "SUM(METRICS())", "label" : "Failing", "id" : "count", "region" : "eu-west-2" }]],
            concat([
              for namespace, instances in local.all_instances_by_cw_namespace : [
                for index, instance in instances : [
                  "AWS/EC2",
                  "StatusCheckFailed_Instance",
                  "InstanceId",
                  instance.id,
                  { "id" : "m${index + 1}", "visible" : false, "region" : var.region }
                ]
              ]
            ]...)
          ]...),
          "view" : "singleValue",
          "region" : "eu-west-2",
          "yAxis" : {
            "left" : {
              "max" : 1,
              "min" : 0
            }
          },
          "setPeriodToTimeRange" : false,
          "sparkline" : true,
          "trend" : true,
          "liveData" : false,
          "legend" : {
            "position" : "bottom"
          },
          "title" : "Failing Status Checks (Instance)",
          "period" : 300,
          "stat" : "Maximum"
        }
      },
      {
        "height" : 5,
        "width" : 7,
        "y" : 0,
        "x" : 8,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            [[{ "expression" : "SUM(METRICS())", "label" : "Failing", "id" : "count" }]],
            concat([
              for namespace, instances in local.all_instances_by_cw_namespace : [
                for index, instance in instances : [
                  "AWS/EC2",
                  "StatusCheckFailed_Instance",
                  "InstanceId",
                  instance.id,
                  { "id" : "m${index + 1}", "visible" : false, "region" : var.region }
                ]
              ]
            ]...)
          ]...),
          "view" : "singleValue",
          "region" : "eu-west-2",
          "yAxis" : {
            "left" : {
              "max" : 1,
              "min" : 0
            }
          },
          "setPeriodToTimeRange" : false,
          "sparkline" : true,
          "trend" : true,
          "liveData" : false,
          "legend" : {
            "position" : "bottom"
          },
          "title" : "Failing Status Checks (System)",
          "period" : 300,
          "stat" : "Maximum",
          "stacked" : true
        }
      },
      {
        "height" : 8,
        "width" : 10,
        "y" : 13,
        "x" : 1,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                "AWS/EC2",
                "CPUUtilization",
                "InstanceId",
                instance.id,
                { "region" : var.region, }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "eu-west-2",
          "title" : "CPU Utilization (%)",
          "period" : 300,
          "stat" : "Average"
        }
      },
      {
        "height" : 8,
        "width" : 10,
        "y" : 29,
        "x" : 1,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                "AWS/EC2",
                "NetworkIn",
                "InstanceId",
                instance.id,
                { "region" : var.region, }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "eu-west-2",
          "title" : "Network In (bytes, all interfaces)",
          "period" : 300,
          "stat" : "Sum"
        }
      },
      {
        "height" : 8,
        "width" : 10,
        "y" : 29,
        "x" : 11,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            for namespace, instances in local.all_instances_by_cw_namespace : [
              for instance in instances : [
                "AWS/EC2",
                "NetworkOut",
                "InstanceId",
                instance.id,
                { "region" : var.region, }
              ]
            ]
          ]...),
          "view" : "timeSeries",
          "stacked" : false,
          "region" : "eu-west-2",
          "title" : "Network Out (bytes, all interfaces)",
          "period" : 300,
          "stat" : "Sum"
        }
      },
      {
        "height" : 5,
        "width" : 6,
        "y" : 0,
        "x" : 15,
        "type" : "metric",
        "properties" : {
          "metrics" : concat([
            [[{ "expression" : "SUM(METRICS())", "label" : "Unhealthy", "id" : "count" }]],
            [
              for index, target_group in values(data.aws_lb_target_group.frontend_alb) : [
                "AWS/NetworkELB",
                "UnHealthyHostCount",
                "TargetGroup",
                trimprefix(target_group.arn, "arn:aws:elasticloadbalancing:eu-west-2:${data.aws_caller_identity.current.account_id}:"),
                "LoadBalancer",
                trimprefix(data.aws_lb.frontend.arn, "arn:aws:elasticloadbalancing:eu-west-2:${data.aws_caller_identity.current.account_id}:loadbalancer/"),
                { "id" : "m${index + 1}", "visible" : false, "region" : var.region },
              ]
            ]
          ]...),
          "view" : "singleValue",
          "stacked" : false,
          "title" : "Unhealthy Host Count (Frontend NLB Target Groups)",
          "region" : "eu-west-2",
          "period" : 300,
          "stat" : "Maximum",
          "sparkline" : true
        }
      }
    ]
  })
}
