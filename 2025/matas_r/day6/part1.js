const fs = require("fs");
const path = require("path");

const MUL_ACTION = "*";
const SUM_ACTION = "+";

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const lines = text.split(/\r?\n/);

let equations = [];
lines.forEach(line=> {
    const items = line.trim().split(/\s+/)
    if (isNaN(Number(items[0]))){ 
        items.forEach( (item, idx)=> {
            equations[idx].action = item;
        });
    } else {
        items.forEach( (item, idx)=> {
            equations[idx] ??= {nums: [], action: ""};
            equations[idx].nums.push(Number(item));
        });
    }
})

let sum = 0;
equations.forEach( ({nums, action}) => {
    let result;
    if (action === MUL_ACTION){
        result = nums.reduce((prev,curr)=> prev*curr, 1);
    } else {
        result = nums.reduce((prev,curr)=> prev+curr, 0);
    }
    sum += result;
});

console.log(sum);