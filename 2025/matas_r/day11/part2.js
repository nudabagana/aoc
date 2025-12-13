const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");

const START = "svr";
const END = "out";
const FFT = "fft";
const DAC = "dac";

const devices = text.split(/\r?\n/).map(line => {
    const [name, rest] = line.split(":");
    const routes = rest.split(" ").filter( route => route.length > 0);

    return { name, routes};
});

const deviceMap = devices.reduce((m,device)=> { m[device.name] = device.routes;
    return m;
},{});

const start = deviceMap[START];

let toVisit = start.map( route => ({route, emptyNum: 1, fftNum: 0, dacNum: 0, correctNum: 0}));
let finished = 0;

while (toVisit.length > 0 ) {
   let newToVisit = [];
   for (let i = 0; i < toVisit.length; i++) {
     const item = toVisit[i];
     if (item.route === END) {
        finished += item.correctNum;
        continue;
      }
      const routes = deviceMap[item.route];
      routes.forEach( r => {
          let emptyNum = item.emptyNum;
          let fftNum = item.fftNum;
          let dacNum = item.dacNum;
          let correctNum = item.correctNum;
          if ( r === DAC) {
            correctNum += fftNum;
            fftNum = 0;
            dacNum += emptyNum;
            emptyNum = 0;
          } else if (r === FFT){
            correctNum += dacNum;
            dacNum = 0;
            fftNum += emptyNum;
            emptyNum = 0;
          }

          const existing = newToVisit.find( item => item.route === r);
          if (existing) {
            existing.emptyNum += emptyNum;
            existing.fftNum += fftNum;
            existing.dacNum += dacNum;
            existing.correctNum += correctNum;
          } else {
            newToVisit.push({route: r, emptyNum, fftNum, dacNum, correctNum});
          }
      });
   }
   toVisit = newToVisit;
}

console.log(finished);