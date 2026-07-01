#!/bin/bash
set -e
FLUTTER_VERSION="3.44.3"
git clone https://github.com/flutter/flutter.git -b stable
cd flutter
git checkout $FLUTTER_VERSION
./bin/flutter --version
./bin/flutter config --no-analytics
