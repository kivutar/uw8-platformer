const gfx = @import("gfx.zig");

pub const Entity = struct {
    updateFn: *const fn (*Entity) void,
    drawFn: *const fn (*Entity) void,

    pub fn update(self: *Entity) void {
        return self.updateFn(self);
    }

    pub fn draw(self: *Entity) void {
        return self.drawFn(self);
    }
};
