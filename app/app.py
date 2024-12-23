import boto3
import datetime
import os
from dotenv import load_dotenv

load_dotenv()
SQS_QUEUE_URL = os.getenv("SQS_QUEUE_URL")
S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME")
AWS_REGION = os.getenv("AWS_REGION")


sqs_client = boto3.client('sqs', region_name=AWS_REGION)
s3_client = boto3.client('s3', region_name=AWS_REGION)

def receive_message_from_sqs():
    response = sqs_client.receive_message(
        QueueUrl=SQS_QUEUE_URL,
        MaxNumberOfMessages=1,
        WaitTimeSeconds=10
    )
    
    messages = response.get('Messages', [])
    if not messages:
        print("No messages available in SQS.")
        return None, None

    message = messages[0]
    receipt_handle = message['ReceiptHandle']
    body = message['Body']
    
    return body, receipt_handle

def save_to_s3(content):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    filename = f"{timestamp}.txt"
    try:
        s3_client.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=filename,
            Body=content
        )
        print(f"Message saved to S3 as {filename}")
        return True
    except Exception as e:
        print(f"Failed to save message to S3: {e}")
        return False

def delete_message_from_sqs(receipt_handle):
    try:
        sqs_client.delete_message(
            QueueUrl=SQS_QUEUE_URL,
            ReceiptHandle=receipt_handle
        )
        print("Message deleted from SQS.")
    except Exception as e:
        print(f"Failed to delete message from SQS: {e}")

def main():
    body, receipt_handle = receive_message_from_sqs()
    if body:
        print(f"Received message: {body}")
        if save_to_s3(body):
            delete_message_from_sqs(receipt_handle)

if __name__ == "__main__":
    main()
