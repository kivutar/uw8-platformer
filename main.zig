const sprites = @import("sprites.zig");
const map = @import("map.zig");
const gfx = @import("gfx.zig");
const turnip = @import("turnip.zig");
const camera = @import("camera.zig");

extern fn cls(color: i32) void;

const Rigid = struct {
	x:      f32,
	y:      f32,
	width:  f32,
	height: f32,
	speed:  f32,
	angle:  f32,
	xspeed: f32,
	yspeed: f32,
	xaccel: f32,
	yaccel: f32,
};

export fn upd() void {
	cls(0xe8);

	turnip.tur1.update();
	camera.update();

	draw();
}

fn draw() void {
	var row_i: usize = 0;
	for (map.lvl) |row| {
		var col_i: usize = 0;
		for (row) |cell| {
			if (cell == 1) {
				gfx.blit(&sprites.block_spr, @intCast(i32, col_i)*16, @intCast(i32, row_i)*16, 0x00, false);
			}
			col_i += 1;
		}
		row_i += 1;
	}

	turnip.tur1.draw();
}