const std = @import("std");


pub fn main() void {
    std.debug.print("Hello\n", .{});

    const u8_val:   u8   = 255;
    const u16_val:  u16  = 65535;
    const u32_val:  u32  = 4294967295;
    const u64_val:  u64  = 18446744073709551615;

    const i8_val:   i8   = -128;
    const i16_val:  i16  = -32768;
    const i32_val:  i32  = -2147483648;
    const i64_val:  i64  = -9223372036854775808;

    const usize_val: usize = 42;
    const isize_val: isize = -42;

    const byte_slice: []const u8 = "hello";

    // Print them (to stderr using debug.print, or swap for your stdout writer)
    std.debug.print("u8:   {}\n", .{u8_val});
    std.debug.print("u16:  {}\n", .{u16_val});
    std.debug.print("u32:  {}\n", .{u32_val});
    std.debug.print("u64:  {}\n", .{u64_val});

    std.debug.print("i8:   {}\n", .{i8_val});
    std.debug.print("i16:  {}\n", .{i16_val});
    std.debug.print("i32:  {}\n", .{i32_val});
    std.debug.print("i64:  {}\n", .{i64_val});

    std.debug.print("usize: {}\n", .{usize_val});
    std.debug.print("isize: {}\n", .{isize_val});

    std.debug.print("string: {s}\n", .{byte_slice});
}
