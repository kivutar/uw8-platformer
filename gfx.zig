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

		if (c != trans and x2 >= 0 and x2 < 320 and y2 >= 0 and y2 <= 240) {
			FRAMEBUFFER[@intCast(u32, x2+y2*320)] = c;
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
