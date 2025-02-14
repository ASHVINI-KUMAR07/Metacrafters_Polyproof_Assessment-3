# FirstCircuit on Sepolia Testnet 🐱

## Introduction

This project involves the deployment of a custom circuit written in Circom on the Ethereum Sepolia testnet. The circuit includes basic logic gates (AND, OR, NOT) and combines them to form a simple logical operation. The primary functionality of the circuit is encapsulated in the `FirstCircuit` template.

## Circuit Description

### Templates
```
template MYCircuit () {  
   // input signals
   signal input m;
   signal input n;

   // Internal signals
   signal x;
   signal y;
   signal z;

   // output signals
   signal output Q;

   // components
   component andGate1 = AND();
   component orGate = OR();
   component notGate = NOT();
   component andGate2 = AND();

   // logic
   andGate1.m <== m;
   andGate1.n <== n;
   x <== andGate1.y;

   orGate.m <== m;
   orGate.n <== n;
   y <== orGate.y;

   notGate.in <== x;
   z <== notGate.out;

   andGate2.m <== y;
   andGate2.n <== z;
   Q <== andGate2.y;
}

template AND(){
   signal input m;
   signal input n;
   signal output y;
   y <== m * n;
}

template OR(){
   signal input m;
   signal input n;
   signal output y;
   y <== m + n - m * n;
}

template NOT() {
    signal input in;
    signal output out;
    out <== 1 + in - 2 * in;
}

component main = MYCircuit();
```
## Logic Gate
![circuit 2_explained](https://github.com/user-attachments/assets/7e92084d-454a-4b82-b060-edd59408cd69)

### Install
`npm i`

### Compile
`npx hardhat circom` 
This will generate the **out** file with circuit intermediaries and geneate the **MultiplierVerifier.sol** contract

### Prove and Deploy
`npx hardhat run scripts/deploy.ts --network sepolia`
This script does 4 things  
1. Deploys the MultiplierVerifier.sol contract
2. Generates a proof from circuit intermediaries with `generateProof()`
3. Generates calldata with `generateCallData()`
4. Calls `verifyProof()` on the verifier contract with calldata

With two commands you can compile a ZKP, generate a proof, deploy a verifier, and verify the proof 🎉

## Configuration
### Directory Structure
**circuits**
```
├── multiplier
│   ├── circuit.circom
│   ├── input.json
│   └── out
│       ├── circuit.wasm
│       ├── multiplier.r1cs
│       ├── multiplier.vkey
│       └── multiplier.zkey
├── new-circuit
└── powersOfTau28_hez_final_12.ptau
```
Each new circuit lives in it's own directory. At the top level of each circuit directory lives the circom circuit and input to the circuit.
The **out** directory will be autogenerated and store the compiled outputs, keys, and proofs. The Powers of Tau file comes from the Polygon Hermez ceremony, which saves time by not needing a new ceremony. 


**contracts**
```
contracts
└── MultiplierVerifier.sol
```
Verifier contracts are autogenerated and prefixed by the circuit name, in this example **Multiplier**

## hardhat.config.ts
```
  circom: {
    // (optional) Base path for input files, defaults to `./circuits/`
    inputBasePath: "./circuits",
    // (required) The final ptau file, relative to inputBasePath, from a Phase 1 ceremony
    ptau: "powersOfTau28_hez_final_12.ptau",
    // (required) Each object in this array refers to a separate circuit
    circuits: JSON.parse(JSON.stringify(circuits))
  },
```
### circuits.config.json
circuits configuation is separated from hardhat.config.ts for **autogenerated** purposes (see next section)
```
[
  {
    "name": "multiplier",
    "protocol": "groth16",
    "circuit": "multiplier/circuit.circom",
    "input": "multiplier/input.json",
    "wasm": "multiplier/out/circuit.wasm",
    "zkey": "multiplier/out/multiplier.zkey",
    "vkey": "multiplier/out/multiplier.vkey",
    "r1cs": "multiplier/out/multiplier.r1cs",
    "beacon": "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
  }
]
```

**adding circuits**   
To add a new circuit, you can run the `newcircuit` hardhat task to autogenerate configuration and directories i.e  
```
npx hardhat newcircuit --name newcircuit
``` 
## Author
Contributed by name : Ashvini Kumar
Email ID : ashvinikumarcuchd123@gmail.com

