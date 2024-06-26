const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libtraceevent = b.dependency("libtraceevent", .{
        .target = target,
        .optimize = optimize,
    });
    const libtracefs = b.dependency("libtracefs", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "rtla",
        .target = target,
        .optimize = optimize,
    });
    const cflags = [_][]const u8{
        "-DVERSION=\"6.9\"",
        "-D_GNU_SOURCE",
    };
    exe.linkLibC();
    exe.addCSourceFiles(.{
        .files = &.{
            "src/trace.c",
            "src/utils.c",
            "src/osnoise.c",
            "src/osnoise_top.c",
            "src/osnoise_hist.c",
            "src/timerlat.c",
            "src/timerlat_top.c",
            "src/timerlat_hist.c",
            "src/timerlat_u.c",
            "src/timerlat_aa.c",
            "src/rtla.c",
        },
        .flags = &cflags,
    });
    exe.linkLibrary(libtraceevent.artifact("traceevent"));
    exe.linkLibrary(libtracefs.artifact("tracefs"));

    b.installArtifact(exe);
}
