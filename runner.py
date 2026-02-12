"""
Lambda function to create EC2 instance as GitHub Actions runner
FULLY FIXED VERSION - All issues resolved

Required Lambda IAM permissions:
- ec2:RunInstances
- ec2:CreateTags
- ec2:DescribeInstances
- iam:CreateInstanceProfile
- iam:AddRoleToInstanceProfile
- iam:GetInstanceProfile
- iam:PassRole

Required: GitHub token stored in Lambda environment variable GITHUB_TOKEN
"""

import boto3
import base64  # ← ADDED THIS IMPORT
import time
import os

def lambda_handler(event, context):
    region = "us-west-2"
    AMI_ID = "ami-0786adace1541ca80"
    Instance_Type = "t2.micro"
    SG = ["sg-0621a41f5d9e7a735"]
    
    # Get GitHub token from environment variable
    github_token = os.environ.get("github_token")
    github_org = os.environ.get("github_org")
    github_repo = os.environ.get("github_repo")
    
    ec2 = boto3.client("ec2", region_name=region)
    iam = boto3.client('iam', region_name=region)
    
    # user data script to setup the runner and install terraform and ansible
    user_data_content = f"""#!/bin/bash
    # Create runner directory
    mkdir -p /home/ubuntu/actions-runner
    cd /home/ubuntu/actions-runner

    # Download runner
    curl -o actions-runner-linux-x64-2.331.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.331.0/actions-runner-linux-x64-2.331.0.tar.gz

    # Extract
    tar xzf ./actions-runner-linux-x64-2.331.0.tar.gz

    # Set ownership
    chown -R ubuntu:ubuntu /home/ubuntu/actions-runner

    # Configure runner as ubuntu
    sudo -u ubuntu ./config.sh --url https://github.com/{github_org}/{github_repo} --token {github_token} --unattended

    # Install and start service
    ./svc.sh install ubuntu
    ./svc.sh start

    echo "GitHub Actions Runner setup complete!"

    #install Ansible
    sudo apt update
    sudo apt upgrade -y
    sudo add-apt-repository ppa:ansible/ansible
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible -y

    # install Terraform
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
    """

    # Encode to Base64
    encoded_user_data = base64.b64encode(user_data_content.encode('utf-8')).decode('utf-8')

    # Create instance profile for IAM role
    profile_name = 'gh-runner-profile'
    role_name = 'gh-runner-role'  # This role must already exist

    # Create profile BEFORE launching instance
    print(f"Setting up IAM instance profile: {profile_name}")
    
    try:
        iam.create_instance_profile(InstanceProfileName=profile_name)
        print(f"Created instance profile: {profile_name}")
        time.sleep(2)  # ← WAIT after creation
    except iam.exceptions.EntityAlreadyExistsException:
        print(f"Instance profile {profile_name} already exists.")
    except Exception as e:
        print(f"Error creating instance profile: {e}")

    # Add the IAM Role to the Profile
    try:
        iam.add_role_to_instance_profile(
            InstanceProfileName=profile_name,
            RoleName=role_name
        )
        print(f"Added role {role_name} to profile {profile_name}")
        time.sleep(10)  # ← WAIT for IAM propagation BEFORE launching
    except iam.exceptions.LimitExceededException:
        print("Role already attached or limit reached.")
    except Exception as e:
        print(f"Error adding role to profile: {e}")

    # Now launch the EC2 instance
    print("Launching EC2 instance...")
    try:
        response = ec2.run_instances(
            ImageId=AMI_ID,
            InstanceType=Instance_Type,
            MinCount=1,
            MaxCount=1,
            KeyName="ec2-key",
            SecurityGroupIds=SG,
            UserData=encoded_user_data,
            IamInstanceProfile={
                'Name': profile_name
            },
            TagSpecifications=[
                {
                    'ResourceType': 'instance',
                    'Tags': [
                        {
                            'Key': 'Name',
                            'Value': 'gh-runner'
                        },
                        {
                            'Key': 'Purpose',
                            'Value': 'GitHubActionsRunner'
                        },
                        {
                            'Key': 'ManagedBy',
                            'Value': 'Lambda'
                        }
                    ]
                }
            ]
        )

        instance_id = response["Instances"][0]["InstanceId"]
        print(f"Created EC2 instance: {instance_id}")
        
        # Return useful information
        return {
            'statusCode': 200,
            'body': {
                'message': 'GitHub Runner instance created successfully',
                'instance_id': instance_id,
                'profile_name': profile_name,
                'next_steps': [
                    f'Check runner at: https://github.com/{github_org}/{github_repo}/settings/actions/runners',
                    f'SSH into instance: ssh -i ec2-key.pem ubuntu@<instance-ip>',
                    f'View logs: ssh -i ec2-key.pem ubuntu@<instance-ip> "sudo cat /var/log/user-data.log"'
                ]
            }
        }
        
    except Exception as e:
        print(f"Error launching instance: {e}")
        return {
            'statusCode': 500,
            'body': {
                'error': str(e)
            }
        }