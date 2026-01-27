// Sets - added 2015, so they're presumably much less jank than much of JS
// Unordered collections with O(1) lookup
// Ideal for "is x in thing?" & deduplication since entries are entirely unique

const mySet = new Set();
mySet.add(42)
mySet.add("42")
mySet.add({ id: 1 })
console.log(mySet)

console.log(mySet.has("42"))
console.log(mySet.delete(42))
console.log(mySet.clear())
console.log(mySet.size)
