
// Pattern:
// const proxy = new Proxy(target, handler);
// target: the original object we're wrapping
// handler: object containing our trap methods
// proxy: what we actually interact with

// Traps' signatures are static, meaning each trap type has a defined sig from the JS spec:
// You can't change these, they're baked into how Proxies work
// NOTE: Receiver is for adv inheritance stuff? Refs the object the operations was originally performed on
// which matters when we have prototype chains or when a proxy is involved in inheritance.

const myObj = {
    username: "Bob",
    email: "bobsemail@bobsemail.com",
    password: "god123",
    age: 43
}

const proxyObj = new Proxy(myObj, {

    // Get traps return what they're getting (duh)
    get(target, property, receiver) {
        console.log(`Someone's trying to read: ${property}`)
        if (property === 'email') {
            return target[property].toUpperCase();
        }
        return target[property];
    },

    // Set traps return true/false indicating whether they "should be forwarded"
    set(target, property, value, receiver) {
        console.log(`Old val: ${target[property]}`);
        console.log(`New val: ${value}`)
        target[property] = value;
        return true;
    },

    // Has traps fire for 'property' in obj checks
    has(target, property) {
        if (property === 'password') {
            return false;
        }
    }
})

// NOTE: This WON'T trigger the proxy, since the proxy only intercepts
// operations performed on the proxyObj itself, not on the original target.
// myObj.age = 23;

// We're always interacting with the proxyObj itself, never with the original {}
// proxyObj.age = 23;
// proxyObj.thing = "New"
// console.log(myObj.thing)
console.log(proxyObj.email)
console.log(proxyObj.username)
console.log('password' in proxyObj)