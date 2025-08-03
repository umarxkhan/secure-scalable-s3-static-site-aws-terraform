import json
import boto3
import os
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMODB_TABLE']
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
        table.put_item(Item=item)
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Message saved successfully"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
