const fs = require("fs");
const path = require("path");

const START_SYMBOL = "S";
const LASER_SYMBOL = "|";
const SPLIT_SYMBOL = "^";
const EMPTY_SYMBOL = ".";

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const TwoDMap = text.split(/\r?\n/).map(line => [...line]);

const startX = TwoDMap[0].indexOf(START_SYMBOL);

const calcEnds = (x,y) => {
    if (TwoDMap[y]?.[x] === undefined){
        return 1;
    } if (TwoDMap[y][x] === EMPTY_SYMBOL){
        return calcEnds(x,y+1);
    }else {
        return calcEnds(x+1,y+1) + calcEnds(x-1, y+1);
    }
}

const sum = calcEnds(startX,1);

console.log(sum);
// Memoisation on calcEnds using map of loadash would make this work.