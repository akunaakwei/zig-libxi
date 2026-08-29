const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const linkage = b.option(std.builtin.LinkMode, "linkage", "Linkage type for the library") orelse .static;

    const xi_dep = b.dependency("xi", .{});
    const x11_dep = b.dependency("x11", .{
        .target = target,
        .optimize = optimize,
        .linkage = linkage,
    });
    const x11 = x11_dep.artifact("x11");
    const xorgproto_dep = b.dependency("xorgproto", .{
        .target = target,
        .optimize = optimize,
    });
    const xorgproto = xorgproto_dep.artifact("xorgproto");
    const xext_dep = b.dependency("xext", .{
        .target = target,
        .optimize = optimize,
        .linkage = linkage,
    });
    const xext = xext_dep.artifact("xext");
    const xfixes_dep = b.dependency("xfixes", .{
        .target = target,
        .optimize = optimize,
        .linkage = linkage,
    });
    const xfixes = xfixes_dep.artifact("xfixes");

    const mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .pic = if (linkage == .dynamic) true else null,
    });
    mod.linkLibrary(x11);
    mod.linkLibrary(xorgproto);
    mod.linkLibrary(xext);
    mod.linkLibrary(xfixes);
    mod.addIncludePath(xi_dep.path("include"));
    mod.addCSourceFiles(.{
        .root = xi_dep.path("src"),
        .files = &sources,
    });

    const lib = b.addLibrary(.{
        .name = "xi",
        .root_module = mod,
        .linkage = linkage,
    });
    lib.installHeadersDirectory(xi_dep.path("include"), ".", .{});
    b.installArtifact(lib);
}

const sources = .{
    "XAllowDv.c",
    "XChDProp.c",
    "XChgDCtl.c",
    "XChgFCtl.c",
    "XChgKbd.c",
    "XChgKMap.c",
    "XChgPnt.c",
    "XChgProp.c",
    "XCloseDev.c",
    "XDelDProp.c",
    "XDevBell.c",
    "XExtToWire.c",
    "XGetBMap.c",
    "XGetCPtr.c",
    "XGetDCtl.c",
    "XGetDProp.c",
    "XGetFCtl.c",
    "XGetKMap.c",
    "XGetMMap.c",
    "XGetProp.c",
    "XGetVers.c",
    "XGMotion.c",
    "XGrabDev.c",
    "XGrDvBut.c",
    "XGrDvKey.c",
    "XGtFocus.c",
    "XGtSelect.c",
    "XListDev.c",
    "XListDProp.c",
    "XOpenDev.c",
    "XQueryDv.c",
    "XSelect.c",
    "XSetBMap.c",
    "XSetDVal.c",
    "XSetMMap.c",
    "XSetMode.c",
    "XSndExEv.c",
    "XStFocus.c",
    "XUngrDev.c",
    "XUngrDvB.c",
    "XUngrDvK.c",
    "XExtInt.c",
    "XIAllowEvents.c",
    "XIGrabDevice.c",
    "XIQueryVersion.c",
    "XIQueryDevice.c",
    "XISetDevFocus.c",
    "XIGetDevFocus.c",
    "XIPassiveGrab.c",
    "XIProperties.c",
    "XISelEv.c",
    "XISetCPtr.c",
    "XIWarpPointer.c",
    "XIHierarchy.c",
    "XIDefineCursor.c",
    "XIQueryPointer.c",
    "XIBarrier.c",
};
