const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const boxes = text.split(/\r?\n/).map((line, id) => {
    const [x,y,z] = line.split(",");
    return {id, x, y, z, };
});

const distance3D =(point1, point2) => {
    const x = point1.x - point2.x;
    const y = point1.y - point2.y;
    const z = point1.z - point2.z;

    return x*x + y*y +z*z;
}

let possibleConnections = [];
for (let i = 0; i < boxes.length; i++) {
    const box1 = boxes[i];
    for (let j = i+1; j < boxes.length; j++) {
        if (i === j){
            continue;
        }
        const box2 = boxes[j];
        const dist = distance3D(box1, box2);
        possibleConnections.push({from:i, to:j, dist})
    }
}

const sortedConnections = possibleConnections.toSorted((a,b) => a.dist - b.dist);

let groups = [];

const connCount = 1000;

for (let i = 0; i < connCount; i++) {
    let connection = sortedConnections[i];

    const existingGroupTo = groups.find(group => group.includes(connection.to));
    const existingGroupFrom = groups.find(group => group.includes(connection.from));

    if (existingGroupFrom && existingGroupTo) {
        if (existingGroupTo.includes(connection.from)){
            continue;
        }

        const groupToIdx = groups.indexOf(existingGroupTo);
        groups.splice(groupToIdx, 1);
        existingGroupFrom.push(...existingGroupTo);

    } else if ( existingGroupTo ){
        if (existingGroupTo.includes(connection.from)){
            continue;
        } else {
            existingGroupTo.push(connection.from);
        }
    } else if ( existingGroupFrom ){
        if (existingGroupFrom.includes(connection.to)){
            continue;
        } else {
            existingGroupFrom.push(connection.to);
        }
    } else {
        groups.push([connection.from, connection.to]);
    }
}

console.log(groups);

const sizes = groups.map(group => group.length);
const sortedSizes = sizes.sort((a,b) => b - a);
console.log(sortedSizes[0]);
console.log(sortedSizes[1]);
console.log(sortedSizes[2]);
console.log(sortedSizes[0] * sortedSizes[1] * sortedSizes[2]);

