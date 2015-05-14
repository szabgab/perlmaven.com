"use strict";
function sum() {
    var s = 0;
    var i;
    for (i=0; i < arguments.length; i++) {
        s += arguments[i];
    }
    return s;
}

console.log(sum(2, 3));         // 5
console.log(sum(-10, 1));       // -9
console.log(sum(1, 1, 1, 1));   // 4
console.log(sum());             // 0

