// Maps are like objs but better for lookups (O(1)) and iteration
// Maps are also iterable

// For comparison checks, they use SameValueZero (basically like ===, except NaN equals itself?)

const myMap = new Map();

// Setting key-val pairs
// Keys can be ANY type
myMap.set('name', 'Steve');
myMap.set('age', 30);
myMap.set(42, 'answer to everything');

// Getting vals
console.log('Getting name:', myMap.get('name'))
console.log(myMap.has('name'))
// const newMap = myMap.clear()
console.log(myMap)

const startTime = performance.now();
const taskMap = new Map();
taskMap.set('task1', {id: 'task1', name: 'Warsh clothes', x: 100, y: 100})
taskMap.set('task2', {id: 'task2', name: 'Dry clothes', x: 100, y: 100})
const endTime = performance.now();
console.log(taskMap)
console.log(`Took: ${endTime - startTime}ms`)


// Convert array to Map for faster lookups
const users = [
    {id: 'u1', name: 'Alice', role: 'admin'},
    {id: 'u2', name: 'Bob', role: 'user'},
    {id: 'u3', name: 'Charlie', role: 'moderator'}
];

const obj = {};
obj[42] = "number key";

const keyObj1 = { id: 1 };
obj[keyObj1] = "first obj"
console.log(obj)


const thingy = new Map();
thingy.set(42, 'the answer')
thingy.set("42", "diff answer")
thingy.set({ key: "user" }, "obj key?")

// console.log(thingy.get(42))
// console.log(thingy.has("42"))
// console.log(thingy.delete("42"))
// console.log(thingy.clear())
// console.log(thingy.size)


const thingy2 = new Map();
thingy2.set({ key: "user" }, "obj key?");
console.log(thingy2.get({ key: "user" })); // undefined! They're different objects,
// even tho they look the same. Maps use reference equality (===), not deep equality.

// How can we fix that?
const myKey = { key: "user" }
thingy.set(myKey, "obj key?")
// console.log(thingy.get(myKey)) // This prints the right thing, since the reference to our object is now assigned and constant!


// Maps are iterable
const map = new Map([
    [42, "number"],
    ["42", "string"],
    [true, "bool"]
]);

// for .. of map returns [key, value] pairs
for (const x of map) {
    console.log(x)
}
// ...meaning we can also just destructure it:
for (const [key, val] of map) {
    console.log(`${key} -> ${val}`)
}

// keys, values, entries return iterators
console.log(map.keys())
// console.log(map.values())
// console.log(map.entries())

// How would we convert map.keys() to an actual array?
const keysArray = [...map.keys()]        // -> [ 42, "42", true ]
const valsArray = [...map.values()]     // -> [ "number", "string", "bool" ]
const entriesArray = [...map.entries()]
// [ 
//     [ 42, "number" ], [ "42", "string" ], [ true, "bool" ]
// ]

// When you iterate over a Map directly, it defaults to entries, which is
// why the [...map.entries()] and [...map] forms here produce the exact same result
// console.log([...map])
// console.log([...map.values(), "extra"])
// console.log(Array.from(map)) // equivalent then to: Array.from(map.entries())


// Converting!
const mapAsObj1 = Object.fromEntries(map);  // convert map -> obj
const objAsMap1 = new Map(Object.entries(mapAsObj1)); // convert obj -> map
console.log("\n ======= mapAsObj ========")
console.log(mapAsObj1)
console.log("\n ======= objAsMap ========")
console.log(objAsMap1)


// Try: You get API data as an obj, but need Map methods for processing
const apiData = { user_1: "Alice", user_2: "Bob", user_3: "Charlie" };
// Challenge: Convert to Map, filter out "Bob", convert back to object
// Use your new powers: Object.entries, Map constructor, iteration, Object.fromEntries

const objAsMap = new Map(Object.entries(apiData)) // new Map(entries) consumes that iterable
console.log(objAsMap)
objAsMap.delete("user_2")
const mapAsObj = Object.fromEntries(objAsMap);
console.log(mapAsObj)

// What if we wanna filter by value instead of key?
// Same apiData, but filter out any name starting with 'B'
const apiData2 = { user_1: "Alice", user_2: "Bob", user_3: "Charlie" };

const entries = Object.entries(apiData) // gives us our array :D
console.log(entries)
// const filtered = entries.filter(([key, val]) => val.slice(0,1) !== 'B')
// const filtered = entries.filter(([key, val]) => val[0] !== 'B')
const filtered = entries.filter(([key, val]) => !val.startsWith('B'))
console.log(filtered)