#!/usr/bin/env python

import logging
import coloredlogs

logger = logging.getLogger('data-extractor')
coloredlogs.install(level=logging.DEBUG)

input_file = "../data/StrongVsNormal_strings.txt"
output_file = "../data/StrongVsNormal_board.csv"

player_symbols = ["-1", "1"]
rows = 6
cols = 7

board_length = (rows * cols)

with open(input_file, "r") as ins:
    line_number = 0
    for line in ins:
        board = ["0"] * board_length
        player_index = 0
        if len(line) % 2 == 0:
            # last move should always be inactive (-1)
            player_index = -1

        for move in line[:-1]:
            position = int(move) * rows - 1
            logger.debug("line: %d, move: %s, position: %d", line_number, move, position)
            while position > cols and board[position] != '0':
                position -= cols
            board[position] = player_symbols[player_index]
            player_index = (player_index + 1) % 2
        logger.debug("player symbol: %s, board: %s", player_symbols[player_index], ",".join(board))
        line_number += 1