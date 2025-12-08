const fs = require("fs");
const path = require("path");

const DEFAULT_CONNECTIONS = 1000;
const connectionLimit = Number(process.env.CONNECTIONS ?? DEFAULT_CONNECTIONS);
if (!Number.isFinite(connectionLimit) || connectionLimit < 0) {
  throw new Error("CONNECTIONS must be a non-negative number");
}

const filePath = path.join(__dirname, process.argv[2] ?? "input.txt");
const text = fs.readFileSync(filePath, "utf8");
const boxes = text
  .trim()
  .split(/\r?\n/)
  .filter(Boolean)
  .map((line, id) => {
    const [x, y, z] = line.split(",").map((value) => Number(value));
    if ([x, y, z].some((value) => !Number.isFinite(value))) {
      throw new Error(`Invalid coordinate on line ${id + 1}: ${line}`);
    }
    return { id, x, y, z };
  });

if (boxes.length === 0) {
  console.log("No junction boxes in input.");
  process.exit(0);
}

const edges = [];
for (let i = 0; i < boxes.length; i++) {
  for (let j = i + 1; j < boxes.length; j++) {
    const a = boxes[i];
    const b = boxes[j];
    const dx = a.x - b.x;
    const dy = a.y - b.y;
    const dz = a.z - b.z;
    const distanceSq = dx * dx + dy * dy + dz * dz;
    edges.push({ a: i, b: j, distanceSq });
  }
}

edges.sort((first, second) => first.distanceSq - second.distanceSq);

const parent = Array.from({ length: boxes.length }, (_, index) => index);
const size = Array.from({ length: boxes.length }, () => 1);
let components = boxes.length;

const find = (node) => {
  if (parent[node] !== node) {
    parent[node] = find(parent[node]);
  }
  return parent[node];
};

const union = (first, second) => {
  const rootA = find(first);
  const rootB = find(second);
  if (rootA === rootB) {
    return false;
  }
  if (size[rootA] < size[rootB]) {
    parent[rootA] = rootB;
    size[rootB] += size[rootA];
  } else {
    parent[rootB] = rootA;
    size[rootA] += size[rootB];
  }
  components--;
  return true;
};

const limit = Math.min(connectionLimit, edges.length);
for (let i = 0; i < limit; i++) {
  union(edges[i].a, edges[i].b);
}

const componentSizes = new Map();
for (let i = 0; i < boxes.length; i++) {
  const root = find(i);
  componentSizes.set(root, (componentSizes.get(root) ?? 0) + 1);
}

const sortedSizes = Array.from(componentSizes.values()).sort((a, b) => b - a);
const [first = 0, second = 0, third = 0] = sortedSizes;
const product = first * second * third;

console.log(
  `Largest three circuit sizes: ${first}, ${second}, ${third}. Product: ${product}`,
);
