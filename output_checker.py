import math
from typing import List


def main():
    print(get_input_order(64))


def get_input_order(num_points: int) -> List[List[int]]:
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(
            num_points, 4)):
        print("get_input_table: num_points must be a power of 4")
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


if __name__ == '__main__':
    main()