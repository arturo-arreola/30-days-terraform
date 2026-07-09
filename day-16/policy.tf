data "aws_iam_policy_document" "sales_policy_doc" {
  statement {
    sid    = "AccessReadingSalesData"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::bucket-datos-ventas-ejemplo",
      "arn:aws:s3:::bucket-datos-ventas-ejemplo/*"
    ]
  }
}

data "aws_iam_policy_document" "management_policy_doc" {
  statement {
    sid    = "AccessListBucketManagement"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::bucket-datos-ventas-ejemplo",
      "arn:aws:s3:::bucket-datos-ventas-ejemplo/*"
    ]
  }
}

resource "aws_iam_policy" "sales_policy" {
  name        = "SalesDepartmentPolicy"
  description = "Politica basica con acceso de lectura para el equipo de ventas"
  policy      = data.aws_iam_policy_document.sales_policy_doc.json
}

resource "aws_iam_policy" "management_policy" {
  name        = "ManagementDepartmentPolicy"
  description = "Politica basica con acceso de lectura y escritura para el equipo de gerencia"
  policy      = data.aws_iam_policy_document.management_policy_doc.json
}

resource "aws_iam_group_policy_attachment" "sales_department_policy" {
  group      = aws_iam_group.sales.name
  policy_arn = aws_iam_policy.sales_policy.arn
  depends_on = [aws_iam_policy.sales_policy]
}

resource "aws_iam_group_policy_attachment" "management_department_policy" {
  group      = aws_iam_group.management.name
  policy_arn = aws_iam_policy.management_policy.arn
  depends_on = [aws_iam_policy.management_policy]
}