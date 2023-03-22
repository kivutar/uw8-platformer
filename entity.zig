const gfx = @import("gfx.zig");

pub const Entity = struct {
    pub const UpdateFn = *const fn (*Entity) void;
    pub const DrawFn = *const fn (*Entity) void;

    updateFn: UpdateFn,
    drawFn: DrawFn,

    pub fn update(self: *Entity) void {
        return self.updateFn(self);
    }

    pub fn draw(self: *Entity) void {
        return self.drawFn(self);
    }
};
