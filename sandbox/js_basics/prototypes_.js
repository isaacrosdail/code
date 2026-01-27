// Every JS object has a hidden [[Prototype]] link to another object. That's how inheritance works:
// const arr = [1, 2, 3];
// arr's prototype is Array.prototype
// Array.prototype's prototype is Object.prototype
// Object.prototype's prototype is null (end of chain)


// PROTOCOLS: Protocols are interfaces - agreements about methods an obj should have to work
// with certain language features.
// Key Protocols:
//      Iterable Protocol: Object has Symbol.iterator method → works with for...of, ...spread, Array.from()
//      Iterator Protocol: Object has .next() method that returns {value, done}

// Arrays implement iterable protocol
// console.log(Array.prototype[Symbol.iterator]); // function

// Plain objects don't 
// console.log(Object.prototype[Symbol.iterator]); // undefined

let arr = [1, 2, 3];

// // Where does .push() live?
// console.log(arr.push);           // What do you expect?
// console.log(arr.__proto__);      // What object is this?
// console.log(arr.__proto__.push); // And this?

// // Keep going up the chain
// console.log(arr.__proto__.__proto__);          // What's this?
// console.log(arr.__proto__.__proto__.__proto__); // And this?

// This shows the chain of prototypes:
// arr -> Array.prototype -> Object.prototype ->  null
//        ^ (has .push())    ^ (has .toString())  ^ (end)

// So an array is an object that "inherits" methods from Array.prototype, which inherits from
// Object.prototype.

const myStr = "hello";

console.log(myStr.__proto__)