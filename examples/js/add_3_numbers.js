function add(x, y) {
    return x+y;
}
function add(x, y, z) {
    return x+y+z;
}

console.log(add(2, 3));      // NaN
console.log(add(-1, 1));     // NaN

console.log(add(1, 1, 1));   // 3
