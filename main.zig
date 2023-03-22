const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const entity = @import("entity.zig");
const camera = @import("camera.zig");
const turnip = @import("turnip.zig");
const sun = @import("sun.zig");

extern fn cls(color: i32) void;

var sun1 = sun.Sun.init(32, 32);
var tur1 = turnip.Turnip.init(32, 32);

var entities = [_]*entity.Entity{
    &sun1.entity,
    &tur1.entity,
};

export fn upd() void {
    cls(44);

    for (entities) |e| {
        e.update();
    }

    camera.update(tur1.x + tur1.width / 2, tur1.y + tur1.height / 2);

    draw();
}

fn draw() void {
    for (0..map.lvl.len) |y| {
        for (0..map.lvl[0].len) |x| {
            if (map.lvl[y][x] == 1 and map.lvl[y - 1][x] != 1) {
                gfx.blit(&sprites.herb, @intCast(i32, x) * 16, @intCast(i32, y) * 16, 0x00, false);
            } else if (map.lvl[y][x] == 1) {
                gfx.blit(&sprites.block_spr, @intCast(i32, x) * 16, @intCast(i32, y) * 16, 0x00, false);
            } else if (map.lvl[y][x] == 2) {
                gfx.blit(&sprites.skull, @intCast(i32, x) * 16, @intCast(i32, y) * 16, 0xe8, false);
            }
            if (map.lvl[y][x] == 1 and map.lvl[y - 1][x] != 1) gfx.rect(@intCast(i32, x) * 16, @intCast(i32, y) * 16, 16, 1, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y + 1][x] != 1) gfx.rect(@intCast(i32, x) * 16, @intCast(i32, y + 1) * 16, 16, 1, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y][x - 1] != 1) gfx.rect(@intCast(i32, x) * 16, @intCast(i32, y) * 16, 1, 16, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y][x + 1] != 1) gfx.rect(@intCast(i32, x + 1) * 16, @intCast(i32, y) * 16, 1, 16, 176);
        }
    }

    for (entities) |e| {
        e.draw();
    }
}
