#!/bin/bash
#bu sh ilgili container a jq kurar, json beautifier
JQ=/usr/bin/jq
curl https://stedolan.github.io/jq/download/linux64/jq > $JQ
chmod +x $JQ
ls -la $JQ