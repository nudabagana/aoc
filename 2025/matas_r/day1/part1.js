const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const lines = text.split(/\r?\n/);
const actions = lines.map( line => {
    return {dir: line[0], moves: Number(line.slice(1))}
})

let dial = 50;
let zeroCount = 0;

actions.forEach( action => {
    if (action.dir === 'R'){
        dial += action.moves
    }else {
        dial -= action.moves
    }
    dial = (100 + dial) % 100;
    if (dial === 0){
        zeroCount++;
    }
})

console.log(zeroCount);