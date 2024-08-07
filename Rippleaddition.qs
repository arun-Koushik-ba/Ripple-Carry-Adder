namespace Quantum.Demo {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;

    operation ApplyCNOT(control: Qubit, target: Qubit) : Unit {
        CNOT(control, target);
    }

    operation ApplyToffoli(control1: Qubit, control2: Qubit, target: Qubit) : Unit {
        CCNOT(control1, control2, target);
    }

    operation RippleCarryAdder(a: Qubit[], b: Qubit[], carry: Qubit) : Unit {
        let n = Length(a);
        for i in 0..n-1 {
            ApplyToffoli(a[i], b[i], carry);
            ApplyCNOT(a[i], b[i]);
            ApplyToffoli(carry, b[i], a[i]);
        }
    }

    @EntryPoint()
    operation Main() : Result[] {
        use a = Qubit[2];
        use b = Qubit[2];
        use carry = Qubit();

        // Initialize qubits 
        X(a[0]); // a = 10 (binary for 2)
        X(b[1]); // b = 01 (binary for 1 )

        RippleCarryAdder(a, b, carry);

        let sum =[M(carry)] + MeasureEachZ(b);
        ResetAll(a);
        ResetAll(b);
        Reset(carry);
        return sum;
    }
}