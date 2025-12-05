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

ranges = ranges.toSorted((a,b)=> a.from - b.from);
const calcProducts = (range) => range.to - range.from + 1;


let i = 0;
while (ranges[i+1] != undefined) {
    if (ranges[i].to < ranges[i+1].from){
        i++;
    } else {
        ranges[i].to = Math.max(ranges[i+1].to, ranges[i].to);
        ranges.splice(i+1,1);
    }
}

let sum = 0;

ranges.forEach(range => {
    console.log(range);
    sum += calcProducts(range);
});

console.log(`Answer: ${sum}`);
