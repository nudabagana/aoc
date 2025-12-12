const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8").trim();

class Fraction {
  constructor(num, den = 1) {
    if (den === 0) throw new Error("Division by zero");
    if (den < 0) {
      num = -num;
      den = -den;
    }
    const g = Fraction.#gcd(Math.abs(num), den);
    this.num = num / g;
    this.den = den / g;
  }

  static #gcd(a, b) {
    while (b) {
      const t = a % b;
      a = b;
      b = t;
    }
    return a || 1;
  }

  add(other) {
    return new Fraction(
      this.num * other.den + other.num * this.den,
      this.den * other.den
    );
  }

  subtract(other) {
    return new Fraction(
      this.num * other.den - other.num * this.den,
      this.den * other.den
    );
  }

  multiply(other) {
    return new Fraction(this.num * other.num, this.den * other.den);
  }

  divide(other) {
    if (other.num === 0) throw new Error("Division by zero");
    return new Fraction(this.num * other.den, this.den * other.num);
  }

  isZero() {
    return this.num === 0;
  }

  isInteger() {
    return this.den === 1;
  }

  isNegative() {
    return this.num < 0;
  }

  isPositive() {
    return this.num > 0;
  }

  toNumber() {
    return this.num / this.den;
  }

  clone() {
    return new Fraction(this.num, this.den);
  }
}

const parseMachines = (raw) =>
  raw.split(/\r?\n/).map((line) => {
    const [lightRaw, rest] = line.split("]");
    const [, targetsRaw] = rest.split("{");

    const buttons = [...line.matchAll(/\(([^)]*)\)/g)].map((m) =>
      m[1].split(",").map(Number)
    );
    const targets = targetsRaw
      .slice(0, -1)
      .split(",")
      .map((n) => Number(n.trim()));

    const lights = [...lightRaw.slice(1)].map((ch) => ch === "#"); // kept for completeness

    return { buttons, targets, lights };
  });

const rref = (matrix, rhs) => {
  const rows = matrix.length;
  const cols = matrix[0].length;
  let pivotRow = 0;
  const pivots = [];

  for (let col = 0; col < cols && pivotRow < rows; col++) {
    let pivot = -1;
    for (let r = pivotRow; r < rows; r++) {
      if (!matrix[r][col].isZero()) {
        pivot = r;
        break;
      }
    }
    if (pivot === -1) continue;

    // swap rows
    [matrix[pivotRow], matrix[pivot]] = [matrix[pivot], matrix[pivotRow]];
    [rhs[pivotRow], rhs[pivot]] = [rhs[pivot], rhs[pivotRow]];

    const pivotVal = matrix[pivotRow][col];
    // normalize pivot row
    for (let c = 0; c < cols; c++) {
      matrix[pivotRow][c] = matrix[pivotRow][c].divide(pivotVal);
    }
    rhs[pivotRow] = rhs[pivotRow].divide(pivotVal);

    // eliminate other rows
    for (let r = 0; r < rows; r++) {
      if (r === pivotRow) continue;
      if (matrix[r][col].isZero()) continue;
      const factor = matrix[r][col];
      for (let c = 0; c < cols; c++) {
        matrix[r][c] = matrix[r][c].subtract(
          factor.multiply(matrix[pivotRow][c])
        );
      }
      rhs[r] = rhs[r].subtract(factor.multiply(rhs[pivotRow]));
    }

    pivots.push(col);
    pivotRow++;
  }

  return { matrix, rhs, pivots };
};

const buildMatrix = (machine) => {
  const rows = machine.targets.length;
  const cols = machine.buttons.length;
  const matrix = Array.from({ length: rows }, () =>
    Array.from({ length: cols }, () => new Fraction(0))
  );

  machine.buttons.forEach((btn, col) => {
    btn.forEach((idx) => {
      matrix[idx][col] = new Fraction(1);
    });
  });

  const rhs = machine.targets.map((t) => new Fraction(t));

  return { matrix, rhs };
};

