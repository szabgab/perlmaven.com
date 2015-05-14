"use strict";
function sum() {
    var s = 0, i;
    for (i = 0; i < arguments.length; i += 1) {
        s += arguments[i];
    }
    return s;
}

console.log(sum(2, 3));         // 5
console.log(sum(-10, 1));       // -9
console.log(sum(1, 1, 1, 1));   // 4
console.log(sum());             // 0

