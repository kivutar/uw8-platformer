const sprites = @import("sprites.zig");
const gfx = @import("gfx.zig");
const anim = @import("anim.zig");

var turnip_run_anim = anim.Anim {
	.frames = [4][256]u8{
		sprites.turnip_spr0,
		sprites.turnip_spr1,
		sprites.turnip_spr2,
		sprites.turnip_spr1,
	},
};

var turnip_stand_anim = anim.Anim {
	.frames = [][256]u8{
		sprites.turnip_spr3,
	},
};

var turnip_jump_anim = anim.Anim {
	.frames = [][256]u8{
		sprites.turnip_spr0,
	},
};

// type turnip struct {
// 	rigid
// 	anim *Anim
// 	flip uint
// }

// func (self *turnip) ontheground() bool {
// 	return level[int((self.y+self.width)/16)][int(self.x/16)] == 0x1 || level[int((self.y+16)/16)][int((self.x+self.width-1)/16)] == 0x1
// }

// func (self *turnip) update(pad uint8) {
// 	grounded := self.ontheground()

// 	if pad&w4.BUTTON_LEFT != 0 {
// 		self.xaccel = -0.1
// 	} else if pad&w4.BUTTON_RIGHT != 0 {
// 		self.xaccel = 0.1
// 	} else {
// 		self.xaccel = 0
// 	}

// 	self.xspeed += self.xaccel
// 	self.yspeed += self.yaccel

// 	if grounded && self.yspeed >= 0 {
// 		self.y = float64(int(self.y/16)) * 16
// 		self.yspeed = 0
// 		self.yaccel = 0
// 		if pad&w4.BUTTON_1 != 0 {
// 			w4.Tone(300, 1, 100, w4.TONE_TRIANGLE)
// 			self.yspeed = -4
// 		}
// 	} else {
// 		self.yaccel = 0.2
// 	}

// 	self.xspeed = clamp(self.xspeed, -2, 2)
// 	self.yspeed = clamp(self.yspeed, -4, 4)
// 	self.x += self.xspeed
// 	self.y += self.yspeed
// 	self.xspeed = xfriction(self.xspeed, pad)

// 	if level[int((self.y)/16)][int((self.x+self.width)/16)] == 0x1 && self.xspeed > 0 {
// 		self.x = float64(int(self.x/16))*16 + 16 - self.width
// 		self.xspeed = 0
// 		self.xaccel = 0
// 	}

// 	if level[int((self.y)/16)][int((self.x)/16)] == 0x1 && self.xspeed < 0 {
// 		self.x = float64(int(self.x/16))*16 + 16
// 		self.xspeed = 0
// 		self.xaccel = 0
// 	}

// 	if self.xspeed > 0 {
// 		self.flip = w4.BLIT_FLIP_X
// 	} else if self.xspeed < 0 {
// 		self.flip = 0
// 	}

// 	if self.yspeed != 0 {
// 		self.anim = &turnip_jump_anim
// 	} else if pad&w4.BUTTON_RIGHT != 0 || pad&w4.BUTTON_LEFT != 0 {
// 		self.anim = &turnip_run_anim
// 	} else if self.xspeed == 0 {
// 		self.anim = &turnip_stand_anim
// 	}

// 	self.anim.counter++
// }

pub const Turnip = struct {
    const Self = @This();

    x:      f32,
	y:      f32,
	width:  f32,
	height: f32,
    anim:   *anim.Anim = undefined,
    flip:   bool = false,
	// speed:  f32,
	// angle:  f32,
	// xspeed: f32,
	// yspeed: f32,
	// xaccel: f32,
	// yaccel: f32,

    pub fn update(self: *Self) void {
        self.anim = &turnip_run_anim;
        self.anim.counter += 1;
    }

    pub fn draw(self: *Self) void {
        gfx.blit(&self.anim.frames[(self.anim.counter/160)%(self.anim.frames.len)][0], @floatToInt(i32, self.x), @floatToInt(i32, self.y), 0xe8, self.flip);
    }
};
