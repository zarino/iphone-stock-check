# iPhone stock checker

Searches for iPhone SE (Space Grey, 64GB) stock availability at Liverpool ONE Apple Store.

## Installation

Create a file containing the email address at which you’d like receive notifications:

    echo "mail@example.com" > email.txt

Replace `/Users/zarinozappia/repos/iphone-stock-check/` in `uk.co.zarino.iphonestockcheck.plist` with the path to your checkout of this repo.

Install the plist and tell launchd to use it:

    mkdir -p ~/Library/LaunchAgents/
    cp uk.co.zarino.iphonestockcheck.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/uk.co.zarino.iphonestockcheck.plist

Check it’s installed:

    launchctl list | grep zarino

## Uninstallation

    launchctl unload -w ~/Library/LaunchAgents/uk.co.zarino.iphonestockcheck.plist
    rm ~/Library/LaunchAgents/uk.co.zarino.iphonestockcheck.plist
