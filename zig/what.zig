const std = @import("std");

pub fn main(init: std.process.Init) !void {
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
