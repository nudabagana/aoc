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


function splitIntoParts(n, parts) {
  const result = [];

  function helper(remaining, count, current) {
    if (count === 1) {
      result.push([...current, remaining]);
      return;
    }

    for (let i = 0; i <= remaining; i++) {
      helper(remaining - i, count - 1, [...current, i]);
    }
  }

  helper(n, parts, []);
  return result;
}

const addButtonToJoltage = (joltage, button, n) => {
    button.forEach( i => {
        joltage[i] += 1 * n;
    });
}

const findNthItemSolves = (fromJoltage, toJoltage, buttons, n, currClicks) => {
    const usableButtons = [];
    const leftButtons = [];
    buttons.forEach( btn => {
        if (btn.includes(n)){
            usableButtons.push(btn);
        } else {
            leftButtons.push(btn);
        }
    });

    const clicks = toJoltage[n] - fromJoltage[n];
    if (clicks <= 0){
        return [{comb: fromJoltage, clicks: currClicks, buttons: leftButtons}]
    }
    if (clicks > 0 && usableButtons.length === 0) {
        // This partial state is impossible
        return [];
        }

    const combinations = splitIntoParts(clicks, usableButtons.length);
    let combs = [];
    combinations.forEach(comb => {
        
        let newJoltage = [...fromJoltage];
        for (let i = 0; i < comb.length; i++) {
            addButtonToJoltage(newJoltage, usableButtons[i], comb[i]);
        }

        if (arraySmallerOrEq(newJoltage, toJoltage)){
            combs.push({comb: newJoltage, clicks: currClicks + clicks, buttons: leftButtons})
        }
    });

    return combs;
}

const calcMachineJoltage = (machine) => {
    let combinations = [{comb: Array(machine.joltage.length).fill(0), clicks: 0, buttons: machine.buttons}];

    const machineJoltageIdx = machine.joltage.map((j, idx) => ({j, idx})).sort((a,b)=> a.j - b.j).map(({idx}) => idx);

    for (let i = 0; i < machineJoltageIdx.length; i++) {
        const n = machineJoltageIdx[i];
        const viableCombs = combinations.filter(({comb}) => arraysEqual(comb, machine.joltage));
        if (viableCombs.length > 0){
            return Math.min(...viableCombs.map(({clicks})=> clicks));
        }

        combinations = combinations.flatMap( ({comb, clicks, buttons}) => findNthItemSolves(comb,machine.joltage,buttons,n, clicks));
    }

    return Math.min(...combinations.map(({clicks})=> clicks));
}

let sum = 0;
machines.forEach( machine => {
    const machineCicks = calcMachineJoltage(machine);
    console.log(machineCicks);

    sum += machineCicks;
});

console.log(`Answer = ${sum}`);
