const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");

const machines = text.split(/\r?\n/).map((line, id) => {
    const [_, rest] = line.split("]");
    
    const [ buttonsRaw, joltageRaw ] = rest.split("{");
    const buttons = buttonsRaw.trim()
                              .split(")")
                              .filter( l => l.length)
                              .map( btn => btn.trim()
                                              .slice(1)
                                              .split(",")
                                              .map(Number));

    const joltage = joltageRaw.slice(0,joltageRaw.length-1).split(",").map(Number);

    return { buttons, joltage };
});

function arraysEqual(a, b) {
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) return false;
  }
  return true;
}

function arraySmallerOrEq(a, b) {
  for (let i = 0; i < a.length; i++) {
    if (a[i] > b[i]) return false;
  }
  return true;
}


const calcMachineJoltage = (machine) => {
    const target = machine.joltage;
    const buttonTouchCount = Array(target.length).fill(0);
    machine.buttons.forEach(btn => btn.forEach(i => { buttonTouchCount[i] += 1; }));

    const buttons = [...machine.buttons].sort((a, b) => {
        const uniqueA = a.reduce((acc, idx) => acc + (buttonTouchCount[idx] === 1 ? 1 : 0), 0);
        const uniqueB = b.reduce((acc, idx) => acc + (buttonTouchCount[idx] === 1 ? 1 : 0), 0);
        if (uniqueA !== uniqueB) return uniqueB - uniqueA;
        return b.length - a.length;
    });

    const buttonLengths = buttons.map(b => b.length);
    const suffixMaxLen = Array(buttons.length + 1).fill(1);
    for (let i = buttons.length - 1; i >= 0; i--) {
        suffixMaxLen[i] = Math.max(suffixMaxLen[i + 1], buttonLengths[i]);
    }

    const greedyUpperBound = () => {
        const pickers = [
            (btn, presses, remaining) => btn.length / presses,
            (btn, presses, remaining) => {
                let after = 0;
                btn.forEach(i => { after += remaining[i] - presses; });
                return after;
            },
        ];

        let bestBound = Infinity;

        for (const picker of pickers) {
            const remaining = [...target];
            let clicks = 0;

            while (true) {
                const maxRem = Math.max(...remaining);
                if (maxRem === 0) break;
                const idx = remaining.indexOf(maxRem);

                let choice = null;
                for (const btn of buttons) {
                    if (!btn.includes(idx)) continue;
                    const presses = btn.reduce((acc, i) => Math.min(acc, remaining[i]), Infinity);
                    if (presses === 0 || presses === Infinity) continue;

                    const score = picker(btn, presses, remaining);
                    if (!choice || score < choice.score) {
                        choice = { btn, presses, score };
                    }
                }

                if (!choice) {
                    clicks = Infinity;
                    break;
                }

                choice.btn.forEach(i => {
                    remaining[i] -= choice.presses;
                });
                clicks += choice.presses;
            }

            if (clicks < bestBound) bestBound = clicks;
        }

        return bestBound;
    };

    const coverageInit = Array(target.length).fill(0);
    buttons.forEach(btn => btn.forEach(i => { coverageInit[i] += 1; }));

    let best = greedyUpperBound();
    if (!Number.isFinite(best)) best = Infinity;
    const memo = new Map();
    const MEMO_LIMIT = 1_000_000;

    const lowerBound = (remaining, remainingButtonsMaxSize) => {
        const maxRem = Math.max(...remaining);
        const totalRem = remaining.reduce((a, b) => a + b, 0);
        return Math.max(maxRem, Math.ceil(totalRem / remainingButtonsMaxSize));
    };

    const dfs = (idx, remaining, coverage, clicks, remainingButtonsMaxSize) => {
        if (clicks >= best) return;

        const key = `${idx}|${remaining.join(",")}`;
        const cached = memo.get(key);
        if (cached !== undefined && cached <= clicks) return;
        if (memo.size < MEMO_LIMIT) {
            memo.set(key, clicks);
        }

        const lb = clicks + lowerBound(remaining, remainingButtonsMaxSize);
        if (lb >= best) return;

        if (idx === buttons.length) {
            if (Math.max(...remaining) === 0 && clicks < best) {
                best = clicks;
            }
            return;
        }

        for (let i = 0; i < remaining.length; i++) {
            if (remaining[i] > 0 && coverage[i] === 0) return;
        }

        const btn = buttons[idx];

        let maxPresses = Infinity;
        btn.forEach(i => {
            if (remaining[i] < maxPresses) maxPresses = remaining[i];
        });
        if (maxPresses === Infinity) maxPresses = 0;

        let minPresses = 0;
        btn.forEach(i => {
            if (coverage[i] === 1 && remaining[i] > minPresses) {
                minPresses = remaining[i];
            }
        });

        if (minPresses > maxPresses) {
            return;
        }

        const nextCoverage = [...coverage];
        btn.forEach(i => nextCoverage[i] -= 1);

        for (let count = minPresses; count <= maxPresses; count++) {
            const next = [...remaining];
            let valid = true;
            for (const i of btn) {
                next[i] -= count;
                if (next[i] < 0) {
                    valid = false;
                    break;
                }
            }
            if (!valid) break;
            dfs(idx + 1, next, nextCoverage, clicks + count, suffixMaxLen[idx + 1]);
        }
    };

    dfs(0, [...target], coverageInit, 0, suffixMaxLen[0]);
    return best;
};

let sum = 0;
machines.forEach( machine => {
    const machineCicks = calcMachineJoltage(machine);
    console.log(machineCicks);

    sum += machineCicks;
});

console.log(`Answer = ${sum}`);
