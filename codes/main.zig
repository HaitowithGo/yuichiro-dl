const std = @import("std");
const time = std.time;
const io = std.io;
const os = std.os;

pub fn main() !void {
    const stdin = io.getStdIn().reader();
    const stdout = io.getStdOut().writer();

    var esc_count: u8 = 0;
    var last_key_time = time.milliTimestamp();

    try stdout.print("ESCキーを8回押してください\n", .{});

    while (true) {
        const key = stdin.readByte() catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        if (key == 27) {  // ESCキーのASCIIコード
            esc_count += 1;
            last_key_time = time.milliTimestamp();
            try stdout.print("ESCキーが押されました。カウント: {}\n", .{esc_count});

            if (esc_count == 8) {
                try stdout.print("ESCキーが8回押されました\n", .{});
                try stdout.print("3秒間何も押さないでください\n", .{});
                time.sleep(3 * time.ns_per_s);
                try stdout.print("3秒間経過しました\n", .{});
                try stdout.print("プログラムは10分間停止します\n", .{});
                time.sleep(600 * time.ns_per_s);
                break;
            }
        } else {
            esc_count = 0;
        }

        if (time.milliTimestamp() - last_key_time > 3000) {
            try stdout.print("3秒間キー入力がありませんでした\n", .{});
            last_key_time = time.milliTimestamp();
        }

        time.sleep(100 * time.ns_per_ms);
    }
}