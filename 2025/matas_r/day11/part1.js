const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");

const START = "you";
const END = "out";

const devices = text.split(/\r?\n/).map(line => {
    const [name, rest] = line.split(":");
    const routes = rest.split(" ").filter( route => route.length > 0);

    return { name, routes};
});

const deviceMap = devices.reduce((m,device)=> { m[device.name] = device.routes;
    return m;
},{});

const start = deviceMap[START];

const sumArr = (arr) => arr.reduce((a, b) => a + b, 0);

const calcPaths = (routes) => {
    if (routes.includes(END)){
        if (routes.length > 1){
            return 1 + calcPaths(routes.filter(r => r != END));
        }
        return 1;
    }

    return sumArr(routes.map(route => calcPaths(deviceMap[route])));
}

const pathsCount = calcPaths(start);
console.log(pathsCount);