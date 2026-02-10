#!bin/bash

# Create a folder
mkdir actions-runner && cd actions-runner
# Download the latest runner package
curl -o actions-runner-linux-x64-2.331.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.331.0/actions-runner-linux-x64-2.331.0.tar.gz
# # Optional: Validate the hash
# echo "5fcc01bd546ba5c3f1291c2803658ebd3cedb3836489eda3be357d41bfcf28a7  actions-runner-linux-x64-2.331.0.tar.gz" | shasum -a 256 -cCopied!
# Extract the installer
tar xzf ./actions-runner-linux-x64-2.331.0.tar.gz
# Create the runner and start the configuration experience
./config.sh --url https://github.com/AlShaymaaHamdan/MagicVillaApp --token ** # add token
# Last step, run it!
./run.sh
