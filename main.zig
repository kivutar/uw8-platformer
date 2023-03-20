const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const turnip = @import("turnip.zig");
const camera = @import("camera.zig");

extern fn cls(color: i32) void;

const Rigid = struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
    speed: f32,
    angle: f32,
    xspeed: f32,
    yspeed: f32,
    xaccel: f32,
    yaccel: f32,
};

export fn upd() void {
    cls(44);

    turnip.tur1.update();
    camera.update();

    draw();
}

fn draw() void {
    for (0..map.lvl.len) |y| {
        for (0..map.lvl[0].len) |x| {
            if (map.lvl[y][x] == 1 and map.lvl[y - 1][x] != 1) {
                gfx.blit(&sprites.herb, @intCast(i32, x) * 16, @intCast(i32, y) * 16, 0x00, false);
            } else if (map.lvl[y][x] == 1) {
                gfx.blit(&sprites.block_spr, @intCast(i32, x) * 16, @intCast(i32, y) * 16, 0x00, false);
            }
            // else if (map.lvl[y][x] == 2) {
            // 	gfx.blit(&sprites.skull, @intCast(i32, x)*16, @intCast(i32, y)*16, 0x00, false);
            // }
            if (map.lvl[y][x] == 1 and map.lvl[y - 1][x] != 1) gfx.rect(@intCast(i32, x) * 16, @intCast(i32, y) * 16, 16, 1, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y + 1][x] != 1) gfx.rect(@intCast(i32, x) * 16, @intCast(i32, y + 1) * 16, 16, 1, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y][x - 1] != 1) gfx.rect(@intCast(i32, x) * 16, @intCast(i32, y) * 16, 1, 16, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y][x + 1] != 1) gfx.rect(@intCast(i32, x + 1) * 16, @intCast(i32, y) * 16, 1, 16, 176);
        }
    }

    turnip.tur1.draw();
}
