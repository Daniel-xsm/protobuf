#!/bin/bash
#
# This is the entry point for kicking off a Kokoro job. This path is referenced
# from the .cfg files in this directory.

set -ex

# Change to repo base.
cd $(dirname $0)/../../..

docker run $(test -t 0 && echo "-it") -v$PWD:/workspace gcr.io/protobuf-build/php/linux:8.0.5-dbg-fd99596d4c4c9b78f984ee667a9b26b91a28eb8d "composer test_valgrind"

docker run $(test -t 0 && echo "-it") -v$PWD:/workspace gcr.io/protobuf-build/php/linux:7.0.33-dbg-fd99596d4c4c9b78f984ee667a9b26b91a28eb8d "composer test && composer test_c"
docker run $(test -t 0 && echo "-it") -v$PWD:/workspace gcr.io/protobuf-build/php/linux:7.3.28-dbg-fd99596d4c4c9b78f984ee667a9b26b91a28eb8d "composer test && composer test_c"
docker run $(test -t 0 && echo "-it") -v$PWD:/workspace gcr.io/protobuf-build/php/linux:7.4.18-dbg-fd99596d4c4c9b78f984ee667a9b26b91a28eb8d "composer test && composer test_c"
docker run $(test -t 0 && echo "-it") -v$PWD:/workspace gcr.io/protobuf-build/php/linux:8.0.5-dbg-fd99596d4c4c9b78f984ee667a9b26b91a28eb8d "composer test && composer test_c"

# Run specialized memory leak & multirequest tests.
docker run $(test -t 0 && echo "-it") -v$PWD:/workspace gcr.io/protobuf-build/php/linux:8.0.5-dbg-fd99596d4c4c9b78f984ee667a9b26b91a28eb8d "composer test_c && tests/multirequest.sh && tests/memory_leak_test.sh"

# Most of our tests use a debug build of PHP, but we do one build against an opt
# php just in case that surfaces anything unexpected.
docker run $(test -t 0 && echo "-it") -v$PWD:/workspace gcr.io/protobuf-build/php/linux:8.0.5-fd99596d4c4c9b78f984ee667a9b26b91a28eb8d "composer test && composer test_c"
