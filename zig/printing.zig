
// Zig Version: 0.16.0-dev.2040+c475f1fcd

const std = @import("std");

pub fn main(init: std.process.Init) !void {

    // Misc notes to sort:
    // If you want to do debug printing to stderr, you can use std.debug.print
    //      it's not very efficient but it's thread-safe and ties in with std.Progress?
    var buffer: [1024]u8 = undefined;
    const thing = "WOW";
    const writer = std.Io.writer(init.io, &buffer);
    try writer.interface.print("OMG, {s}!", .{thing});

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_w = std.Io.File.stdout().writer(init.io, &stdout_buffer); // the writer state. buffer can just be &.{} if you don't want buffering (you almost always do!)
    const stdout = &stdout_w.interface; // the interface. You get all the std.Io.Writer goodies
    try stdout.print("Hello!\n", .{});
    try stdout.flush(); // dont forget to flush!
}



pub fn save_me(init: std.process.Init) !void {
//    @compileLog(std);
//    @compileLog(@TypeOf(std.debug));
    
//    @compileLog(@typeName(std.fs.File.stdout));

    const stdout = std.Io.File.stdout();
    //var buffer: [4096]u8 = undefined;
    // var writer = std.Io.writer(init.io, &buffer);
    
    // const name = "Isaac";

    //const writer = std.Io.Writer(init.io, stdout, &buffer);
    // In Zig, strings are just slices of bytes
    const name = "me"; // []const u8 -> a slice ([]) of constant (const) bytes (u8)
                       // where u8 indeed means unsigned 8-bit integer
                       // meaning...if we use {s} it prints as a string
                       // but if we use {d} we get the int?
    //const writer = stdout.writer();
    try stdout.writeStreamingAll(init.io, "Hello noname!\n");
    try stdout.writer().print("Hello, {s}!", .{name});
}
