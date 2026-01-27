// === LOOPS & ITERATION ===

// ===== LOOP SELECTION GUIDE =====
/*
for (let i = 0; i < n; i++)     → Counting, indices matter
for (const item of array)       → Simple array iteration  
for (const [i, item] of arr.entries()) → Array with indices
for (const [k, v] of Object.entries()) → Object iteration
while (condition)               → Unknown iteration count
*/


// 1. BASIC COUNTING: for loop
for (let i = 1; i <= 10; i++) {
    console.log(i);
}

// Alternative one-liner (less clear for learning):
// console.log(Array.from({ length: 10 }, (_, i) => i + 1));

// 2. ARRAY ITERATION: for...of
console.log("\n=== Simple array iteration ===");
// Use when: You only need the values, no index
for (const fruit of fruits) {
    console.log(fruit);
}

// 2b. ARRAY ITERATION WITH indices:
console.log("\n=== Array with indices ===");
const fruits = ['apple', 'banana', 'cherry'];

// Use .entries() when you need both index and value
// Array.entries() returns an iterator of [index, value] pairs
// It's the "iterate with index" method when we need both pieces of info
// could also do:
// myArr1.forEach((element, idx) => ...)
// but for...of is cleaner for simple logging
for (const [idx, fruit] of fruits.entries()) {
    console.log(`${idx}: ${fruit}`);
}
// Alternative: forEach (less flexible can't break/continue)
// fruits.forEach((fruit, idx) => console.log(`${idx}: ${fruit}`));


// 3. OBJECT ITERATION: for...in vs Object.entries()
// loop thru obj and log "key: value" pairs
const person = {name: 'John', age: 30, city: 'NYC'}

// Confusingly similar to myArr1.entries thing above!
// Objects use the static method: Object.entries(object)
// Both return [key, value] pairs, but the syntax differs bc arrays are
// iterable objs while plain objs are not.
// Method 1: Object.entries() (preferred - more explicit)
for (const [key, value] of Object.entries(person)) {
    console.log(`${key}: ${value}`);
}
// Method 2: for...in BUT this is legacy (has prototype chain issues), so just ignore


// 4. CONDITION-BASED: while
console.log("\n=== While loop ===");
// Use when: You don't know how many iterations you need
let countdown = 3;
while (countdown > 0) {
    console.log(`Countdown: ${countdown}`);
    countdown--;
}

// ===== 6. NESTED ARRAYS: Correct way =====
console.log("\n=== 2D Array iteration ===");
const matrix = [[1, 2], [3, 4], [5, 6]];

// Simple: just log each inner array
console.log("Method 1 - Log inner arrays:");
for (const row of matrix) {
    console.log(row); // [1, 2], [3, 4], [5, 6]
}

// Complex: access individual elements
console.log("\nMethod 2 - Log individual elements:");
for (let i = 0; i < matrix.length; i++) {
    for (let j = 0; j < matrix[i].length; j++) {
        console.log(`matrix[${i}][${j}] = ${matrix[i][j]}`);
    }
}

// Modern: flat iteration
console.log("\nMethod 3 - Flatten and iterate:");
for (const value of matrix.flat()) {
    console.log(value); // 1, 2, 3, 4, 5, 6
}

// ===== 7. ARRAY vs OBJECT: Why the difference? =====
console.log("\n=== Why arrays and objects differ ===");

// Arrays implement the iterable protocol
console.log("Array has Symbol.iterator:", typeof fruits[Symbol.iterator]); // "function"

// Plain objects don't implement iterable protocol  
console.log("Object has Symbol.iterator:", typeof person[Symbol.iterator]); // "undefined"

// That's why:
// for (const item of fruits) {} ✅ Works
// for (const item of person) {} ❌ TypeError

// Object.entries() converts object → iterable array of pairs
console.log("Object.entries() result:", Object.entries(person));
// [["name", "John"], ["age", 30], ["city", "NYC"]]



// Arrays and objects are ofc different built-ins: arrays are iterable by default, plain objects are not, which is why for...of works
// on arrays but not on objects

// Python's dicts DO NOT EXIST in JS. JS has no such equivalent.
// Objects are more like key-vals

// Source - https://stackoverflow.com/a
// Posted by Kyle, modified by community. See post 'Timeline' for change history
// Retrieved 2026-01-23, License - CC BY-SA 4.0

// const myArr = ['A', 'B', 'C'];

// // Array.prototype.entries() -> https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/entries
// for (const [index, element] of myArr.entries()) {
//   console.log(index, element);
// }

// Object.entries({ a: 1, b: 2 }) gives [["a", 1], ["b", 2]]

