// Spread operator - unpacks stuff (allowing us to re-pack things together to splice things together!)


const numbers = [1, 2, 3, 4, 5]
Math.max(...numbers) // unpacks all numbers as params, then finds max ofc

const arr1 = [1, 2];
const arr2 = [3, 4];

const result1 = [0, ...arr1, 99, ...arr2]
console.log(result1)

const obj1 = { a: 1, b: 2 };
const obj2 = { c: 3, b: 99 };
const merged = {...obj1, ...obj2}; // What happens to 'b'?
// Answer: just like Python's merge operator, "later wins", so it takes on a val of 99
const merged2 = {...obj1, newProp: "hi", ...obj2}
console.log(merged)

// from maps_.js:
// const thingArray = [...map.keys()] or map.entries() or map.values() in place of map.keys()