
// Returns a greeting message for a given name.
// fn greet(name: []const u8) []const u8 {
//    return name;
//}

// pub fn main() void {
//    const who = greet("World");
//    std.debug.print("Hello, {s}!\n", .{who});
//}


// Importing the std lib, the @ prefix is for builtin functions
const std = @import("std");

// Some beginner notes to extract:
// Zig treats unused variables as ERRORS, not just warnings. We literally can't compile with unused vars?

// !void => "this fn returns nothing, but might error" ( ! is the error union type)
// you MUST handle it, with try, catch, or by returning !ReturnType ourselves to propagate it
//
// See the 'try's we have throughout the inner portions?
// Take that first try before the while loop. If an error occurs, it propagates up ..to main!
// and since main() has the ! before void, it means "main can return an error to its caller"
// But who/what calls main? The Zig runtime!
// If any try in main hits an error an propagates up:
// Main rets that error to the Zig runtime, runtime prints that err to stderr (sth like error.BrokenPipe)
// Then the prog exits with non-zero exit code
pub fn main() !void {
    const stdout = std.getStdOut().writer();
    //const stdout = std.fs.File.stdout();
    //const stdin = std.fs.File.stdin();
    //const thing = std.fs.File.stdout();
    //const stdin = std.Io.Writer();
    const stdin = std.io.getStdIn().reader();
    const file = std.io.getStdOut();
    // const w = file.
    // const stdin_reader = std.

    var buffer: [1024]u8 = undefined; // buffer for reading input

    // try = propagate error up if this fails (syntactic sugar for err handling)
    // .{} = empty anonymous struct (used for format args here, also where we'd insert literals for {s} stuff)
    // EX: ("Hello {s}, you're {d} yrs old\n", .{name,age})
    try stdout.print("Type q to quit\n", .{});

    while (true) {
        try stdout.print("> ", .{});

        // if (try ...) |line|   -> optional unwrapping, checking if we got input and capturing it
        // & -> the "address of" operator: gives us a pointer to buffer
        // so &buffer is "pointer to this buffer on the stack"
        // (&buffer, '\n') here means:
        //       "read from stdin, write into the memory at
        //       &buffer, and stop when we hit a newline character"
        // The function returns: ?[]const u8  - an optional slice that points into our buffer
        // at the data we just wrote. That's what |line| captures.
        if (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
            // 'line' is the input (without the newline)
            if (std.mem.eql(u8, line, "q")) {
                break; // exit the whole loop
            }
            try stdout.print("You typed: {s}\n", .{line});
        }
    }
}
