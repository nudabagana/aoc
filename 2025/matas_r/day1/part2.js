const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const lines = text.split(/\r?\n/);
const actions = lines.map( line => {
    const num = Number(line.slice(1));
    return {dir: line[0], moves: num % 100, rotations: Math.floor(num /100)}
})

let dial = 50;
let zeroCount = 0;

actions.forEach( action => {
    const wasZero = dial === 0;
    if (action.dir === 'R'){
        dial += action.moves
    }else {
        dial -= action.moves
    }
    if (!wasZero && (dial > 100 || dial < 0)){
        zeroCount++;
    }
    dial = (100 + dial) % 100;
    if (dial === 0){
        zeroCount++;
    }
    zeroCount += action.rotations;
    console.log(`dial: ${dial}, zereCount: ${zeroCount}`);
})

console.log(zeroCount);