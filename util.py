import math
from typing import List
from copy import deepcopy


def get_input_order(num_points: int) -> List[List[int]]:
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(
            num_points, 4)):
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
    table.append(
        [b_n_minus_1 + b_n_minus_2 + i for i in range(0, num_iterations)])

    return table


def get_output_order(num_points: int) -> List[List[int]]:
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(
            num_points, 4)):
        print("get_output_order: num_points must be a power of 4")
        return

    initial = 0

    num_iterations = num_points >> 2

    table = []

    table.append([i for i in range(0, num_points, 4)])
    table.append([i for i in range(1, num_points, 4)])
    table.append([i for i in range(2, num_points, 4)])
    table.append([i for i in range(3, num_points, 4)])

    print(table)

    width = int(math.log(num_points, 2))

    # this k-index table is related to the above table in that each "equivalent" value is the bit-reversed version of the other
    # 0001 -> 1000
    # 0010 -> 0100
    width = int(math.log(num_points, 2))

    for i, row in enumerate(table):
        table[i] = [reverse_bits(j, width) for j in row]

    return table

    return table


def get_output_order_2(num_points: int) -> List[List[int]]:
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(
            num_points, 4)):
        print("get_output_order: num_points must be a power of 4")
        return

    table = get_input_order(num_points)

    width = int(math.log(num_points, 2))

    for i, row in enumerate(table):
        table[i] = [reverse_bits(j, width) for j in row]

    return table


def reverse_bits(input: int, width: int):
    b = '{:0{width}b}'.format(input, width=width)
    return int(b[::-1], 2)


if __name__ == '__main__':
    print(get_output_order_2(16))