const minPresses = (machine) => {
  const { matrix, rhs } = buildMatrix(machine);
  const cols = machine.buttons.length;
  const {
    matrix: reducedMatrix,
    rhs: reducedRhs,
    pivots,
  } = rref(matrix, rhs);

  // detect inconsistency
  for (let r = 0; r < reducedMatrix.length; r++) {
    const allZero = reducedMatrix[r].every((cell) => cell.isZero());
    if (allZero && !reducedRhs[r].isZero()) {
      throw new Error("No solution for machine");
    }
  }

  const freeColumns = [];
  for (let c = 0; c < cols; c++) {
    if (!pivots.includes(c)) freeColumns.push(c);
  }

  const buttonMaxPress = machine.buttons.map((btn) =>
    Math.min(...btn.map((idx) => machine.targets[idx]))
  );

  if (freeColumns.length === 0) {
    let total = 0;
    pivots.forEach((col, row) => {
      const val = reducedRhs[row];
      if (!val.isInteger() || val.isNegative()) {
        throw new Error("Unexpected non-integer solution");
      }
      if (val.toNumber() > buttonMaxPress[col]) {
        throw new Error("Solution exceeds target bounds");
      }
      total += val.toNumber();
    });
    return total;
  }

  const pivotRows = pivots.map((col, rowIdx) => ({
    col,
    constant: reducedRhs[rowIdx],
    coeffs: freeColumns.map((fCol) => reducedMatrix[rowIdx][fCol]),
  }));

  // upper bounds for free vars: cannot exceed min target of covered counters
  const upperBounds = freeColumns.map((col) => buttonMaxPress[col]);

  // refine bounds using positivity constraints from pivot expressions
  pivotRows.forEach((row) => {
    const worstNegativeAid = row.coeffs.map((coeff, idx) => {
      if (coeff.isNegative()) {
        return coeff
          .multiply(new Fraction(-buttonMaxPress[freeColumns[idx]]))
          .toNumber();
      }
      return 0;
    });

    row.coeffs.forEach((coeff, idx) => {
      if (coeff.isPositive()) {
        const aid = worstNegativeAid.reduce(
          (sum, value, j) => (j === idx ? sum : sum + value),
          0
        );
        const bound = row.constant
          .add(new Fraction(aid))
          .divide(coeff)
          .toNumber();
        const asInt = Math.floor(bound);
        if (asInt < upperBounds[idx]) upperBounds[idx] = asInt;
      }
    });
  });

  // ensure bounds are not negative
  for (let i = 0; i < upperBounds.length; i++) {
    if (upperBounds[i] < 0) upperBounds[i] = 0;
  }

  let best = Infinity;
  const freeValues = new Array(freeColumns.length).fill(0);

  const dfs = (pos, sumFree) => {
    if (pos === freeColumns.length) {
      let pivotSum = 0;
      for (const row of pivotRows) {
        let val = row.constant;
        row.coeffs.forEach((coeff, idx) => {
          if (!coeff.isZero()) {
            val = val.subtract(coeff.multiply(new Fraction(freeValues[idx])));
          }
        });
        if (val.isNegative()) return;
        if (!val.isInteger()) return;
        const pivotValue = val.toNumber();
        if (pivotValue > buttonMaxPress[row.col]) return;
        pivotSum += pivotValue;
      }
      const total = sumFree + pivotSum;
      if (total < best) best = total;
      return;
    }

    const maxVal = upperBounds[pos];
    for (let candidate = 0; candidate <= maxVal; candidate++) {
      freeValues[pos] = candidate;
      // simple lower bound: even if remaining free vars are zero, total so far cannot exceed current best
      if (sumFree + candidate >= best) {
        continue;
      }
      dfs(pos + 1, sumFree + candidate);
    }
  };

  dfs(0, 0);
  return best;
};

const machines = parseMachines(text);

let total = 0;
machines.forEach((machine, idx) => {
  const presses = minPresses(machine);
  console.log(`Machine ${idx + 1}: ${presses}`);
  total += presses;
});

console.log(`Answer = ${total}`);
