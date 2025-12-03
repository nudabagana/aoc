const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const rangesText = text.split(/,/);
const ranges = rangesText.map( range => {
    const [start, end] = range.split("-");
    return {start: Number(start), end: Number(end)}
})

const findNumbers = (from, to) => {
    let numbers = [];
    for (let index = from; index <= to; index++){
        if (isRepeatedNumber(`${index}`)){
            numbers.push(index);
        }
    }
    return numbers;
}

const isRepeatedNumber = (numb)=> {
    const len = numb.length;
    if (len % 2 !== 0){
        return false;
    }
    const halfLen = len / 2;
    return numb.slice(0, halfLen) === numb.slice(halfLen, len);
}

let sum = 0;
ranges.forEach( range => {
    // console.log(`from: ${range.start} to ${range.end}. Numbers: ${findNumbers(range.start, range.end)}`)
    sum += findNumbers(range.start, range.end).reduce((sum, curr) => sum+ curr, 0)
})
console.log(sum);
