#!/bin/bash
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