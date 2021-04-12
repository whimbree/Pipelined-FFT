import csv
import math
from typing import List
from util import get_input_order

num_points = 16


def main():
    write_input("tb_testInput_1.csv",
                generate_input(64, complex(0.00001, 0), False))


def generate_input(num_points: int, increment_amount: complex,
                   decreasing: bool) -> List[List[complex]]:
    x = []

    if decreasing:
        for i in range(num_points, 0, -1):
            x.append(increment_amount * i)
    else:
        for i in range(1, num_points + 1):
            x.append(increment_amount * i)

    return x


def write_input(filename: str, table: List[complex]):
    input_order = get_input_order(len(table))

    with open(filename, mode='w') as file:
        file_writer = csv.writer(file,
                                 delimiter=',',
                                 quotechar='"',
                                 quoting=csv.QUOTE_MINIMAL)

        for i in range(0, len(input_order[0])):
            file_writer.writerow([
                table[input_order[0][i]].real, table[input_order[0][i]].imag,
                table[input_order[1][i]].real, table[input_order[1][i]].imag,
                table[input_order[2][i]].real, table[input_order[2][i]].imag,
                table[input_order[3][i]].real, table[input_order[3][i]].imag
            ])


# get input from user or other function
# save input as csv
# run testbench
# run python checker which takes the csv and compares the outputs to the output csv.

if __name__ == '__main__':
    main()