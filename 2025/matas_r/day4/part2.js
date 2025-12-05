const fs = require("fs");
const path = require("path");

const ROLL_MARK = "@";
const EMPTY_MARK = '.';

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const lines = text.split(/\r?\n/);
const rolls = [];
const rollsVisuals = [];

lines.forEach(line =>{
    rolls.push([...line]);
    rollsVisuals.push([...line]);
})

const canBeMoved = (rolls, i, j) => {
    let adjRolls = 0;

    if (rolls[i]?.[j+1] === ROLL_MARK){
        adjRolls++;
    }
    if (rolls[i]?.[j-1] === ROLL_MARK){
        adjRolls++;
    }

    if (rolls[i+1]?.[j] === ROLL_MARK){
        adjRolls++;
    }
     if (rolls[i-1]?.[j] === ROLL_MARK){
        adjRolls++;
    }

    if (rolls[i+1]?.[j+1] === ROLL_MARK){
        adjRolls++;
    }
    if (rolls[i+1]?.[j-1] === ROLL_MARK){
        adjRolls++;
    }

    if (rolls[i-1]?.[j+1] === ROLL_MARK){
        adjRolls++;
    }
    if (rolls[i-1]?.[j-1] === ROLL_MARK){
        adjRolls++;
    }

    return adjRolls < 4;
}

const letsRoll = (rolls) => {
    let sum = 0;
    let moved = false;
    let newRolls = structuredClone(rolls);
    for (let i = 0; i < rolls.length; i++) {
        for (let j = 0; j < rolls[i].length; j++) {
            if (rolls[i][j] === ROLL_MARK && canBeMoved(rolls,i,j)){
                newRolls[i][j] = EMPTY_MARK;
                sum++;
                moved = true;
            }
        }
    }
    return [newRolls, sum, moved];
}

let moved = true;
let dynamicRolls = rolls;
let sum = 0;
while (moved === true){
    const [newRolls,movSum, isMoved] = letsRoll(dynamicRolls); 
    moved = isMoved;
    sum += movSum;
    dynamicRolls = newRolls;

}
dynamicRolls.forEach(r => {
console.log(r.join(""))
})

console.log(sum);
