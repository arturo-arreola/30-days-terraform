output "account_id" {
  value = data.aws_caller_identity.name.account_id
}

output "user_names" {
  value = [for user in local.users : "${user.first_name} ${user.last_name}"]
}

output "user_passwords" {
  value = {
    for user, profile in aws_iam_user_login_profile.user_login : user => "password created - must be reset on first login"
  }
  sensitive = true
}