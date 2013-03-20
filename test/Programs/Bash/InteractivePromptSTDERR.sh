#!/bin/sh

echo "Hello World" >&2
echo -n "Enter string: " >&2
read VAR
echo "Hello ${VAR}" >&2
