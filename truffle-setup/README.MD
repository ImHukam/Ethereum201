commands
compile: truffle migrate --reset
deploy : truffle deploy --network testnet
verify recent deploy: truffle run verify 'contractname' --network testnet
verify for address: truffle run verify 'contract name'@oxdfdf --network testing
