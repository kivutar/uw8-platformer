const camera = @import("camera.zig");

pub extern fn blitSprite(i32, i32, i32, i32, i32) void;
pub extern fn rectangle(f32, f32, f32, f32, i32) void;

pub fn blit(spr: *const [256]u8, size: i32, x: i32, y: i32, ctrl: i32) void {
    blitSprite(@intCast(i32, @ptrToInt(spr)), size, x, y, ctrl);
}

pub const Anim = struct {
    frames: []const [256]u8,
    counter: u8 = 0,
};
