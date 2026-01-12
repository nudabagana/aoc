const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");

let shapes = [];
let boards = [];

text.split(/\r?\n/).forEach(line => {
    if (line.includes("x")){
        const [sizeStr, shapesStr ] = line.split(":");
        const [x,y] = sizeStr.split("x");
        boards.push({x: Number(x), y: Number(y), shapes: shapesStr.trim().split(" ").map(Number)})
    } else if (line.includes(":")){
        shapes.push({id: line.split(":")?.[0], shape: []});
    } else if (line.includes("#") || line.includes(".")){
        shapes[shapes.length - 1].shape.push([...line])
    }
});

for (let i = 0; i < shapes.length; i++) {
    const shape = shapes[i];
    var size = 0;
    shape.shape.forEach( line => {
        line.forEach( char => {
            if (char == "#"){
                size++;
            }
        })
    });
    shapes[i].size = size;
}

const shapeMap = {};
shapes.forEach( shape => {
    shapeMap[shape.id] = shape;
});


// shapes.forEach(({id, size, shape}) => {
//     console.log(`Id: ${id}, size: ${size}`);
//     shape.forEach(line => {
//         console.log(line);
//     });
// })

let result = 0;
boards.forEach( board => {
    const boardSize = board.x * board.y;
    var shapeSizeSum = 0;
    board.shapes.forEach((shapeCount, id) => {
        shapeSizeSum+= shapeCount * shapeMap[id].size;
    });

    const fits = boardSize  >= shapeSizeSum;
    if (fits){
        result++;
    }
    console.log(`size:${boardSize}, shape size: ${shapeSizeSum}, fits: ${fits}`);
});

console.log(result);