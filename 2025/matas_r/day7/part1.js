const fs = require("fs");
const path = require("path");

const START_SYMBOL = "S";
const LASER_SYMBOL = "|";
const SPLIT_SYMBOL = "^";

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const TwoDMap = text.split(/\r?\n/).map(line => [...line]);

const lenY = TwoDMap.length;
const lenX = TwoDMap[0].length;

for (let x = 0; x < lenX; x++) {
    const char = TwoDMap[0][x];
    if (char == START_SYMBOL) {
        TwoDMap[1][x] = LASER_SYMBOL;
    }
}

let splitSum = 0;
for (let y = 0; y < lenY; y++) {
    for (let x = 0; x < lenX; x++) {
        const symbol = TwoDMap[y][x];
        if (symbol === LASER_SYMBOL){
            if (TwoDMap[y+1]?.[x] === undefined) 
                {} else if (TwoDMap[y+1][x] === SPLIT_SYMBOL) {
                    splitSum++;
                if (TwoDMap[y+1][x-1] !== undefined){
                    TwoDMap[y+1][x-1] = LASER_SYMBOL;
                }
                if (TwoDMap[y+1][x+1] !== undefined){
                    TwoDMap[y+1][x+1] = LASER_SYMBOL;
                }
            } else {
                TwoDMap[y+1][x] = LASER_SYMBOL;
            }
        }
        
    }
}

TwoDMap.forEach(line => {
    console.log(line.join(""));
})

console.log(splitSum);