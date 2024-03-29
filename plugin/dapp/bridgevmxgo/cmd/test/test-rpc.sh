#!/usr/bin/env bash
#shellcheck disable=SC2128
#shellcheck source=/dev/null
set -x
source ../dapp-test-common.sh

MAIN_HTTP=""

function rpc_test() {
    chain33_RpcTestBegin bridgevmxgo
    MAIN_HTTP="$1"
    echo "main_ip=$MAIN_HTTP"

    chain33_RpcTestRst bridgevmxgo "$CASE_ERR"
}

chain33_debug_function rpc_test "$1" "$2"
