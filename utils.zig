const input = @import("input.zig");

pub fn xfriction(pad: u8, v: f32) f32 {
    var v2 = v;
    if (v2 < 0 and input.isButtonPressed(pad, 2) == 0) {
        v2 += 0.1;
        if (v2 > 0) {
            v2 = 0;
        }
    } else if (v2 > 0 and input.isButtonPressed(pad, 3) == 0) {
        v2 -= 0.1;
        if (v2 < 0) {
            v2 = 0;
        }
    }
    return v2;
}

pub fn clamp(v: f32, min: f32, max: f32) f32 {
    if (v < min) {
        return min;
    }
    if (v > max) {
        return max;
    }
    return v;
}
