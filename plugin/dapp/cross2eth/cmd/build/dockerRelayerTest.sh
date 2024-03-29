#!/usr/bin/env bash
# shellcheck disable=SC2128
# shellcheck source=/dev/null
set -x
set +e

# 主要在平行链上测试

source "./mainPubilcRelayerTest.sh"
IYellow="\033[0;93m"
le8=100000000

function start_docker_ebrelayerProxy() {
    updata_toml proxy
    # 代理转账中继器中的标志位ProcessWithDraw设置为true
    sed -i 's/^ProcessWithDraw=.*/ProcessWithDraw=true/g' "./relayerproxy.toml"

    # shellcheck disable=SC2154
    docker cp "./relayerproxy.toml" "${dockerNamePrefix}_ebrelayerproxy_1":/root/relayer.toml
    start_docker_ebrelayer "${dockerNamePrefix}_ebrelayerproxy_1" "/root/ebrelayer" "./ebrelayerproxy.log"
    sleep 1

    # shellcheck disable=SC2154
    init_validator_relayer "${CLIP}" "${validatorPwd}" "${chain33ValidatorKeyp}" "${ethValidatorAddrKeyp}"
}

function setWithdraw() {
    result=$(${CLIP} ethereum cfgWithdraw -f 1 -s ETH -a 100 -d 18)
    cli_ret "${result}" "cfgWithdraw"
    result=$(${CLIP} ethereum cfgWithdraw -f 1 -s USDT -a 100 -d 6)
    cli_ret "${result}" "cfgWithdraw"

    # 在chain33上的bridgeBank合约中设置proxyReceiver
    # shellcheck disable=SC2154
    ${Boss4xCLI} chain33 offline set_withdraw_proxy -c "${chain33BridgeBank}" -a "${chain33Validatorsp}" -k "${chain33DeployKey}" -n "set_withdraw_proxy:${chain33Validatorsp}"
    chain33_offline_send "set_withdraw_proxy.txt"
}

# eth to chain33 在以太坊上锁定 ETH 资产,然后在 chain33 上 withdraw
function TestETH2Chain33Assets_proxy() {
    echo -e "${GRE}=========== $FUNCNAME begin ===========${NOC}"
    echo -e "${GRE}=========== eth to chain33 在以太坊上锁定 ETH 资产,然后在 chain33 上 withdraw ===========${NOC}"

    echo -e "${IYellow} lockAmount1 $1 ${NOC}"
    local lockAmount1=$1

    echo -e "${IYellow} ethBridgeBank 初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethBridgeBankBalancebf=$(${CLIP} ethereum balance -o "${ethBridgeBank}" | jq -r ".balance")

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    chain33RBalancebf=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33ReceiverAddr})")

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址初始金额 ${NOC}"
    chain33VspBalancebf=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33Validatorsp})")

    echo -e "${IYellow} lock ${NOC}"
    # shellcheck disable=SC2154
    result=$(${CLIP} ethereum lock -m "${lockAmount1}" -k "${ethTestAddrKey1}" -r "${chain33ReceiverAddr}")
    cli_ret "${result}" "lock"

    # eth 等待 2 个区块
    sleep 4

    echo -e "${IYellow} ethBridgeBank lock 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}")
    # shellcheck disable=SC2219
    let ethBridgeBankBalanceEnd=ethBridgeBankBalancebf+lockAmount1
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    # shellcheck disable=SC2086
    sleep "${maturityDegree}"

    # chain33 chain33EthBridgeTokenAddr（ETH合约中）查询 lock 金额
    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 lock 后金额 ${NOC}"
    # shellcheck disable=SC2154
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33ReceiverAddr})")
    # shellcheck disable=SC2219
    let chain33RBalancelock=lockAmount1*le8+chain33RBalancebf
    is_equal "${result}" "${chain33RBalancelock}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 lock 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33Validatorsp})")
    is_equal "${result}" "${chain33VspBalancebf}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethT2Balancebf=$(${CLIP} ethereum balance -o "${ethTestAddr2}" | jq -r ".balance")

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethPBalancebf=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" | jq -r ".balance")

    echo -e "${IYellow} withdraw ${NOC}"
    # shellcheck disable=SC2154
    result=$(${CLIP} chain33 withdraw -m "${lockAmount1}" -k "${chain33ReceiverAddrKey}" -r "${ethTestAddr2}" -t "${chain33EthBridgeTokenAddr}")
    cli_ret "${result}" "withdraw"

    sleep "${maturityDegree}"

    # 查询 ETH 这端 bridgeBank 地址 0
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}")
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33ReceiverAddr})")
    is_equal "${result}" "${chain33RBalancebf}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33Validatorsp})")
    # shellcheck disable=SC2219
    let chain33VspBalancewithdraw=lockAmount1*le8+chain33VspBalancebf
    is_equal "${result}" "${chain33VspBalancewithdraw}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址 withdraw 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethTestAddr2}" | jq -r ".balance")
    ethT2BalanceEnd=$(echo "${ethT2Balancebf}+${lockAmount1}-1" | bc)
    is_equal "${result}" "${ethT2BalanceEnd}"

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址 withdraw 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" | jq -r ".balance")

    if [[ $(echo "${ethPBalancebf}-${lockAmount1}+1 < $result" | bc) == 1 ]]; then
        echo -e "${RED}error $ethPBalanceEnd 小于 $result, 应该大于 $ethPBalanceEnd 扣了一点点手续费 ${NOC}"
        exit 1
    fi

    echo -e "${GRE}=========== $FUNCNAME end ===========${NOC}"
}

