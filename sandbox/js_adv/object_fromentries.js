// idk where tf to put this so

// Object.fromEntries() works with ANY iterable of [key, value] pairs

// All of these work:
Object.fromEntries(map)                    // Map
Object.fromEntries([["a", 1], ["b", 2]])  // Array of pairs  
Object.fromEntries(map.entries())         // Map iterator

// Object <-> [key, value] pairs <-> Map

const myObj = { id: 3, name: "Billy Bobby Boy Mayes HERE! WITH OXICLEAN" }
const myNewArr = Object.entries(myObj)