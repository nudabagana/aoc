const fs = require("fs");
const path = require("path");

const ROLL_MARK = "@";

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const lines = text.split(/\r?\n/);
const rolls = [];
const rollsVisuals = [];

lines.forEach(line =>{
    rolls.push([...line]);
    rollsVisuals.push([...line]);
})



let sum = 0;

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

for (let i = 0; i < rolls.length; i++) {
    for (let j = 0; j < rolls[i].length; j++) {
        if (rolls[i][j] === ROLL_MARK && canBeMoved(rolls,i,j)){
            rollsVisuals[i][j]='x';
            sum++;
        }
    }
    console.log(rollsVisuals[i].join(""))
}

console.log(sum);