# eth to chain33 在以太坊上锁定 ETH 资产,然后在 chain33 上 withdraw
function TestETH2Chain33Assets_proxy_excess() {
    echo -e "${GRE}=========== $FUNCNAME 超额 begin ===========${NOC}"
    echo -e "${GRE}=========== eth to chain33 在以太坊上锁定 ETH 资产,然后在 chain33 上 withdraw ===========${NOC}"

    echo -e "${IYellow} lockAmount1 $1 ${NOC}"
    local lockAmount1=$1

    echo -e "${IYellow} ethBridgeBank 初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethBridgeBankBalancebf=$(${CLIP} ethereum balance -o "${ethBridgeBank}" | jq -r ".balance")

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    chain33RBalancebf=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33ReceiverAddr})")

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址初始金额 ${NOC}"
    chain33VspBalancebf=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33Validatorsp})")

    echo -e "${IYellow} lock ${NOC}"
    # shellcheck disable=SC2154
    result=$(${CLIP} ethereum lock -m "${lockAmount1}" -k "${ethTestAddrKey1}" -r "${chain33ReceiverAddr}")
    cli_ret "${result}" "lock"

    # eth 等待 2 个区块
    sleep 4

    echo -e "${IYellow} ethBridgeBank lock 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}")
    # shellcheck disable=SC2219
    let ethBridgeBankBalanceEnd=ethBridgeBankBalancebf+lockAmount1
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    # shellcheck disable=SC2086
    sleep "${maturityDegree}"

    # chain33 chain33EthBridgeTokenAddr（ETH合约中）查询 lock 金额
    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 lock 后金额 ${NOC}"
    # shellcheck disable=SC2154
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33ReceiverAddr})")
    # shellcheck disable=SC2219
    let chain33RBalancelock=lockAmount1*le8+chain33RBalancebf
    is_equal "${result}" "${chain33RBalancelock}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 lock 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33Validatorsp})")
    is_equal "${result}" "${chain33VspBalancebf}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethT2Balancebf=$(${CLIP} ethereum balance -o "${ethTestAddr2}" | jq -r ".balance")

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethPBalancebf=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" | jq -r ".balance")

    echo -e "${IYellow} withdraw ${NOC}"
    # shellcheck disable=SC2154
    result=$(${CLIP} chain33 withdraw -m "${lockAmount1}" -k "${chain33ReceiverAddrKey}" -r "${ethTestAddr2}" -t "${chain33EthBridgeTokenAddr}")
    cli_ret "${result}" "withdraw"

    sleep "${maturityDegree}"

    # 查询 ETH 这端 bridgeBank 地址 0
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}")
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33ReceiverAddr})")
    is_equal "${result}" "${chain33RBalancebf}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33EthBridgeTokenAddr}" -c "${chain33DeployAddr}" -b "balanceOf(${chain33Validatorsp})")
    # shellcheck disable=SC2219
    let chain33VspBalancewithdraw=lockAmount1*le8+chain33VspBalancebf
    is_equal "${result}" "${chain33VspBalancewithdraw}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址 withdraw 后金额 超额了金额跟之前一样${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethTestAddr2}" | jq -r ".balance")
    is_equal "${result}" "${ethT2Balancebf}"

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址 withdraw 后金额 超额了金额跟之前一样${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" | jq -r ".balance")
    is_equal "${result}" "${ethPBalancebf}"

    echo -e "${GRE}=========== $FUNCNAME end ===========${NOC}"
}

