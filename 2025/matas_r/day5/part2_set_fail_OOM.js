const fs = require("fs");
const path = require("path");

const ROLL_MARK = "@";

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const lines = text.split(/\r?\n/);

let readingRanges = true;
let ranges = [];
let products = [];
lines.forEach(line => {
    if (line.length <= 0){
        readingRanges = false
    } else if (readingRanges){
        const [from, to] = line.split("-");
        ranges.push({from: Number(from), to: Number(to)});
    } else {
        products.push(Number(line))
    }
})

let freshItems = new Set();

ranges.forEach(({from, to})=> {
    for (let i = from; i <= to; i++) {
        freshItems.add(i);
    }
})

console.log(freshItems.size);
