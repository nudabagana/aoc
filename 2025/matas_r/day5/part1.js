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

const isFresh = (product, ranges)=> {
    let fresh = false;
    ranges.forEach(({from, to})=> {
        if (product >= from && product <= to){
            fresh = true;
        }
    });
    return fresh;
}

let sum = 0;

products.forEach(product => {
    if (isFresh(product,ranges)){
        sum++;
    }
})

console.log(sum);
