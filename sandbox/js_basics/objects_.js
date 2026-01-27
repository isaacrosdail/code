
const myObj = {name: "Steve", age: 20 }
const entries = Object.entries(myObj);

console.log(myObj)   // prints obj: { name: "Steve", age: 20, }
console.log(entries) // prints new array from that object, like so:
// [ [name, "Steve", age, 20] ]