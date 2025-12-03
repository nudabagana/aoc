const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const batterBanks = text.split(/\r?\n/);

const DIGITS = 12;

let sum = 0;
batterBanks.forEach( bank => {
    let numbers = [...bank.slice(-DIGITS)];
    for (let index = bank.length-DIGITS-1; index >= 0; index--) {
        let digit = bank[index];
        for (let i = 0; i < DIGITS; i++) {
            if (digit >= numbers[i]){
                const temp = numbers[i];
                numbers[i] = digit;
                digit = temp;
            } else {
                break;
            }
        }
    }
    const numb = Number(numbers.join(""));
    console.log(numb);
    sum += numb;
})
console.log("-----");
console.log(sum);
