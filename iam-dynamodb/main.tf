resource "aws_iam_role_policy" "dynamodb" {
  name   = "DynamoDB"
  role   = var.role
  policy = data.aws_iam_policy_document.dynamodb.json
}

data "aws_iam_policy_document" "dynamodb" {
  # Read
  dynamic "statement" {
    for_each = var.read ? ["read"] : []
    content {
      sid = "Read"
      actions = [
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:BatchGetItem"
      ]
      resources = [
        var.table,
        "${var.table}/index/*"
      ]
    }
  }

  # Write
  dynamic "statement" {
    for_each = var.write ? ["write"] : []
    content {
      sid = "Write"
      actions = [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:UpdateTimeToLive"
      ]
      resources = [var.table]
    }
  }

  # Delete
  dynamic "statement" {
    for_each = var.delte ? ["delete"] : []
    content {
      sid = "Delete"
      actions = [
        "dynamodb:Deleteitem"
      ]
      resources = [var.table]
    }
  }
}

# Stream
dynamic "statement" {
  for_each = var.delete ? ["delete"] : []
  content {
    sid = "Stream"
    actions = [
      "dynamodb:ListStreams",
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator"
    ]
    resources = [
      "${var.table}/stream/*"
    ]
  }
}
