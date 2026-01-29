#!/bin/bash
## Start of bash preamble
if [ -z ${CONDA_BUILD+x} ]; then
    source "/Users/uwe/Development/conda-forge/staged-recipes/recipes/bun/output/bld/rattler-build_bun_1769679891/work/build_env.sh"
fi
## End of preamble

#!/bin/bash

set -exuo pipefail

# bun needs to be on the PATH for the scripts to work
export PATH="$(pwd)/bun.native:${PATH}"

# bun run build:release

exit 1
