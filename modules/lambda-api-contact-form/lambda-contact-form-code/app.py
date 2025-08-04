import json
import boto3
import os
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

table_name = os.environ['DYNAMODB_TABLE']
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    try:
        data = json.loads(event['body'])

        item = {
            'MessageID': str(uuid.uuid4()),
            'Name': data.get('name'),
            'Email': data.get('email'),
            'Message': data.get('message'),
            'SubmittedAt': datetime.utcnow().isoformat()
        }

        # Save to DynamoDB
        table.put_item(Item=item)

        # Publish to SNS
        sns.publish(
            TopicArn=sns_topic_arn,
            Subject="New Contact Form Message",
            Message=json.dumps(item, indent=2)
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Message saved and notification sent"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }