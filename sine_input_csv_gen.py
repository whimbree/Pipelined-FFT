import csv
import math
from typing import List
from util import get_input_order, get_output_order, format_fixed_point_hex
import numpy as np
import re
import os


def main():

    fft_core_to_use = int(input("Which FFT core to run on (0 or 1)?: "))

    tb_input = "tb_input1.csv" if fft_core_to_use else "tb_input0.csv"
    tb_expectedOutput = (
        "tb_expectedOutput1.csv" if fft_core_to_use else "tb_expectedOutput0.csv"
    )
    tb_testOutput = "tb_testOutput1.csv" if fft_core_to_use else "tb_testOutput0.csv"

    if os.path.exists(tb_input):
        os.remove(tb_input)
    if os.path.exists(tb_expectedOutput):
        os.remove(tb_expectedOutput)
    if os.path.exists(tb_testOutput):
        os.remove(tb_testOutput)

    num_points = int(input("How many points is the FFT?: "))
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(num_points, 4)):
        print("num_points must be a power of 4")
        return

    num_ffts = int(input("How many FFTs to run?: "))

    for i in range(0, num_ffts):
        input_data = generate_input_sine(num_points)
        fft = np.fft.fft(input_data)
        with np.printoptions(threshold=np.inf):
            print(fft)
        write_input(tb_input, input_data)
        write_expected_output(tb_expectedOutput, fft)


def generate_input_sine(
    num_points: int,
) -> np.array:
    x = [complex(0, 0) for i in range(num_points)]

    num_freqs = int(input("How many frequencies to add?: "))
    for i in range(num_freqs):
        do_imag_wave = int(input("Should sine wave be imaginary (0-NO, 1-YES): "))
        y = []
        freq = float(input("What is the period for component " + str(i + 1) + "?: "))
        amp = float(input("What is the amplitude for component " + str(i + 1) + "?: "))
        for j in range(num_points):
            val = float(amp * math.sin(freq * 2 * math.pi * float(j / num_points)))
            y.append((complex(0, val) if do_imag_wave else complex(val, 0)) + x[j])
        x = y
        # print(x)

    return np.asarray(x)


def write_input(filename: str, table: np.array):
    input_data = reorder_input(table)

    with open(filename, mode="a", newline="") as file:
        file_writer = csv.writer(
            file, delimiter=",", quotechar='"', quoting=csv.QUOTE_MINIMAL
        )

        for i in range(0, len(input_data[0])):
            file_writer.writerow(
                [
                    format_fixed_point_hex(i)
                    for i in [
                        input_data[0][i].real,
                        input_data[0][i].imag,
                        input_data[1][i].real,
                        input_data[1][i].imag,
                        input_data[2][i].real,
                        input_data[2][i].imag,
                        input_data[3][i].real,
                        input_data[3][i].imag,
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

    with open(filename, mode="a", newline="") as file:
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
