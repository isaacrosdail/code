// We'll create a hash of "cat" and try to crack it
const crypto = require('crypto');
const target = crypto.createHash('sha256').update('cat').digest('hex');
console.log(`Target hash: ${target}`);
// Try all 3-letter combinations: aaa, aab, aac... until we find "cat"