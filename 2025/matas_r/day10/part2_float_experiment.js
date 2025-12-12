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

const buildMatrix = ({ buttons, joltage }) => {
    const m = joltage.length;
    const n = buttons.length;
    const A = Array.from({ length: m }, () => Array(n).fill(0));
    buttons.forEach((btn, j) => btn.forEach((i) => { A[i][j] = 1; }));
    return A;
};

const rrefFloat = (A, b, eps = 1e-9) => {
    const m = A.length;
    const n = A[0].length;
    const M = Array.from({ length: m }, (_, i) => [...A[i], b[i]]);

    let row = 0;
    for (let col = 0; col < n && row < m; col++) {
        // Find pivot
        let pivot = -1;
        for (let r = row; r < m; r++) {
            if (Math.abs(M[r][col]) > eps) { pivot = r; break; }
        }
        if (pivot === -1) continue;

        // Swap
        [M[row], M[pivot]] = [M[pivot], M[row]];

        // Normalize pivot row
        const pivotVal = M[row][col];
        for (let c = col; c <= n; c++) M[row][c] /= pivotVal;

        // Eliminate others
        for (let r = 0; r < m; r++) {
            if (r === row) continue;
            const factor = M[r][col];
            if (Math.abs(factor) < eps) continue;
            for (let c = col; c <= n; c++) M[r][c] -= factor * M[row][c];
        }

        row++;
    }

    // Clean tiny values to exact zero
    for (let r = 0; r < m; r++) {
        for (let c = 0; c <= n; c++) {
            if (Math.abs(M[r][c]) < eps) M[r][c] = 0;
        }
    }

    return M;
};

const solutionSpaceFloat = (M, eps = 1e-9) => {
    const m = M.length;
    const n = M[0].length - 1;
    const pivotCol = Array(n).fill(-1);
    let r = 0;

    for (let c = 0; c < n && r < m; c++) {
        if (Math.abs(M[r][c]) > eps) {
            pivotCol[c] = r;
            r++;
        }
    }

    const freeCols = [];
    pivotCol.forEach((v, c) => { if (v === -1) freeCols.push(c); });

    const particular = Array(n).fill(0);
    for (let c = 0; c < n; c++) {
        const pr = pivotCol[c];
        if (pr !== -1) particular[c] = M[pr][n];
    }

    const basis = [];
    freeCols.forEach((fc) => {
        const vec = Array(n).fill(0);
        vec[fc] = 1;
        for (let c = 0; c < n; c++) {
            const pr = pivotCol[c];
            if (pr !== -1) vec[c] = -M[pr][fc];
        }
        basis.push(vec);
    });

    return { particular, basis };
};

const findBestIntegerSolutionFloat = (A, b, p, basis, eps = 1e-9) => {
    const free = basis.length;
    const dim = p.length;

    // No free variables
    if (free === 0) {
        const x = p;
        const xInt = x.map((v) => Math.round(v));
        if (x.every((v, i) => Math.abs(v - xInt[i]) < eps && xInt[i] >= 0)) {
            // verify
            for (let i = 0; i < b.length; i++) {
                let sum = 0;
                for (let j = 0; j < dim; j++) sum += A[i][j] * xInt[j];
                if (sum !== b[i]) return Infinity;
            }
            return xInt.reduce((a, c) => a + c, 0);
        }
        return Infinity;
    }

    const targetMax = Math.max(...b);
    const RANGE = Math.max(10, targetMax + 5);
    let best = Infinity;
    const tVals = Array(free).fill(0);

    const dfs = (idx) => {
        if (idx === free) {
            const x = p.slice();
            for (let k = 0; k < free; k++) {
                const t = tVals[k];
                if (t === 0) continue;
                for (let i = 0; i < dim; i++) x[i] += basis[k][i] * t;
            }
            const xInt = x.map((v) => Math.round(v));
            if (!x.every((v, i) => Math.abs(v - xInt[i]) < eps && xInt[i] >= 0)) return;
            // verify A·xInt == b
            for (let i = 0; i < b.length; i++) {
                let sum = 0;
                for (let j = 0; j < dim; j++) sum += A[i][j] * xInt[j];
                if (sum !== b[i]) return;
            }
            const clicks = xInt.reduce((a, c) => a + c, 0);
            if (clicks < best) best = clicks;
            return;
        }
        for (let t = -RANGE; t <= RANGE; t++) {
            tVals[idx] = t;
            dfs(idx + 1);
        }
    };

    dfs(0);
    return best;
};

const solveMachine = (machine) => {
    const A = buildMatrix(machine);
    const M = rrefFloat(A, machine.joltage);
    const sol = solutionSpaceFloat(M);
    return findBestIntegerSolutionFloat(A, machine.joltage, sol.particular, sol.basis);
};

let sum = 0;
machines.forEach((machine) => {
    const clicks = solveMachine(machine);
    console.log(clicks);
    sum += clicks;
});

console.log(`Answer = ${sum}`);