function TestETH2Chain33USDT_proxy() {
    echo -e "${GRE}=========== $FUNCNAME begin ===========${NOC}"
    echo -e "${GRE}=========== eth to chain33 在以太坊上锁定 USDT 资产,然后在 chain33 上 withdraw ===========${NOC}"

    echo -e "${IYellow} lockAmount1 $1 ${NOC}"
    local lockAmount1=$1

    echo -e "${IYellow} ethBridgeBank 初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethBridgeBankBalancebf=$(${CLIP} ethereum balance -o "${ethBridgeBank}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    chain33RBalancebf=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33ReceiverAddr})")

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址初始金额 ${NOC}"
    chain33VspBalancebf=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33Validatorsp})")

    echo -e "${IYellow} ETH 这端 lock $lockAmount1 个 USDT ${NOC}"
    result=$(${CLIP} ethereum lock -m "${lockAmount1}" -k "${ethTestAddrKey1}" -r "${chain33ReceiverAddr}" -t "${ethereumUSDTERC20TokenAddr}")
    cli_ret "${result}" "lock"

    # eth 等待 2 个区块
    sleep 4

    echo -e "${IYellow} 查询 ETH 这端 ethBridgeBank lock 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}" -t "${ethereumUSDTERC20TokenAddr}")
    # shellcheck disable=SC2219
    let ethBridgeBankBalanceEnd=ethBridgeBankBalancebf+lockAmount1
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    sleep "${maturityDegree}"

    # chain33 chain33EthBridgeTokenAddr（ETH合约中）查询 lock 金额
    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 lock 后金额 ${NOC}"
    # shellcheck disable=SC2154
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33ReceiverAddr})")
    # shellcheck disable=SC2219
    let chain33RBalancelock=lockAmount1*le8+chain33RBalancebf
    is_equal "${result}" "${chain33RBalancelock}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 lock 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33Validatorsp})")
    is_equal "${result}" "${chain33VspBalancebf}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethT2Balancebf=$(${CLIP} ethereum balance -o "${ethReceiverAddr1}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethPBalancebf=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")

    echo -e "${IYellow} withdraw ${NOC}"
    result=$(${CLIP} chain33 withdraw -m "${lockAmount1}" -k "${chain33ReceiverAddrKey}" -r "${ethReceiverAddr1}" -t "${chain33USDTBridgeTokenAddr}")
    cli_ret "${result}" "withdraw"

    sleep "${maturityDegree}"

    # 查询 ETH 这端 bridgeBank 地址 0
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}" -t "${ethereumUSDTERC20TokenAddr}")
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33ReceiverAddr})")
    is_equal "${result}" "${chain33RBalancebf}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33Validatorsp})")
    # shellcheck disable=SC2219
    let chain33VspBalancewithdraw=lockAmount1*le8+chain33VspBalancebf
    is_equal "${result}" "${chain33VspBalancewithdraw}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址 withdraw 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethReceiverAddr1}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")
    ethT2BalanceEnd=$(echo "${ethT2Balancebf}+${lockAmount1}-1" | bc)
    is_equal "${result}" "${ethT2BalanceEnd}"

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址 withdraw 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")
    # shellcheck disable=SC2219
    let ethPBalanceEnd=ethPBalancebf-lockAmount1+1
    is_equal "${result}" "${ethPBalanceEnd}"

    echo -e "${GRE}=========== $FUNCNAME end ===========${NOC}"
}

