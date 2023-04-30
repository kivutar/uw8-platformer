const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const utils = @import("utils.zig");
const entity = @import("entity.zig");
const camera = @import("camera.zig");
const input = @import("input.zig");

const JUMP_FORGIVENESS = 4;

var turnip_run_anim = gfx.Anim{
    .frames = &[_][256]u8{
        sprites.turnip_spr0,
        sprites.turnip_spr1,
        sprites.turnip_spr2,
        sprites.turnip_spr1,
    },
};

var turnip_stand_anim = gfx.Anim{
    .frames = &[_][256]u8{
        sprites.turnip_spr3,
    },
};

var turnip_jump_anim = gfx.Anim{
    .frames = &[_][256]u8{
        sprites.turnip_spr0,
    },
};

extern fn playNote(channel: i32, note: i32) void;

fn solid_at(x: f32, y: f32) bool {
    var tile = map.at(x, y);
    return tile == 1 or tile == 2;
}

pub const Turnip = struct {
    entity: entity.Entity,

    x: f32,
    y: f32,
    width: f32 = 12,
    height: f32 = 16,
    anim: *gfx.Anim = undefined,
    flip: bool = true,
    xspeed: f32 = 0,
    yspeed: f32 = 0,
    xaccel: f32 = 0,
    yaccel: f32 = 0,
    ungrounded_frames: u8 = 0,
    jumping_frames: u8 = 0,
    pad: u8 = 0,

    pub fn init(x: f32, y: f32, pad: u8) Turnip {
        return .{
            .x = x,
            .y = y,
            .pad = pad,
            .entity = entity.Entity{
                .updateFn = @ptrCast(entity.Entity.UpdateFn, &update),
                .drawFn = @ptrCast(entity.Entity.DrawFn, &draw),
            },
        };
    }

    fn ontheground(self: *Turnip) bool {
        return solid_at(self.x / 16, (self.y + self.height) / 16) or solid_at((self.x + self.width - 1) / 16, (self.y + self.height) / 16);
    }

    pub fn update(self: *Turnip) void {
        var grounded = self.ontheground();
        if (!grounded) self.ungrounded_frames += 1 else self.ungrounded_frames = 0;

        if (input.isButtonPressed(self.pad, 2) != 0) {
            self.xaccel = -0.1;
        } else if (input.isButtonPressed(self.pad, 3) != 0) {
            self.xaccel = 0.1;
        } else {
            self.xaccel = 0;
        }

        self.xspeed += self.xaccel;
        self.yspeed += self.yaccel;

        if (grounded and self.yspeed >= 0) {
            self.y = @intToFloat(f32, (@floatToInt(i32, self.y / 16)) * 16);
            self.yspeed = 0;
            self.yaccel = 0;
        } else {
            self.yaccel = 0.2;
        }

        if (input.isButtonTriggered(self.pad, 4) != 0 and self.ungrounded_frames <= JUMP_FORGIVENESS) {
            self.yspeed = -4;
            playNote(3, 60);
        } else {
            playNote(3, 0);
        }

        if (input.isButtonPressed(self.pad, 4) != 0 and self.yspeed < 0) self.jumping_frames += 1 else self.jumping_frames = 0;
        if (self.jumping_frames > 1 and self.jumping_frames < 40)
            self.yspeed -= 0.05;

        self.xspeed = utils.clamp(self.xspeed, -2, 2);
        self.yspeed = utils.clamp(self.yspeed, -4, 4);
        self.x += self.xspeed;
        self.y += self.yspeed;
        self.xspeed = utils.xfriction(self.pad, self.xspeed);

        if (solid_at((self.x + self.width) / 16, (self.y + self.height - 4) / 16) and self.xspeed > 0) {
            self.x = @floor(self.x / 16) * 16 + 16 - self.width;
            self.xspeed = 0;
            self.xaccel = 0;
        }

        if (solid_at(self.x / 16, (self.y + self.height - 4) / 16) and self.xspeed < 0) {
            self.x = @floor(self.x / 16) * 16 + 16;
            self.xspeed = 0;
            self.xaccel = 0;
        }

        if ((solid_at(self.x / 16, self.y / 16) or solid_at((self.x + self.width - 1) / 16, self.y / 16)) and self.yspeed < 0) {
            self.y = @floor(self.y / 16) * 16 + self.height;
            self.yspeed = 0;
        }

        self.x = utils.clamp(self.x, 0, @intToFloat(f32, map.lvl[0].len * 16) - self.width);

        if (self.xspeed > 0) {
            self.flip = true;
        } else if (self.xspeed < 0) {
            self.flip = false;
        }

        if (self.yspeed != 0) {
            self.anim = &turnip_jump_anim;
        } else if (input.isButtonPressed(self.pad, 2) != 0 or input.isButtonPressed(self.pad, 3) != 0) {
            self.anim = &turnip_run_anim;
        } else if (self.xspeed == 0) {
            self.anim = &turnip_stand_anim;
        }

        self.anim.counter += 1;
    }

    pub fn draw(self: *Turnip) void {
        var ctrl: i32 = 0xe8 | (1 << 8);
        ctrl |= if (self.flip) 1 << 9 else 0;
        gfx.blit(&self.anim.frames[(self.anim.counter / 6) % self.anim.frames.len], 16, @floatToInt(i32, self.x) - 2 - camera.xi, @floatToInt(i32, self.y) - camera.yi, ctrl);
    }
};
