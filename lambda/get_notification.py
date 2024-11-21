import boto3
import os

def lambda_handler(event, context):
    resource_type = os.getenv('RESOURCE_TYPE', 'EC2')
    sns_topic_arn = os.getenv('SNS_TOPIC_ARN')
    prefix = 'temp-ad-hoc-'

    if resource_type == 'EC2':
        ec2 = boto3.client('ec2')
        instances = ec2.describe_instances(Filters=[
            {'Name': 'instance-state-name', 'Values': ['running']}
        ])
        temp_instances = []
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                name = ''
                for tag in instance.get('Tags', []):
                    if tag['Key'] == 'Name':
                        name = tag['Value']
                        break
                if name.startswith(prefix):
                    temp_instances.append({'InstanceId': instance['InstanceId'], 'Name': name})

        if temp_instances:
            message = "The following EC2 instances are still running:\n"
            for inst in temp_instances:
                message += f"InstanceId: {inst['InstanceId']}, Name: {inst['Name']}\n"

            sns = boto3.client('sns')
            sns.publish(
                TopicArn=sns_topic_arn,
                Subject='Temp EC2 Instances Running',
                Message=message
            )

    return {
        'statusCode': 200,
        'body': 'Function executed successfully'
    }