function TestETH2Chain33USDT_proxy_excess() {
    echo -e "${GRE}=========== $FUNCNAME begin ===========${NOC}"
    echo -e "${GRE}=========== eth to chain33 在以太坊上锁定 USDT 资产,然后在 chain33 上 withdraw ===========${NOC}"

    echo -e "${IYellow} lockAmount1 $1 ${NOC}"
    local lockAmount1=$1

    echo -e "${IYellow} ethBridgeBank 初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethBridgeBankBalancebf=$(${CLIP} ethereum balance -o "${ethBridgeBank}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    chain33RBalancebf=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33ReceiverAddr})")

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址初始金额 ${NOC}"
    chain33VspBalancebf=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33Validatorsp})")

    echo -e "${IYellow} ETH 这端 lock $lockAmount1 个 USDT ${NOC}"
    result=$(${CLIP} ethereum lock -m "${lockAmount1}" -k "${ethTestAddrKey1}" -r "${chain33ReceiverAddr}" -t "${ethereumUSDTERC20TokenAddr}")
    cli_ret "${result}" "lock"

    # eth 等待 2 个区块
    sleep 4

    echo -e "${IYellow} 查询 ETH 这端 ethBridgeBank lock 后金额 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}" -t "${ethereumUSDTERC20TokenAddr}")
    # shellcheck disable=SC2219
    let ethBridgeBankBalanceEnd=ethBridgeBankBalancebf+lockAmount1
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    sleep "${maturityDegree}"

    # chain33 chain33EthBridgeTokenAddr（ETH合约中）查询 lock 金额
    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 lock 后金额 ${NOC}"
    # shellcheck disable=SC2154
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33ReceiverAddr})")
    # shellcheck disable=SC2219
    let chain33RBalancelock=lockAmount1*le8+chain33RBalancebf
    is_equal "${result}" "${chain33RBalancelock}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 lock 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33Validatorsp})")
    is_equal "${result}" "${chain33VspBalancebf}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethT2Balancebf=$(${CLIP} ethereum balance -o "${ethReceiverAddr1}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址初始金额 ${NOC}"
    # shellcheck disable=SC2154
    ethPBalancebf=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")

    echo -e "${IYellow} withdraw ${NOC}"
    result=$(${CLIP} chain33 withdraw -m "${lockAmount1}" -k "${chain33ReceiverAddrKey}" -r "${ethReceiverAddr1}" -t "${chain33USDTBridgeTokenAddr}")
    cli_ret "${result}" "withdraw"

    sleep "${maturityDegree}"

    # 查询 ETH 这端 bridgeBank 地址 0
    result=$(${CLIP} ethereum balance -o "${ethBridgeBank}" -t "${ethereumUSDTERC20TokenAddr}")
    cli_ret "${result}" "balance" ".balance" "${ethBridgeBankBalanceEnd}"

    echo -e "${IYellow} chain33ReceiverAddr chain33 端 lock 后接收地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33ReceiverAddr})")
    is_equal "${result}" "${chain33RBalancebf}"

    echo -e "${IYellow} chain33Validatorsp chain33 代理地址 withdraw 后金额 ${NOC}"
    result=$(${Chain33Cli} evm query -a "${chain33USDTBridgeTokenAddr}" -c "${chain33TestAddr1}" -b "balanceOf(${chain33Validatorsp})")
    # shellcheck disable=SC2219
    let chain33VspBalancewithdraw=lockAmount1*le8+chain33VspBalancebf
    is_equal "${result}" "${chain33VspBalancewithdraw}"

    echo -e "${IYellow} ethTestAddr2 ethereum withdraw 接收地址 withdraw 后金额  超额了金额跟之前一样 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethReceiverAddr1}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")
    is_equal "${result}" "${ethT2Balancebf}"

    echo -e "${IYellow} ethValidatorAddrp ethereum 代理地址 withdraw 后金额  超额了金额跟之前一样 ${NOC}"
    result=$(${CLIP} ethereum balance -o "${ethValidatorAddrp}" -t "${ethereumUSDTERC20TokenAddr}" | jq -r ".balance")
    is_equal "${result}" "${ethPBalancebf}"

    echo -e "${GRE}=========== $FUNCNAME end ===========${NOC}"
}

function TestRelayerProxy() {
    start_docker_ebrelayerProxy
    setWithdraw

    TestETH2Chain33Assets_proxy 20
    TestETH2Chain33Assets_proxy 30
    TestETH2Chain33Assets_proxy_excess 100

    # shellcheck disable=SC2154
    ${CLIP} ethereum token token_transfer -k "${ethTestAddrKey1}" -m 500 -r "${ethValidatorAddrp}" -t "${ethereumUSDTERC20TokenAddr}"
    TestETH2Chain33USDT_proxy 20
    TestETH2Chain33USDT_proxy 40
    TestETH2Chain33USDT_proxy_excess 100
}

function AllRelayerMainTest() {
    echo -e "${GRE}=========== $FUNCNAME begin ===========${NOC}"
    set +e

    if [[ ${1} != "" ]]; then
        maturityDegree=${1}
        echo -e "${GRE}maturityDegree is ${maturityDegree} ${NOC}"
    fi

    # shellcheck disable=SC2120
    if [[ $# -ge 2 ]]; then
        # shellcheck disable=SC2034
        chain33ID="${2}"
    fi

    get_cli

    # init
    # shellcheck disable=SC2154
    # shellcheck disable=SC2034
    Chain33Cli=${MainCli}
    InitChain33Validator
    # para add
    initPara

    StartDockerRelayerDeploy
    test_all

    TestRelayerProxy

    echo_addrs
    echo -e "${GRE}=========== $FUNCNAME end ===========${NOC}"
}
