const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const utils = @import("utils.zig");
const entity = @import("entity.zig");
const camera = @import("camera.zig");

pub const Sun = struct {
    entity: entity.Entity,

    x: f32,
    y: f32,
    width: f32 = 16,
    height: f32 = 16,

    pub fn init(x: f32, y: f32) Sun {
        return .{
            .x = x,
            .y = y,
            .entity = entity.Entity{
                .updateFn = @ptrCast(entity.Entity.UpdateFn, &update),
                .drawFn = @ptrCast(entity.Entity.DrawFn, &draw),
            },
        };
    }

    pub fn update(self: *Sun) void {
        self.x += 0.01;
    }

    pub fn draw(self: *Sun) void {
        gfx.blit(&sprites.skull, 16, @floatToInt(i32, self.x) - camera.xi, @floatToInt(i32, self.y) - camera.yi, 0xe8 | (1 << 8));
    }
};
