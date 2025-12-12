// 19235
const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");

const machines = text.split(/\r?\n/).map((line) => {
    const [, rest] = line.split("]");
    const [buttonsRaw, joltageRaw] = rest.split("{");
    const buttons = buttonsRaw
        .trim()
        .split(")")
        .filter((l) => l.length)
        .map((btn) =>
            btn
                .trim()
                .slice(1)
                .split(",")
                .map(Number)
        );
    const joltage = joltageRaw.slice(0, joltageRaw.length - 1).split(",").map(Number);
    return { buttons, joltage };
});

// Fraction utilities to stay exact.
const gcd = (a, b) => {
    let x = Math.abs(a);
    let y = Math.abs(b);
    while (y !== 0) {
        const t = y;
        y = x % y;
        x = t;
    }
    return x;
};
const lcm = (a, b) => (a === 0 || b === 0 ? 0 : Math.abs((a / gcd(a, b)) * b));

const simplify = (num, den) => {
    if (den < 0) {
        num = -num;
        den = -den;
    }
    const g = gcd(num, den);
    return [num / g, den / g];
};

const addFrac = ([a, b], [c, d]) => {
    const num = a * d + c * b;
    const den = b * d;
    return simplify(num, den);
};
const subFrac = ([a, b], [c, d]) => addFrac([a, b], [-c, d]);
const mulFrac = ([a, b], [c, d]) => simplify(a * c, b * d);
const divFrac = ([a, b], [c, d]) => simplify(a * d, b * c);

// Gaussian elimination over rationals to reduced row echelon form.
const rref = (A, b) => {
    const m = A.length;
    const n = A[0].length;

    // Represent as fractions [num, den].
    const M = Array.from({ length: m }, (_, i) =>
        Array.from({ length: n + 1 }, (_, j) =>
            j === n ? [b[i], 1] : [A[i][j], 1]
        )
    );

    let row = 0;
    for (let col = 0; col < n && row < m; col++) {
        // Find pivot.
        let pivot = -1;
        for (let r = row; r < m; r++) {
            const [num] = M[r][col];
            if (num !== 0) {
                pivot = r;
                break;
            }
        }
        if (pivot === -1) continue;

        // Swap.
        [M[row], M[pivot]] = [M[pivot], M[row]];

        // Normalize pivot row.
        const pivotVal = M[row][col];
        for (let c = col; c <= n; c++) {
            M[row][c] = divFrac(M[row][c], pivotVal);
        }

        // Eliminate other rows.
        for (let r = 0; r < m; r++) {
            if (r === row) continue;
            const factor = M[r][col];
            if (factor[0] === 0) continue;
            for (let c = col; c <= n; c++) {
                const prod = mulFrac(factor, M[row][c]);
                M[r][c] = subFrac(M[r][c], prod);
            }
        }

        row++;
    }

    return M;
};

// Derive solution space from RREF: returns {particular, basis}, all fractions.
const solutionSpace = (A, b) => {
    const m = A.length;
    const n = A[0].length;
    const M = rref(A, b);

    // Identify pivots.
    const pivotCol = Array(n).fill(-1);
    let r = 0;
    for (let c = 0; c < n && r < m; c++) {
        if (M[r][c][0] === 1 && M[r][c][1] === 1) {
            pivotCol[c] = r;
            r++;
        }
    }

    // Check inconsistency: 0 ... 0 | nonzero
    for (; r < m; r++) {
        let allZero = true;
        for (let c = 0; c < n; c++) {
            if (M[r][c][0] !== 0) {
                allZero = false;
                break;
            }
        }
        if (allZero && M[r][n][0] !== 0) return null;
    }

    const freeCols = [];
    for (let c = 0; c < n; c++) if (pivotCol[c] === -1) freeCols.push(c);

    // Build particular solution (free variables = 0).
    const p = Array(n).fill([0, 1]);
    for (let c = 0; c < n; c++) {
        const pr = pivotCol[c];
        if (pr !== -1) {
            p[c] = M[pr][n];
        }
    }

    const basis = [];
    freeCols.forEach((fc) => {
        const vec = Array(n).fill([0, 1]);
        vec[fc] = [1, 1]; // free var = 1
        for (let c = 0; c < n; c++) {
            const pr = pivotCol[c];
            if (pr !== -1) {
                // x_c = rhs - sum(free * coeff)
                vec[c] = mulFrac(M[pr][fc], [-1, 1]);
            }
        }
        basis.push(vec);
    });

    return { particular: p, basis };
};

const fracToIntVectors = (vecs) => {
    // Return lcm of denominators and integer-scaled vectors.
    let L = 1;
    vecs.forEach((v) =>
        v.forEach(([, den]) => {
            L = lcm(L, den);
        })
    );
    const toInt = (v) => v.map(([num, den]) => (num * (L / den)));
    return { L, intVecs: vecs.map(toInt) };
};

const solveMachine = (machine) => {
    const counters = machine.joltage.length;
    const buttons = machine.buttons.length;
    if (buttons === 0) {
        return machine.joltage.every((v) => v === 0) ? 0 : Infinity;
    }

    // Build A (counters x buttons)
    const A = Array.from({ length: counters }, () => Array(buttons).fill(0));
    machine.buttons.forEach((btn, j) => {
        btn.forEach((idx) => {
            A[idx][j] = 1;
        });
    });
    const b = machine.joltage;

    const sol = solutionSpace(A, b);
    if (!sol) return Infinity;

    const { particular: pFrac, basis: bFrac } = sol;
    if (bFrac.length === 0) {
        const { L, intVecs } = fracToIntVectors([pFrac]);
        const x = intVecs[0].map((v) => v / L);
        if (x.every((v) => Number.isInteger(v) && v >= 0)) {
            return x.reduce((a, c) => a + c, 0);
        }
        return Infinity;
    }

    const allVecs = [pFrac, ...bFrac];
    const { L, intVecs } = fracToIntVectors(allVecs);
    const pInt = intVecs[0];
    const bInt = intVecs.slice(1);
    const freeVars = bInt.length;
    const dim = pInt.length;

    const maxTarget = Math.max(...b, 0);
    const RANGE = Math.max(10, maxTarget + 5); // heuristic range for free vars

    let best = Infinity;
    const tVals = Array(freeVars).fill(0);

    const dfs = (idx) => {
        if (idx === freeVars) {
            const xInt = Array(dim).fill(0);
            for (let i = 0; i < dim; i++) xInt[i] = pInt[i];
            for (let k = 0; k < freeVars; k++) {
                const tk = tVals[k];
                if (tk === 0) continue;
                for (let i = 0; i < dim; i++) xInt[i] += bInt[k][i] * tk;
            }
            const x = xInt.map((v) => v / L);
            for (let i = 0; i < dim; i++) {
                if (!Number.isInteger(x[i]) || x[i] < 0) return;
            }
            const clicks = x.reduce((a, c) => a + c, 0);
            if (clicks < best) best = clicks;
            return;
        }

        for (let v = -RANGE; v <= RANGE; v++) {
            tVals[idx] = v;
            dfs(idx + 1);
        }
    };

    dfs(0);
    return best;
};

let sum = 0;
machines.forEach((machine) => {
    const clicks = solveMachine(machine);
    console.log(clicks);
    sum += clicks;
});
console.log(`Answer = ${sum}`);
