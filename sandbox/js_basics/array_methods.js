
// ===== ARRAY METHODS: DRILL STRUCTURE =====
// Rule: Write each solution, run it, then move to next

// ===== 1. MAP: TRANSFORM EACH ELEMENT =====

// TODO: Square each number
// Expected: [1, 4, 9, 16]
const nums1 = [1, 2, 3, 4];
console.log(nums1.map(n => n ** 2))


// TODO: Uppercase each string
// Expected: ["ALICE", "BOB"]
const names1 = ["alice", "bob"];
console.log(names1.map(n => n.toUpperCase()))

// TODO: Double each number
// Expected: [4, 8, 12]
const nums2 = [2, 4, 6];
console.log(nums2.map(n => n * 2))


// TODO: Add index to each word
// Expected: ["a0", "b1", "c2"]
// Hint: map takes (element, index) parameters
const words1 = ["a", "b", "c"];
console.log(words1.map((w, idx) => w + `${idx}` ))

// ===== 2. FILTER: KEEP ELEMENTS THAT MATCH =====

// TODO: Keep only even numbers
// Expected: [2, 4, 6]
const nums3 = [1, 2, 3, 4, 5, 6];
console.log(nums3.filter(n => n % 2 === 0))

// TODO: Keep only long words (length > 3)
// Expected: ["apple", "banana"]
const words2 = ["hi", "apple", "dog", "banana"];
console.log(words2.filter(w => w.length > 3))

// TODO: Keep only adults (age >= 21)
// Expected: Lucy and Ben objects
const users1 = [
  { name: "Tom", age: 17 },
  { name: "Lucy", age: 22 },
  { name: "Ben", age: 21 }
];
console.log(users1.filter(u => u.age >= 21))

// ===== 3. REDUCE: COMBINE INTO SINGLE VALUE =====
// Generic format:
/**
letters.reduce((acc, curr) => {
    // acc starts as whatever comes after the comma
    // Here: acc starts as {} (empty object)
    // NOT null, NOT the first array element
}, {})  // <-- This {} becomes the initial acc value

    So reduce(fn, {}) -> acc starts as {}
    but reduce(fn)    -> acc starts as first array element, be it a str, num, etc
*/

// TODO: Sum all numbers
// Expected: 31
// Hint: reduce((accumulator, current) => ..., startValue)
const nums4 = [1, 5, 10, 15];
console.log(nums4.reduce((acc, curr) => acc + curr, 0))

const words3 = ["cat", "elephant", "dog"];
// TODO: Find the longest word
// Expected: "elephant"
console.log(words3.reduce((acc, curr) => {
    return curr.length > acc.length ? curr : acc;
}))

// TODO: Count how many times each letter appears
// Expected: {a: 3, b: 1, c: 1}
// Hint: Start with empty object {}
const letters = ["a", "b", "a", "c", "a"];
console.log(letters.reduce((acc, curr) => {
    // So for each, we either:
    // HAVE seen it -> increment its vals count
    // HAVEN'T seen it -> add "{letter}: 1" entry in obj
    // return acc[curr] || 0 ? acc[curr] += 1 : acc[curr] = 1; WRONG: Returns result of assignment not the acc object
    acc[curr] = (acc[curr] || 0) + 1; // inc. or initialize entry
    return acc; // return the accumulator object
}, {}))

// ===== 4. CHAINING: COMBINE MULTIPLE METHODS =====

// TODO: Keep only even numbers, then square them
// Expected: [4, 16, 36]
const nums5 = [1, 2, 3, 4, 5, 6];
console.log(nums5
    .filter(n => n % 2 == 0)
    .map(n => n ** 2)
)

// TODO: Keep adults (age >= 21), then extract just their names
// Expected: ["Lucy", "Ben"]
const users2 = [
  { name: "Tom", age: 17 },
  { name: "Lucy", age: 22 },
  { name: "Ben", age: 21 }
];
console.log(users2.filter(u => u.age >= 21).map(u => u.name))


// ===== 5. REAL-WORLD SCENARIOS =====

// TODO: Transform to proper case full names
// Expected: ["Alice Johnson", "Bob Smith"]
const messyUsers = [
  { first: "alice", last: "JOHNSON"},
  { first: "BOB", last: "smith"}
];
// We'll need to title-case in the first map, so this won't work:
// console.log(messyUsers.map(u => `${u.first.toLowerCase()} ${u.last.toLowerCase()}`).map(u => {
//     return u.charAt(0).toUpperCase() + u.slice(1);
// }))
// This solves it by handling title-casing in the first/only map:
const capitalize = str => str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
console.log(messyUsers.map(user => {
    const first = capitalize(user.first);
    const last = capitalize(user.last);
    return `${first} ${last}`;
}));

// Or, one better, we can just title-case the whole string:
console.log(messyUsers.map(u => `${u.first} ${u.last}`)
    .map(fullName => {
        return fullName.split(' ')
                       .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
                       .join(' ');
    }))


// TODO: Keep only inStock items under $50, format as "Hat - $19.50"
// Expected: ["Hat - $19.50"]
const products = [
  { id: 1, name: "Shoes", price: 79.99, inStock: true },
  { id: 2, name: "Hat", price: 19.5, inStock: true },
  { id: 3, name: "Socks", price: 5.0, inStock: false }
];
console.log(products.filter(p => p.price < 50).map(p => `${p.name} - $${p.price.toFixed(2)}`))

// TODO: Extract steps array, then calculate average
// Expected: steps=[8200, 6400, 6700], average=6766.67
const activityData = [
  { date: '2025-10-01', steps: 8200 },
  { date: '2025-10-02', steps: 6400 },
  { date: '2025-10-03', steps: 6700 }
];
const steps = activityData.map(x => x.steps);
const sumStepsArr = steps.reduce((acc, curr) => acc + curr, 0);
const avgSteps = sumStepsArr / steps.length;
console.log(avgSteps);

// ===== BONUS CHALLENGES =====

// TODO: Find first number > 10
// Expected: 12
// Hint: Not map/filter/reduce - what method finds first match?
const nums6 = [2, 8, 12, 5, 20];
console.log(nums6.find(n => n > 10))
// or if we like being convoluted, we could use findIndex and use that:
console.log(nums6[nums6.findIndex(n => n > 10)])


// TODO: Check if ANY user is under 18
// Expected: true
const users3 = [
  { name: "Tom", age: 17 },
  { name: "Lucy", age: 22 }
];
console.log(users3.some(u => u.age < 18))

// TODO: Check if ALL products are in stock
// Expected: false
const products2 = [
  { name: "Shoes", inStock: true },
  { name: "Hat", inStock: false }
];
console.log(products2.every(p => p.inStock))