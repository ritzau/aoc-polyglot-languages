const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, World from Zig! ⚡\n", .{});
    try stdout.print("This is a hello world program for AOC polyglot setup.\n", .{});
}
