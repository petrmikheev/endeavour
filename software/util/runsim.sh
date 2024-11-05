#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BIN=$(realpath $1)

cd ${SCRIPT_DIR}/../../rtl/testbench && make run ARGS="+uart=${SCRIPT_DIR}/jump4mb.packed +ram=${BIN} +ram_offset=400000 ${@:2}"
