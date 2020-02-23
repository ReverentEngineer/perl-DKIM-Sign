#!/bin/bash

TEST_KEY="./test.key"
TEST_CONFIG="./test.yaml"
TEST_MESSAGE="./testmsg"

# Setup cleanup trap
trap "rm -f ${TEST_KEY} ${TEST_CONFIG} ${TEST_MESSAGE}" 0 1 2 3 15

# Create private DKIM key
openssl genrsa -out ${TEST_KEY} 2> /dev/null

# Create DKIM config
cat << EOF > ${TEST_CONFIG}
- domain: example.com
  keyfile: ${TEST_KEY}
EOF

read -r -d '' VALID_SIGNEE << EOM
From: user1@example.com
To: user2@example.com
Subject: Test message

This is only a test.

EOM

read -r -d '' INVALID_SIGNEE << EOM
From: user1@example.org
To: user2@example.com
Subject: Test message

This is only a test.

EOM

OUTPUT=$(echo "$VALID_SIGNEE" | ./dkim_sign.pl ${TEST_CONFIG})

if [[ ! $OUTPUT =~ ^DKIM-Signature ]]; then
	echo "VALID_SIGNEE: failed"
	exit 1
else
	echo "VALID_SIGNEE: passed"
fi

OUTPUT=$(echo "$INVALID_SIGNEE" | ./dkim_sign.pl ${TEST_CONFIG})


if [[ $OUTPUT =~ ^DKIM-Signature ]]; then
	echo "INVALID_SIGNEE: failed"
	exit 1
else
	echo "INVALID_SIGNEE: passed"
fi

echo "ALL TESTS PASSED."
