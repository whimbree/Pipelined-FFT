import math
from typing import List


def get_input_order(num_points: int) -> List[List[int]]:
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(num_points, 4)):
        print("get_input_order: num_points must be a power of 4")
        return

    initial = 0
    b_n_minus_1 = 1 << int(math.log(num_points, 2) - 1)
    b_n_minus_2 = 1 << int(math.log(num_points, 2) - 2)
    num_iterations = num_points >> 2

    table = []

    table.append([i for i in range(0, num_iterations)])
    table.append([b_n_minus_1 + i for i in range(0, num_iterations)])
    table.append([b_n_minus_2 + i for i in range(0, num_iterations)])
    table.append([b_n_minus_1 + b_n_minus_2 + i for i in range(0, num_iterations)])

    return table


def get_output_order(num_points: int) -> List[List[int]]:
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(num_points, 4)):
        print("get_output_order: num_points must be a power of 4")
        return

    initial = 0

    num_iterations = num_points >> 2

    table = []

    table.append([i for i in range(0, num_points, 4)])
    table.append([i for i in range(1, num_points, 4)])
    table.append([i for i in range(2, num_points, 4)])
    table.append([i for i in range(3, num_points, 4)])

    width = int(math.log(num_points, 2))

    # this k-index table is related to the above table in that each "equivalent" value is the bit-reversed version of the other
    # 0001 -> 1000
    # 0010 -> 0100
    width = int(math.log(num_points, 2))

    for i, row in enumerate(table):
        table[i] = [reverse_bits(j, width) for j in row]

    return table


def reverse_bits(input: int, width: int):
    b = "{:0{width}b}".format(input, width=width)
    return int(b[::-1], 2)


def format_float_scientific(input: float) -> str:
    pattern = "e(-|\+)\d+"
    regex = re.compile(pattern)

    s = np.format_float_scientific(input)
    m = regex.search(s)
    return s[: m.start()].ljust(3, "0") + s[m.start() :]


def format_fixed_point_hex(input: float) -> str:
    # MSB is sign bit
    # rest is fixed point decimal
    # maximum input range of this function is (1.0, -1.0]

    epsilon = 0.0001
    data_width = 32

    scaled = input * 2 ** (data_width - 1)
    # https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
    scaled = int(scaled) & (2 ** data_width - 1)
    if abs(input - 1.0) < epsilon:
        scaled -= 1
    return "{0:0{1}X}".format(scaled, 8)


def fixed_point_hex_to_float(input: str) -> float:
    data_width = 32

    scaled = int(input, 16)
    # get into 2s complement format if negative
    if scaled & (1 << (data_width - 1)):
        scaled -= 1 << data_width
    scaled = float(scaled)
    scaled = scaled / (2 ** (data_width - 1))
    return scaled
