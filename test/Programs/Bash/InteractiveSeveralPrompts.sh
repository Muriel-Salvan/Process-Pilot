#!/bin/sh

echo "STDOUT Line 1."
echo -n "Enter string 1 from STDOUT: "
read VAR
echo "STDOUT Line 2: ${VAR}"
echo "STDERR Line 1." >&2
echo -n "Enter string 2 from STDERR: " >&2
read VAR
echo "STDOUT Line 3: ${VAR}"
echo "STDERR Line 2." >&2
