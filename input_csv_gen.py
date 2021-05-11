import csv
import math
from typing import List
from util import get_input_order, get_output_order, format_fixed_point_hex
import numpy as np
import re


def main():
    input = generate_input(1024, complex(0, 0), complex(0.0000001, 0), False)
    fft = np.fft.fft(input)
    with np.printoptions(threshold=np.inf):
        print(fft)
    write_input("tb_input.csv", input)
    write_expected_output("tb_expectedOutput.csv", fft)


def generate_input(
    num_points: int,
    initial_amount: complex,
    increment_amount: complex,
    decreasing: bool,
) -> np.array:
    x = []

    if decreasing:
        for i in range(num_points, 0, -1):
            x.append(initial_amount + increment_amount * i)
    else:
        for i in range(1, num_points + 1):
            x.append(initial_amount + increment_amount * i)

    return np.asarray(x)


def write_input(filename: str, table: np.array):
    input = reorder_input(table)

    with open(filename, mode="w", newline="") as file:
        file_writer = csv.writer(
            file, delimiter=",", quotechar='"', quoting=csv.QUOTE_MINIMAL
        )

        for i in range(0, len(input[0])):
            file_writer.writerow(
                [
                    format_fixed_point_hex(i)
                    for i in [
                        input[0][i].real,
                        input[0][i].imag,
                        input[1][i].real,
                        input[1][i].imag,
                        input[2][i].real,
                        input[2][i].imag,
                        input[3][i].real,
                        input[3][i].imag,
                    ]
                ]
            )


def reorder_input(table: np.array) -> np.array:
    input_order = get_input_order(len(table))

    return np.asarray(
        [[table[i] for i in input_order[j]] for j in range(len(input_order))]
    )


def write_expected_output(filename: str, table: np.array):
    output = reorder_output(table)

    with open(filename, mode="w", newline="") as file:
        file_writer = csv.writer(
            file, delimiter=",", quotechar='"', quoting=csv.QUOTE_MINIMAL
        )

        for i in range(0, len(output[0])):
            file_writer.writerow(
                [
                    format_fixed_point_hex(i)
                    for i in [
                        output[0][i].real,
                        output[0][i].imag,
                        output[1][i].real,
                        output[1][i].imag,
                        output[2][i].real,
                        output[2][i].imag,
                        output[3][i].real,
                        output[3][i].imag,
                    ]
                ]
            )


def reorder_output(table: np.array) -> np.array:
    output_order = get_output_order(len(table))

    return np.asarray(
        [[table[i] for i in output_order[j]] for j in range(len(output_order))]
    )


if __name__ == "__main__":
    main()
