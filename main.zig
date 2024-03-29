const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const entity = @import("entity.zig");
const input = @import("input.zig");
const camera = @import("camera.zig");
const turnip = @import("turnip.zig");
// const sun = @import("sun.zig");

extern fn cls(i32) void;
extern fn random() i32;
extern fn circle(f32, f32, f32, i32) void;
extern fn cos(f64) f64;
extern fn randomSeed(i32) void;

// var sun1 = sun.Sun.init(32, 32);
var tur1 = turnip.Turnip.init(64, 240 - 32 - 16, 0);
var tur2 = turnip.Turnip.init(64 + 16, 240 - 32 - 16, 1);

var entities = [_]*entity.Entity{
    // &sun1.entity,
    &tur1.entity,
    &tur2.entity,
};

var sky = [_]i32{0} ** 64;

var waterfall_anim = gfx.Anim{
    .frames = &[_][256]u8{
        sprites.waterfall1,
        sprites.waterfall2,
        sprites.waterfall3,
        sprites.waterfall4,
    },
};

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

    waterfall_anim.counter += 1;

    camera.update(tur1.x + tur1.width / 2, tur1.y + tur1.height / 2);

    draw();

    input.update();
}

fn draw_clouds() void {
    const colors = [2]u8{ 232, 191 };

    for (0..2) |layer| {
        var flayer: f32 = @floatFromInt(layer);
        for (0..map.lvl.len) |y| {
            for (0..map.lvl[0].len) |x| {
                var fx = @as(f32, @floatFromInt(x)) * 16;
                var fy = @as(f32, @floatFromInt(y)) * 16;
                for (1..4) |s| {
                    var fs: f32 = @floatFromInt(s * 8);
                    if (sky[(x * y + s - layer * 100) % sky.len] > y * 16 * @sizeOf(i64)) {
                        if (fy > cos(fx / 40) * 40 + 240 - 100 + fs) {
                            var cosize = fs + @as(f32, @floatCast(cos(frames / 30 + fx)));
                            var xx = fx - flayer * 32 - camera.x / (3 - flayer);
                            if (xx + 16 < 0 or xx - 16 > 320) continue;
                            circle(xx, fy + 30 * flayer, cosize, colors[layer]);
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
            const tx = @as(i32, @intCast(x)) * 16;
            const ty = @as(i32, @intCast(y)) * 16;
            if (tx + 16 < camera.xi or tx > camera.xi + 320) continue;

            if (map.lvl[y][x] == 1 and map.lvl[y - 1][x] != 1) {
                gfx.blit(&sprites.herb, 16, tx - camera.xi, ty - camera.yi, 0);
            } else if (map.lvl[y][x] == 1) {
                gfx.blit(&sprites.block, 16, tx - camera.xi, ty - camera.yi, 0);
            } else if (map.lvl[y][x] == 2) {
                gfx.blit(&sprites.skull, 16, tx - camera.xi, ty - camera.yi, 0);
            } else if (map.lvl[y][x] == 3) {
                gfx.blit(&waterfall_anim.frames[waterfall_anim.counter / 8 % waterfall_anim.frames.len], 16, tx - camera.xi, ty - camera.yi, 0);
            }
            if (map.lvl[y][x] == 1 and map.lvl[y - 1][x] != 1) gfx.rectangle(@as(f32, @floatFromInt(tx - camera.xi)), @as(f32, @floatFromInt(ty - camera.yi)), 16, 1, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y + 1][x] != 1) gfx.rectangle(@as(f32, @floatFromInt(tx - camera.xi)), @as(f32, @floatFromInt(ty - camera.yi + 15)), 16, 1, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y][x - 1] != 1) gfx.rectangle(@as(f32, @floatFromInt(tx - camera.xi)), @as(f32, @floatFromInt(ty - camera.yi)), 1, 16, 176);
            if (map.lvl[y][x] == 1 and map.lvl[y][x + 1] != 1) gfx.rectangle(@as(f32, @floatFromInt(tx - camera.xi + 15)), @as(f32, @floatFromInt(ty - camera.yi)), 1, 16, 176);
        }
    }

    for (entities) |e| {
        e.draw();
    }
}
