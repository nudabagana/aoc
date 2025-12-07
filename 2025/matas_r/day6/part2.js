const fs = require("fs");
const path = require("path");

const MUL_ACTION = "*";
const SUM_ACTION = "+";
const ACTIONS = [MUL_ACTION, SUM_ACTION];

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const text2DMap = text.split(/\r?\n/).map(line => [...line]);

let equations = [];
let equationIdx = 0;
const lenX = text2DMap[0].length;
const lenY = text2DMap.length;

for (let x = 0; x < lenX; x++) {
    let numb = "";
    for (let y = 0; y < lenY - 1; y++) {
        numb += text2DMap[y][x];
    }
    numb = numb.replace(/\s+/g, "");

    if (numb === ""){
        equationIdx++;
    } else {
        equations[equationIdx] ??= {nums: [], action: ""};
        equations[equationIdx].nums.push(Number(numb));
    }

    const action = text2DMap[lenY - 1][x];
    if (ACTIONS.includes(action)){
        equations[equationIdx].action = action;
    }
}

console.log(equations);

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