const PADS: *[4]u8 = @intToPtr(*[4]u8, 0x00044);
var OLD_PADS: [4]u8 = undefined;

pub fn isButtonPressed(pad: u8, btn: u3) i32 {
    return PADS[pad] & (@as(u8, 1) << btn);
}

pub fn isButtonTriggered(pad: u8, btn: u3) i32 {
    return @boolToInt((PADS[pad] & (@as(u8, 1) << btn)) != 0 and (OLD_PADS[pad] & (@as(u8, 1) << btn)) == 0);
}

pub fn update() void {
    OLD_PADS = PADS.*;
}
