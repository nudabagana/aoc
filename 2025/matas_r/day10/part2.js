// Honestly, no way I would'ev solved this on my own.
// I got the basic idea how to do it, but I consulted AI for writing almost all of these math functions :(

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

// math functions

const buildMatrix = ({ buttons, joltage }) => {
    let matrix = [];
    for (let i = 0; i < joltage.length; i++) {
        let row = [];
        for (let j = 0; j < buttons.length; j++) {
            if (buttons[j].includes(i)){
                row.push(1);
            } else {
                row.push(0);
            }
        }
        matrix.push(row);
    }
    return matrix;
}

const greatestCommonDivisor = (a, b) => {
    let aPos = Math.abs(a);
    let bPos = Math.abs(b);
    while (bPos) {
        [aPos, bPos] = [bPos, aPos % bPos];
    }
    return aPos;
  };

   const simplify = (num, den) => {
    if (den < 0) { 
        num = -num;
        den = -den;
     }
    const g = greatestCommonDivisor(num, den);

    return [num / g, den / g];
  };

  const addFrac = ([a,b], [c,d]) => simplify(a*d + c*b, b*d);
  const subFrac = ([a,b], [c,d]) => addFrac([a,b], [-c,d]);
  const mulFrac = ([a,b], [c,d]) => simplify(a*c, b*d);
  const divFrac = ([a,b], [c,d]) => simplify(a*d, b*c);

const convertToIntegerVectors = (vecs) => {
    let L = 1;
    vecs.forEach(vec =>
      vec.forEach(([_, den]) => {
        L = (L / greatestCommonDivisor(L, den)) * den;
      })
    );
    const toInt = (vec) => vec.map(([num, den]) => num * (L / den));
    return { L, intVecs: vecs.map(toInt) };
  };

  // Turn [A|b] into reduced row echelon form using fraction math.
  const gaussianEliminationToRref = (rawMatrix, joltages) => {
    const counters = rawMatrix.length;      // rows (counters)
    const buttons = rawMatrix[0].length;   // cols (buttons)

    // Build augmented matrix with fractions [num, den]
    const matrix = Array.from({ length: counters }, (_, i) =>
      Array.from({ length: buttons + 1 }, (_, j) =>
        j === buttons ? [joltages[i], 1] : [rawMatrix[i][j], 1]
      )
    );

    let row = 0;
    for (let col = 0; col < buttons && row < counters; col++) {
      // Find pivot row with nonzero in this column
      let pivot = -1;
      for (let r = row; r < counters; r++) {
        if (matrix[r][col][0] !== 0) { pivot = r; break; }
      }
      if (pivot === -1) continue; // no pivot in this column

      // Swap current row with pivot row
      [matrix[row], matrix[pivot]] = [matrix[pivot], matrix[row]];

      // Normalize pivot row so pivot entry becomes 1
      const pivotVal = matrix[row][col];
      for (let c = col; c <= buttons; c++) {
        matrix[row][c] = divFrac(matrix[row][c], pivotVal);
      }

      // Eliminate this column in all other rows
      for (let r = 0; r < counters; r++) {
        if (r === row) continue;
        const factor = matrix[r][col];
        if (factor[0] === 0) continue;
        for (let c = col; c <= buttons; c++) {
          const prod = mulFrac(factor, matrix[row][c]);
          matrix[r][c] = subFrac(matrix[r][c], prod);
        }
      }

      row++; // move to next row
    }

    return matrix; // augmented matrix now in RREF
  };

 // Read pivot/free vars from RREF and build solution space (particular + basis).
  const solutionSpaceFromRref = (M) => {
    const rows = M.length;
    const cols = M[0].length - 1; // last col is RHS
    const pivotCol = Array(cols).fill(-1);
    let r = 0;

    // Identify pivot columns (leading 1s)
    for (let c = 0; c < cols && r < rows; c++) {
      if (M[r][c][0] === 1 && M[r][c][1] === 1) {
        pivotCol[c] = r;
        r++;
      }
    }

    const freeCols = [];
    pivotCol.forEach((v, c) => { if (v === -1) freeCols.push(c); });

    // Particular solution (free = 0)
    const particular = Array(cols).fill([0, 1]);
    for (let c = 0; c < cols; c++) {
      const pr = pivotCol[c];
      if (pr !== -1) particular[c] = M[pr][cols];
    }

    // Basis vectors (one per free column)
    const basis = [];
    freeCols.forEach((fc) => {
      const vec = Array(cols).fill([0, 1]);
      vec[fc] = [1, 1]; // set this free var = 1
      for (let c = 0; c < cols; c++) {
        const pr = pivotCol[c];
        if (pr !== -1) {
          // x_pivot = rhs - sum(free * coeff); only fc contributes here
          vec[c] = mulFrac(M[pr][fc], [-1, 1]); // negative coefficient
        }
      }
      basis.push(vec);
    });

    return { particular, basis };
  };

// end math functions

  const findBestIntegerSolution = (pInt, bInt, L, targetMax) => {
    const free = bInt.length;
    const dim = pInt.length;

    // No free variables: check and return directly
    if (free === 0) {
      const x = pInt.map(v => v / L);
      if (x.every(v => Number.isInteger(v) && v >= 0)) {
        return x.reduce((a, c) => a + c, 0);
      }
      return Infinity;
    }

    const RANGE = Math.max(10, targetMax + 5);
    let best = Infinity;
    const tVals = Array(free).fill(0);

    const dfs = (idx) => {
      if (idx === free) {
        const xInt = pInt.slice();
        for (let k = 0; k < free; k++) {
          const t = tVals[k];
          if (t === 0) continue;
          for (let i = 0; i < dim; i++) xInt[i] += bInt[k][i] * t;
        }
        const x = xInt.map(v => v / L);
        if (x.every(v => Number.isInteger(v) && v >= 0)) {
          const clicks = x.reduce((a, c) => a + c, 0);
          if (clicks < best) best = clicks;
        }
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
    const joltage = machine.joltage;
    const matrix = buildMatrix(machine);
    const transformedMatrix = gaussianEliminationToRref(matrix,joltage);
    const solutionSpace = solutionSpaceFromRref(transformedMatrix);
    transformedMatrix.forEach(row => console.log(row.map( f => `${f[0]}/${f[1]}`).join(" ")));
    const { L, intVecs } = convertToIntegerVectors([solutionSpace.particular, ...solutionSpace.basis]);
    const pInt = intVecs[0];
    const bInt = intVecs.slice(1);
    const targetMax = Math.max(...machine.joltage);

    return findBestIntegerSolution(pInt, bInt, L, targetMax);
};

let sum = 0;
machines.forEach((machine) => {
    const clicks = solveMachine(machine);
    console.log(clicks);
    sum += clicks;
});

console.log(`Answer = ${sum}`);
