#!/bin/bash

ZKGO=../../bin/zkgo
delphinus_cli=../../..//bin/delphinus-cli #can't move it out.


# Must use zkGo to build
GOOS=wasip1 GOARCH=wasm $ZKGO build -gcflags=all=-d=softfloat -o fib_with_input.wasm fib_zkgo.go

echo 0 | python3 write_witness.py > input.dat
echo 1 | python3 write_witness.py >> input.dat
echo 817770325994397771 | python3 write_witness.py >> input.dat

# Require node > 20
node ../zkWasm-emulator/wasi/wasi_exec_node.js fib_with_input.wasm input.dat

$delphinus_cli -k 22 --wasm fib_with_input.wasm  --function zkmain dry-run --public 0:i64 --public 1:i64 --public 817770325994397771:i64

echo "Success dry_run"