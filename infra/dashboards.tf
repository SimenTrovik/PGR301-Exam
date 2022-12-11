resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.candidate_id
  ## Jim; seriously! we can use any word here.. How cool is that?
  dashboard_body = <<DEATHSTAR
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 10,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${var.candidate_id}",
            "carts.value"
          ]
        ],
        "period": 300,
        "stat": "Maximum",
        "region": "eu-west-1",
        "title": "Total number of carts"
      }
    },
    {
      "type": "metric",
      "x": 10,
      "y": 0,
      "width": 10,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${var.candidate_id}",
            "cartsvalue.value"
          ]
        ],
        "period": 300,
        "stat": "Maximum",
        "region": "eu-west-1",
        "title": "Total value of carts"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 10,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${var.candidate_id}",
            "checkouts.count"
          ]
        ],
        "period": 3600,
        "stat": "Sum",
        "region": "eu-west-1",
        "title": "Total number of checkouts per hour"
      }
    },
    {
      "type": "metric",
      "x": 10,
      "y": 6,
      "width": 10,
      "height": 6,
      "properties": {
         "metrics": [[ "1014", "checkout-latency.avg", "exception", "none", "method", "checkout", "class", "no.shoppifly.ShoppingCartController" ]],
         "period": 300,
         "view": "timeSeries","stacked": false,
         "region": "eu-west-1",
         "title": "Checkout response time"
      }
    }
  ]
}
DEATHSTAR
}