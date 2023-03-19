const camera = @import("camera.zig");

pub const FRAMEBUFFER: *[320*240]u8 = @intToPtr(*[320*240]u8, 120);

pub const Anim = struct {
	frames:  []const [256]u8,
	counter: u8 = 0,
};

pub fn blit(spr: *const [256]u8, dx: i32, dy: i32, trans: u8, flip: bool) void {
	var x: u32 = 0;
	var y: u32 = 0;
	var x2: i32 = dx;
	var y2: i32 = dy;

	while (true) {
		var c = if (flip) spr[15-x+y*16] else spr[x+y*16];
		var o_x = x2 - @floatToInt(i32, camera.x);
		var o_y = y2 - @floatToInt(i32, camera.y);

		if (c != trans and o_x >= 0 and o_x < 320 and o_y >= 0 and o_y <= 240) {
			FRAMEBUFFER[@intCast(u32, o_x+o_y*320)] = c;
		}

		x += 1;
		x2 += 1;

		if (x >= 16) {
			x = 0;
			x2 = dx;
			y += 1;
			y2 += 1;
		}
		if (y >= 16) { break; }
	}
}
