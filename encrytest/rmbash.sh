#!/bin/bash

#rm test
gpgde=$(gpg --batch --output test --passphrase pass --decrypt test.gpg &> /dev/null)
$gpgde
