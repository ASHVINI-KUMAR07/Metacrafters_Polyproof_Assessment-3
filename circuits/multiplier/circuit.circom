pragma circom 2.0.0;

template MYCircuit () {  
   // These are the input signals for the given gate
   signal input m;
   signal input n;

   // Internal signals passed on to respective gate
   signal x;
   signal y;
   signal z;

   // output signals which are produced at the end
   signal output Q;

   // Components required
   component andGate1 = AND();
   component orGate = OR();
   component notGate = NOT();
   component andGate2 = AND();

   // logic for performing the operations
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
