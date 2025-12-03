const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const rangesText = text.split(/,/);
const ranges = rangesText.map( range => {
    const [start, end] = range.split("-");
    return {start: Number(start), end: Number(end)}
})

const findNumbersInRange = (from, to) => {
    let numbers = [];
    for (let index = from; index <= to; index++){
        if (isRepeatedNumber(`${index}`)){
            numbers.push(index);
        }
    }
    return numbers;
}

const isRepeatedNumber = (numb) => {
    for (let index = 2; index <= numb.length; index++) {
        if (isPartsSame(numb,index)){
            return true
        }
    }
    
    return false;
}

const isPartsSame = (number, parts) => {
    const len = number.length;
    const partLen = len/parts;
    const toEqual = number.slice(0,partLen);
    for (let index = 0; index < parts; index++) {
        if (toEqual !== number.slice(partLen*index, partLen*(index+1))) {
            return false;
        }
    }
    return true;
}

let sum = 0;
ranges.forEach( range => {
    // console.log(`from: ${range.start} to ${range.end}. Numbers: ${findNumbersInRange(range.start, range.end)}`)
    sum += findNumbersInRange(range.start, range.end).reduce((sum, curr) => sum+ curr, 0)
})
console.log(sum);
