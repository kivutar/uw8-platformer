const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const entity = @import("entity.zig");
const camera = @import("camera.zig");
const turnip = @import("turnip.zig");
const sun = @import("sun.zig");

extern fn cls(i32) void;
extern fn random() i32;
extern fn circle(f32, f32, f32, i32) void;
extern fn cos(f64) f64;
extern fn setPixel(x: i32, y: i32, color: i32) void;
extern fn randomSeed(i32) void;

var sun1 = sun.Sun.init(32, 32);
var tur1 = turnip.Turnip.init(64, 240 - 32 - 16);

var entities = [_]*entity.Entity{
    &sun1.entity,
    &tur1.entity,
};

var sky = [_]i32{0} ** 64;

var frames: f32 = 0;

export fn upd() void {
    frames += 1;
    if (frames == 1) {
        randomSeed(123);
        for (0..sky.len) |i| {
            sky[i] = random();
        }
    }

    for (entities) |e| {
        e.update();
    }

    camera.update(tur1.x + tur1.width / 2, tur1.y + tur1.height / 2);

    draw();
}

fn draw_clouds() void {
    const colors = [2]u8{ 232, 191 };

    for (0..2) |layer| {
        var flayer = @intToFloat(f32, layer);
        for (0..map.lvl.len) |y| {
            for (0..map.lvl[0].len) |x| {
                for (1..4) |s| {
                    var fs = @intToFloat(f32, s * 8);
                    if (sky[(x * y + s - layer * 100) % sky.len] > y * 16 * @sizeOf(i64)) {
                        var fx = @intToFloat(f32, x);
                        var fy = @intToFloat(f32, y);
                        if (fy * 16 > cos(fx * 16 / 40) * 40 + 240 - 100 + fs) {
                            var cosize = fs + @floatCast(f32, cos(frames / 30 + fx));
                            circle(fx * 16 - flayer * 32 - camera.x / (3 - flayer), fy * 16 + 30 * flayer, cosize, colors[layer]);
                        }
                    }
                }
            }
        }
    }
}

fn draw() void {
    cls(77);

    draw_clouds();

    for (0..map.lvl.len) |y| {
        for (0..map.lvl[0].len) |x| {
            if (map.lvl[y][x] == 1 and map.lvl[y - 1][x] != 1) {
                gfx.blit(&sprites.herb, @intCast(i32, x) * 16, @intCast(i32, y) * 16, 0x00, false);
            } else if (map.lvl[y][x] == 1) {
                gfx.blit(&sprites.block, @intCast(i32, x) * 16, @intCast(i32, y) * 16, 0x00, false);
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
