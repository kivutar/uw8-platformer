const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const assets = b.addSystemCommand(&[_][]const u8{
        "sh", "-c", "rm sprites.zig && go run png2src.go assets/*.png >> sprites.zig",
    });

    const lib = b.addSharedLibrary(.{
        .name = "cart",
        .root_source_file = .{ .path = "main.zig" },
        .target = .{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        },
        .optimize = std.builtin.Mode.ReleaseSmall,
    });
    lib.rdynamic = true;
    lib.import_memory = true;
    lib.initial_memory = 262144;
    lib.max_memory = 262144;
    lib.global_base = 81920;
    lib.stack_size = 8192;
    lib.step.dependOn(&assets.step);

    b.installArtifact(lib);

    const run_filter_exports = b.addSystemCommand(&[_][]const u8{ "uw8", "filter-exports", "zig-out/lib/cart.wasm", "zig-out/lib/cart-filtered.wasm" });

    const run_wasm_opt = b.addSystemCommand(&[_][]const u8{ "wasm-opt", "-Oz", "-o", "zig-out/cart.wasm", "zig-out/lib/cart-filtered.wasm" });
    run_wasm_opt.step.dependOn(&run_filter_exports.step);

    const run_uw8_pack = b.addSystemCommand(&[_][]const u8{ "uw8", "pack", "-l", "9", "zig-out/cart.wasm", "zig-out/cart.uw8" });
    run_uw8_pack.step.dependOn(&run_wasm_opt.step);

    const make_opt = b.step("make_opt", "make size optimized cart");
    make_opt.dependOn(&run_uw8_pack.step);

    b.default_step = make_opt;
}
