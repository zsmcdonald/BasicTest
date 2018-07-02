#!/bin/bash

path=`pwd`
ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

echo "$ABSOLUTE_PATH"
