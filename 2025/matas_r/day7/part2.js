const fs = require("fs");
const path = require("path");

const START_SYMBOL = "S";
const LASER_SYMBOL = "|";
const SPLIT_SYMBOL = "^";

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const TwoDMap = text.split(/\r?\n/).map(line => [...line].map(char => char === "." ? 0 : char));

const lenY = TwoDMap.length;
const lenX = TwoDMap[0].length;

for (let x = 0; x < lenX; x++) {
    const char = TwoDMap[0][x];
    if (char == START_SYMBOL) {
        TwoDMap[1][x] = 1;
    }
}


for (let y = 1; y < lenY; y++) {
    for (let x = 0; x < lenX; x++) {
        const symbol = Number(TwoDMap[y][x]);
        if (!isNaN(symbol) && symbol > 0) {
            if (TwoDMap[y+1]?.[x] === undefined) {
            } else if (TwoDMap[y+1][x] === SPLIT_SYMBOL) {
                if (TwoDMap[y+1][x-1] !== undefined){
                    TwoDMap[y+1][x-1] += symbol;
                }
                if (TwoDMap[y+1][x+1] !== undefined){
                    TwoDMap[y+1][x+1] += symbol;
                }
            } else {
                TwoDMap[y+1][x] += symbol;
            }
        }
        
    }
}

TwoDMap.forEach(line => {
    console.log(line.join(""));
})

const sum = TwoDMap[TwoDMap.length-1].reduce((sum, item) => sum + item, 0);

console.log(sum);
