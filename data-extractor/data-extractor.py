#!/usr/bin/env python

import logging
import coloredlogs

logger = logging.getLogger('data-extractor')
coloredlogs.install(level=logging.INFO)

input_file_name = "../data/StrongVsNormal_strings.txt"
output_file_name = "../data/StrongVsNormal_board.csv"

player_symbols = ["-1", "1"]
rows = 6
cols = 7

board_length = (rows * cols)


def print_board(board):
    for row in range(0, rows):
        logger.debug(" ".join(board[row*cols:(row+1)*cols]))

with open(input_file_name, "r") as input_file, open(output_file_name, 'w') as output_file:
    line_number = 0
    for line in input_file:
        board = ["0"] * board_length
        player_index = 0
        if len(line) % 2 == 0:
            # last move should always be inactive (-1)
            player_index = -1

        for index, move in enumerate(line[:-1]):
            position = board_length - 1 - cols + int(move)
            logger.debug("line: %d, move: %s, position: %d", line_number, move, position)
            while position > cols and board[position] != '0':
                position -= cols
            board[position] = player_symbols[player_index]
            player_index = (player_index + 1) % 2
            output_file.write(",".join(board) + "," + line[index+1] + "\n")
            print_board(board)
        logger.info("player symbol: %s, board: %s", player_symbols[player_index], ",".join(board))
        line_number += 1