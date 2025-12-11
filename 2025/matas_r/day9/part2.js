const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const corners = text.split(/\r?\n/).map((line, id) => {
    const [x,y] = line.split(",");
    return {id, x: Number(x), y: Number(y), };
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
        possibleRects.push({from:i, to:j, fromCorner: corner1, toCorner: corner2, area});
    }
}


const getRectEdges = ({fromCorner, toCorner}) => {
    const maxX = Math.max(fromCorner.x, toCorner.x);
    const minX = Math.min(fromCorner.x, toCorner.x);
    const maxY = Math.max(fromCorner.y, toCorner.y);
    const minY = Math.min(fromCorner.y, toCorner.y);
    
    
    return {horizontals:[{y: minY, x1: minX, x2: maxX},
        {y: maxY,x1: minX, x2: maxX}], 
        verticals:[{x: minX, y1: minY, y2: maxY},
            {x: maxX, y1: minY, y2: maxY}
        ]}
}

const getRectCorners = ({fromCorner, toCorner}) => {
    const maxX = Math.max(fromCorner.x, toCorner.x);
    const minX = Math.min(fromCorner.x, toCorner.x);
    const maxY = Math.max(fromCorner.y, toCorner.y);
    const minY = Math.min(fromCorner.y, toCorner.y);

    return [
        { x: minX, y: minY },
        { x: maxX, y: minY },
        { x: maxX, y: maxY },
        { x: minX, y: maxY },
    ];
}

const getPolygonEdges = ({fromPoint, toPoint}) => {
    if (fromPoint.x == toPoint.x){
        return {horizontals: [], verticals:[{x: fromPoint.x, y1: Math.min(fromPoint.y,toPoint.y), y2: Math.max(fromPoint.y,toPoint.y)}]};
    }else {
        return {horizontals: [{y: fromPoint.y, x1: Math.min(fromPoint.x,toPoint.x), x2: Math.max(fromPoint.x,toPoint.x)}], verticals:[]};
    }

}

function pointOnSegment(px, py, ax, ay, bx, by) {
  // Horizontal
  if (ay === by && py === ay && px >= Math.min(ax, bx) && px <= Math.max(ax, bx)) {
    return true;
  }
  // Vertical
  if (ax === bx && px === ax && py >= Math.min(ay, by) && py <= Math.max(ay, by)) {
    return true;
  }
  return false;
}

function pointInPolygon(px, py, polygonCorners) {
  let inside = false;

  for (let i = 0; i < polygonCorners.length - 1; i++) {
    const a = polygonCorners[i];
    const b = polygonCorners[i + 1];

    // boundary (edge) check
    if (pointOnSegment(px, py, a.x, a.y, b.x, b.y)) {
      return true; // on edge counts as inside
    }

    // standard ray casting
    const intersect =
      ((a.y > py) !== (b.y > py)) &&
      px < ((b.x - a.x) * (py - a.y)) / (b.y - a.y) + a.x;

    if (intersect) inside = !inside;
  }

  return inside;
}

const isPointsInside = (rect, polygonCorners) => {
    const corners = getRectCorners(rect);

    for (const p of corners) {
        if (!pointInPolygon(p.x, p.y, polygonCorners)) {
            return false;
        }
    }

  return true;
}


const doesIntersect = (h,v) => v.x > h.x1 && v.x < h.x2 && h.y > v.y1 && h.y < v.y2;

const isInside = (rect, polygonEdges, polygonCorners) => {
    const rectEdges = getRectEdges(rect);

    for (let i = 0; i < rectEdges.horizontals.length; i++) {
        const h = rectEdges.horizontals[i];
        for (let j = 0; j < polygonEdges.verticals.length; j++) {
            const v = polygonEdges.verticals[j];
            if (doesIntersect(h,v)){
                return false;
            }
        } 
    }

    for (let i = 0; i < rectEdges.verticals.length; i++) {
        const v = rectEdges.verticals[i];
        for (let j = 0; j < polygonEdges.horizontals.length; j++) {
            const h = polygonEdges.horizontals[j];
            if (doesIntersect(h,v)){
                return false;
            }
        } 
    }

    return isPointsInside(rect, polygonCorners);
}

// add first corner to the end to finish shape
corners.push({...corners[0], id: corners[corners.length-1].id+1});

const polygonEdges = {horizontals: [], verticals: []};
for (let i = 0; i < corners.length - 1; i++) {
    const { horizontals, verticals } = getPolygonEdges({fromPoint: corners[i], toPoint: corners[i+1]});
    polygonEdges.horizontals.push(...horizontals);
    polygonEdges.verticals.push(...verticals);
}

const sortedRects = possibleRects.toSorted((a,b) => b.area - a.area);

for (let i = 0; i < sortedRects.length; i++) {
    const rect = sortedRects[i];
    if (isInside(rect, polygonEdges, corners)) {
        console.log(rect);
        break;
    }
}

console.log("finished");