const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");

const machines = text.split(/\r?\n/).map((line, id) => {
    const [lightRaw, rest] = line.split("]");
    const lights = [...lightRaw.slice(1)].map( char => char === "#");
    
    const [ buttonsRaw, ] = rest.split("{");
    const buttons = buttonsRaw.trim()
                              .split(")")
                              .filter( l => l.length)
                              .map( btn => btn.trim()
                                              .slice(1)
                                              .split(",")
                                              .map(Number));

    return { lights, buttons};
});

const maxClicks = 9;
const INVALID = 9999;

function arraysEqual(a, b) {
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) return false;
  }
  return true;
}

const buttonClick = (lights, button) => {
    const newLights = [...lights];
    button.forEach(idx => {
        newLights[idx] = !lights[idx];
    });

    return newLights;
}

const calcButtonClicks = (lightsCurr, lightsExpected, clickCount, buttons, lastButton ) => {
    // console.log(`${lightsCurr} | ${lightsExpected} | ${clickCount} | ${buttons} | ${lastButton}`);
    if (arraysEqual(lightsCurr, lightsExpected)){
        return clickCount;
    }

    if (clickCount >= maxClicks){
        return INVALID;
    }

    const clicks = buttons.map((btn, idx) => {
        if (idx === lastButton){
            return INVALID
        }

        return calcButtonClicks(buttonClick(lightsCurr, btn), lightsExpected,  clickCount+1,buttons, idx);
    });

    return Math.min(...clicks);
}

const calcMachine = (machine) => {
    const res = machine.buttons.map( (btn, idx) => {
        return calcButtonClicks(buttonClick(Array(machine.lights.length).fill(false), btn), machine.lights, 1, machine.buttons, idx);
    });

    return Math.min(...res);
}

let sum = 0;
machines.forEach( machine => {
    const machineCicks = calcMachine(machine);
    console.log(machineCicks);

    sum += machineCicks;
});

console.log(`Answer = ${sum}`);
