// ===== FUNCTION TYPES & THIS BINDING =====

// ===== KEY TAKEAWAYS =====
/*
1. Regular functions: this = caller (dynamic)
2. Arrow functions: this = lexical scope (static)
3. Dot rule: this = object before the dot
4. Context loss: Assigning methods breaks binding
5. Callbacks: Usually lose context, need capture pattern
6. D3 pattern: Capture instance properties before nested callbacks
*/

// 1. Foundation: Function types determine 'this' behavior.
const demo = {
    name: "Alice",

    // Regular function: 'this' determined by caller (dynamic binding)
    regularFn: function() {
        console.log("Regular:", this.name);
    },

    // Arrow function: 'this' from lexical scope (static binding)
    arrowFn: () => {
        console.log("Arrow:", this.name); // 'this' = global/undefined
    }
};

demo.regularFn(); // "Alice" - 'this' = demo object
demo.arrowFn();   // undefined - 'this' = global scope

// 2. THE DOT RULE: this = object before the dot
function sayName() {
    console.log("Hi, I'm", this.name);
}

const person1 = { name: "Alice", greet: sayName };
const person2 = { name: "Bob", greet: sayName };

console.log("\n=== DOT RULE ===");
person1.greet(); // this = person1
person2.greet(); // this = person2
// sayName();    // this = undefined (strict mode) - no dot!

// 3. CONTEXT LOSS: Assigning methods breaks the dot rule / binding
const person = {
    name: "Charlie",
    greet: function() {
        console.log(`Hi, I'm ${this.name}`);
    }
};

console.log("\n=== Context Loss ===");
person.greet();                    // Works: this = person
const lostGreeting = person.greet; // Just assigns the function
lostGreeting();                    // Broken: this = undefined (no dot!)

/**
 * Key takeaway: person.greet() calls the function WITH context
 *               lostGreeting() calls the SAME function WITHOUT context.
 */



// ===== 4. Callback Context Problem =====
// Now, for how this ties into D3
const chart = {
    radius: 100,
    draw: function() {
        console.log("\n === Callback Problem ===");
        console.log("Chart radius: ", this.radius); // this = chart

        const data = [1,2,3];
        data.forEach(function(d) {
            console.log("Inside forEach, radius: ", this.radius); // this = undefined!
            // forEach calls or callback, but without any context
        });
    }
};

chart.draw(); // Here, 'this' = chart

// === 5. Solutions: How to fix callback context ===
const chartFixed = {
    radius: 200,
    draw: function() {
        console.log("\n === Solutions ===");
        const data = [1, 2, 3];

        // Solution 1: Capture this in a variable
        const self = this;
        data.forEach(function(d) {
            console.log("Captured method, radius:", self.radius); // works!
        });

        // Solution 2: Use arrow function (inherits 'this')
        data.forEach((d) => {
            console.log("Arrow method, radius:", this.radius); // works!
        })
    }
}

chartFixed.draw();


// === 6. Real World D3 Example ===

/* 
In D3, we often have nested contexts:
1. Chart method: this = Chart instance
2. D3 callback: this = DOM element (D3 sets it)

The challenge: Need both the Chart instance AND the DOM element
*/

class Chart {
    updateChart() { // Layer 1: this = Chart instance
        const groups = selectAll(...).data(...).join(
            enter => {} // this = Chart instance

            update => { // Layer 2: this = Chart instance still
                update.select('path')
                    .attrTween("d", function(d) { // Layer 3: D3 'hijacks' 'this' here!
                        // Now, 'this' = DOM element, NOT Chart
                    });
            }
        );
    }
}

// So what's the fix? Well, we can just store the reference to the class property before that:
update => {
    const arc = this.arc;  // Capture Chart's arc before going deeper

    update.select('path')
        .attrTween("d", function(d) {
            // 'this' = DOM element (what D3 set, and needed for _current)
            // 'arc' = Chart's arc (still accessible, captured via closure)
        });
}
// 

