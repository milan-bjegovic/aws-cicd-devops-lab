resource "aws_sns_topic" "alerts" {
  name = "devops-lab-alerts"
}

resource "aws_cloudwatch_log_group" "nginx_access" {
  name = "/devops-lab/nginx/access"
}

resource "aws_cloudwatch_log_group" "nginx_error" {
  name = "/devops-lab/nginx/error"
}

resource "aws_cloudwatch_log_group" "nginx_latency" {
  name = "/devops-lab/nginx/latency"
}

resource "aws_cloudwatch_metric_alarm" "ec2_status_check" {
  alarm_name          = "devops-lab-ec2-status-check"
  alarm_description   = "Triggers when the EC2 instance status check fails on devops-lab-01."
  datapoints_to_alarm = 1
  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed"
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "devops-lab-high-cpu"
  alarm_description   = "Triggers when average CPU utilization exceeds 70% for 5 minutes on devops-lab-01."
  datapoints_to_alarm = 1
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 70
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "high_disk" {
  alarm_name          = "devops-lab-high-disk"
  alarm_description   = "Triggers when root filesystem usage reaches or exceeds 80% on devops-lab-01."
  datapoints_to_alarm = 1
  namespace           = "CWAgent"
  metric_name         = "disk_used_percent"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    path       = "/"
    InstanceId = aws_instance.app.id
    device     = "nvme0n1p1"
    fstype     = "ext4"
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "devops-lab-high-memory"
  alarm_description   = "Triggers when average memory utilization exceeds 80% on devops-lab-01."
  datapoints_to_alarm = 1
  namespace           = "CWAgent"
  metric_name         = "mem_used_percent"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "nginx_4xx" {
  alarm_name          = "devops-lab-nginx-4xx"
  alarm_description   = "Triggers when 10 or more Nginx 4xx responses occur within 5 minutes."
  datapoints_to_alarm = 1
  namespace           = "DevOpsLab"
  metric_name         = "Nginx4xxErrors"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 10
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "nginx_5xx" {
  alarm_name          = "devops-lab-nginx-5xx"
  alarm_description   = "riggers when one or more Nginx 5xx responses occur within 5 minutes."
  datapoints_to_alarm = 1
  namespace           = "DevOpsLab"
  metric_name         = "Nginx5xxErrors"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "devops-lab-dashboard"
  dashboard_body = file("${path.module}/dashboard.json")
}
