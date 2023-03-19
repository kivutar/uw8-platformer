const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const utils = @import("utils.zig");

const JUMP_FORGIVENESS = 4;

var turnip_run_anim = gfx.Anim {
	.frames = &[_][256]u8{
		sprites.turnip_spr0,
		sprites.turnip_spr1,
		sprites.turnip_spr2,
		sprites.turnip_spr1,
	},
};

var turnip_stand_anim = gfx.Anim {
	.frames = &[_][256]u8{
		sprites.turnip_spr3,
	},
};

var turnip_jump_anim = gfx.Anim {
	.frames = &[_][256]u8{
		sprites.turnip_spr0,
	},
};

extern fn isButtonPressed(btn: i32) i32;
extern fn isButtonTriggered(btn: i32) i32;
extern fn playNote(channel: i32, note: i32) void;

fn lvl_at(x: f32, y: f32) i32 {
    return map.lvl[@floatToInt(usize, y)][@floatToInt(usize, x)];
}

pub const Turnip = struct {
    const Self = @This();

    x:    f32,
	y:    f32,
	width:  f32,
	height: f32,
    anim:   *gfx.Anim = undefined,
    flip:   bool = false,
	xspeed: f32 = 0,
	yspeed: f32 = 0,
	xaccel: f32 = 0,
	yaccel: f32 = 0,
    ungrounded_frames: u8 = 0,

    fn ontheground(self: *Self) bool {
        return lvl_at(self.x/16, (self.y+self.height)/16) == 1 or lvl_at((self.x+self.width-1)/16, (self.y+self.height)/16) == 1;
    }

    pub fn update(self: *Self) void {
        var grounded = self.ontheground();
        if (!grounded) self.ungrounded_frames += 1 else self.ungrounded_frames = 0;

        if (isButtonPressed(2) != 0) {
            self.xaccel = -0.1;
        } else if (isButtonPressed(3) != 0) {
            self.xaccel = 0.1;
        } else {
            self.xaccel = 0;
        }

        self.xspeed += self.xaccel;
        self.yspeed += self.yaccel;

        if (grounded and self.yspeed >= 0) {
            self.y = @intToFloat(f32, (@floatToInt(i32, self.y/16)) * 16);
            self.yspeed = 0;
            self.yaccel = 0;
        } else {
            self.yaccel = 0.2;
        }

        if (isButtonTriggered(4) != 0 and self.ungrounded_frames <= JUMP_FORGIVENESS) {
            playNote(300, 0);
            self.yspeed = -4;
        }

        self.xspeed = utils.clamp(self.xspeed, -2, 2);
        self.yspeed = utils.clamp(self.yspeed, -4, 4);
        self.x += self.xspeed;
        self.y += self.yspeed;
        self.xspeed = utils.xfriction(self.xspeed);

        if (lvl_at((self.x+self.width)/16, (self.y+self.height-4)/16) == 1 and self.xspeed > 0) {
            self.x = @floor(self.x/16)*16 + 16 - self.width;
            self.xspeed = 0;
            self.xaccel = 0;
        }

        if (lvl_at((self.x)/16, (self.y+self.height-4)/16) == 1 and self.xspeed < 0) {
            self.x = @floor(self.x/16)*16 + 16;
            self.xspeed = 0;
            self.xaccel = 0;
        }

        self.x = utils.clamp(self.x, 0, @intToFloat(f32, map.lvl[0].len*16) - self.width);

        if (self.xspeed > 0) {
            self.flip = true;
        } else if (self.xspeed < 0) {
            self.flip = false;
        }

        if (self.yspeed != 0) {
            self.anim = &turnip_jump_anim;
        } else if (isButtonPressed(2) != 0 or isButtonPressed(3) != 0) {
            self.anim = &turnip_run_anim;
        } else if (self.xspeed == 0) {
            self.anim = &turnip_stand_anim;
        }

        self.anim.counter += 1;
    }

    pub fn draw(self: *Self) void {
        gfx.blit(&(self.anim.frames[(self.anim.counter/8)%self.anim.frames.len]), @floatToInt(i32, self.x)-2, @floatToInt(i32, self.y), 0xe8, self.flip);
    }
};

pub var tur1  = Turnip{
	.x = 32,
	.y = 32,
	.width = 12,
	.height = 16,
};
