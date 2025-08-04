resource "aws_sns_topic" "contact_form_topic" {
  name = "contact-form-submissions"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.contact_form_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
