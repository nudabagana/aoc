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

const calcProducts = (range) => range.to - range.from + 1;
const calcIntersection = (range1, range2) => {
    const [first, second] = range1.from < range2.from ? [range1, range2] : [range2, range1];
    // no intersection
    if (first.to < second.from){
        return 0;
    // second inside first
    } else if (second.to <= first.to){
        return calcProducts(second);
    // regular intersection
    } else {
        return first.to - second.from + 1;
    }
}
const calcIntersections = (range, ranges) => 
    ranges.reduce((sum, value)=> sum + calcIntersection(range, value), 0);


let sum = 0;

for (let i = 0; i < ranges.length; i++) {
    let range = ranges[i];
    sum += calcProducts(range);
    sum -= calcIntersections(range, ranges.slice(i+1));
    console.log(calcIntersections(range, ranges.slice(i+1)))
}

console.log(`Answer: ${sum}`);
