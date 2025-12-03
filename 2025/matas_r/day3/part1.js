const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const batterBanks = text.split(/\r?\n/);

let sum = 0;
batterBanks.forEach( bank => {
    let first = bank[bank.length-2];
    let second = bank[bank.length-1];
    for (let index = bank.length-3; index >= 0; index--) {
        if (bank[index] >= first){
            if (first > second){
                second = first;
            }
            first = bank[index];
        }
        if (second >= 9 && first >= 9){
            break;
        }
    }
    const numb = Number(`${first}${second}`)
    console.log(numb);
    sum += numb;
})
console.log(sum);
