const camera = @import("camera.zig");

pub extern fn blit(spr: *const [256]u8, dx: i32, dy: i32, trans: u8, flip: bool) void;
pub extern fn rect(i32, i32, i32, i32, u8) void;

pub const Anim = struct {
    frames: []const [256]u8,
    counter: u8 = 0,
};
