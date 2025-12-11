const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const corners = text.split(/\r?\n/).map((line, id) => {
    const [x,y] = line.split(",");
    return {id, x, y, };
});

const calcArea = (point1, point2) => {
    const x = Math.abs(point1.x - point2.x) + 1;
    const y = Math.abs(point1.y - point2.y) + 1;

    return x * y;
}

let possibleRects = [];
for (let i = 0; i < corners.length; i++) {
    const corner1 = corners[i];
    for (let j = i+1; j < corners.length; j++) {
        const corner2 = corners[j];
        const area = calcArea(corner1, corner2);
        possibleRects.push({from:i, to:j, area});
    }
}

const sortedRects = possibleRects.toSorted((a,b) => a.area - b.area);

console.log(sortedRects[sortedRects.length -1]);