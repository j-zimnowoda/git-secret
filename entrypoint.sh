#!/bin/sh
set -e
echo $GPG_PRIVATE_KEY|base64 -d > ./private_key.gpg
# Import private key
gpg --no-tty --import ./private_key.gpg

git secret $@