const std = @import("std");
const Players = enum {
    player1,
    player2,
};
const GameState = struct {
    gaming: bool,
    turn: Players,
    gameArray: [9]u8,
    fn name(self: *GameState) []const u8 {
        switch (self.turn) {
            Players.player1 => return "Player 1",
            Players.player2 => return "Player 2",
        }
    }
};

var buffer: [10]u8 = undefined;

pub fn main() !void {
    var game = GameState{ .gaming = true, .gameArray = [_]u8{
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
        ' ',
    }, .turn = Players.player1 };
    const stdin = std.io.getStdIn();
    const reader = stdin.reader();

    while (game.gaming) {
        std.debug.print(" {c} | {c} | {c} \n" ++
            "-----------\n" ++
            " {c} | {c} | {c} \n" ++
            "-----------\n" ++
            " {c} | {c} | {c} \n", .{ game.gameArray[0], game.gameArray[1], game.gameArray[2], game.gameArray[3], game.gameArray[4], game.gameArray[5], game.gameArray[6], game.gameArray[7], game.gameArray[8] });
        checkDraw(&game);
        if (!game.gaming) break;
        std.debug.print("What is your turn {s}? (Enter position 1-9)\n", .{game.name()});
        const read_input = try reader.readUntilDelimiterOrEof(&buffer, '\n');
        if (read_input == null or read_input.?.len > 1 or read_input.?.len == 0) {
            std.debug.print("Invalid position. Please enter a number from 1 to 9.\n", .{});
            continue;
        }

        if (read_input) |user_input| {
            const position = user_input[0] - '0'; // convert from ASCII

            // Ensure position is within bounds of gameArray
            if (position < 1 or position > game.gameArray.len) {
                std.debug.print("Invalid position. Please enter a number from 1 to 9.\n", .{});
                continue;
            }
            switch (game.turn) {
                Players.player1 => game.gameArray[position - 1] = 'X',
                Players.player2 => game.gameArray[position - 1] = 'O',
            }
            if (game.turn == Players.player1) {
                game.turn = Players.player2;
            } else {
                game.turn = Players.player1;
            }
        } else {
            std.debug.print("No input detected.\n", .{});
        }
    }
}
fn checkDraw(arr: *GameState) void {
    //If all fields are filled
    var all_filled = true;
    for (arr.gameArray) |state| {
        if (state == ' ') {
            all_filled = false;
            break;
        }
    }

    if (all_filled) {
        std.debug.print("The game is a draw!\n", .{});
        // Optionally, end the game here
        arr.gaming = false;
    }
}
