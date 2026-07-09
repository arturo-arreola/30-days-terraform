resource "aws_iam_group" "sales" {
  name = "Sales"
  path = "/sales/"
}

resource "aws_iam_group" "accounting" {
  name = "Accounting"
  path = "/accounting/"
}

resource "aws_iam_group" "management" {
  name = "Management"
  path = "/management/"
}

resource "aws_iam_group_membership" "sales_membership" {
  name  = "SalesMembership"
  group = aws_iam_group.sales.name
  users = [for user in aws_iam_user.users : user.name if user.tags.Department == "Sales"]
}

resource "aws_iam_group_membership" "accounting_membership" {
  name  = "AccountingMembership"
  group = aws_iam_group.accounting.name
  users = [for user in aws_iam_user.users : user.name if user.tags.Department == "Accounting"]
}

resource "aws_iam_group_membership" "management_membership" {
  name  = "ManagementMembership"
  group = aws_iam_group.management.name
  users = [for user in aws_iam_user.users : user.name if contains(["Education", "Corporate"], user.tags.Department)]
}