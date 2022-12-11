resource "aws_cloudwatch_metric_alarm" "more_than_5_carts" {
  alarm_name                = "more_than_5_carts"
  namespace                 = "1014"
  metric_name               = "carts.value"

  comparison_operator       = "GreaterThanThreshold"
  threshold                 = "5"
  evaluation_periods        = "3"
  period                    = "300"

  statistic                 = "Maximum"

  alarm_description         = "This alarms goes off when there are more than 5 carts, three times in a row with a period of 5 minutes."
  insufficient_data_actions = []
  alarm_actions       = [aws_sns_topic.alarms.arn]
}