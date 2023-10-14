const utils = @import("utils.zig");
const turnip = @import("turnip.zig");
const map = @import("map.zig");

pub var x: f32 = 0;
pub var y: f32 = 0;

pub var xi: i32 = 0;
pub var yi: i32 = 0;

pub fn update(tx: f32, ty: f32) void {
    var next_x: f32 = 0;
    var next_y: f32 = 0;

    next_x = tx - 320 / 2;
    next_x = utils.clamp(next_x, 0, map.lvl[0].len * 16 - 320);

    next_y = ty - 240 / 2;
    next_y = utils.clamp(next_y, 0, map.lvl.len * 16 - 240);

    x = x - (x - next_x) / 8;
    y = y - (y - next_y) / 8;

    xi = @intFromFloat(x);
    yi = @intFromFloat(y);
}
