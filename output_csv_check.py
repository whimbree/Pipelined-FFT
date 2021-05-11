import math
import pandas as pd
import numpy as np
import warnings
from util import fixed_point_hex_to_float


def main():
    actual_output = pd.read_csv("tb_testOutput.csv", header=None, sep=r",").apply(
        np.vectorize(fixed_point_hex_to_float)
    )

    expected_output = pd.read_csv("tb_expectedOutput.csv", header=None, sep=r",").apply(
        np.vectorize(fixed_point_hex_to_float)
    )

    difference = (actual_output - expected_output).abs()

    percent_error = compute_percent_error(actual_output.values, expected_output.values)

    percent_error_tolerance = 0.5

    for i in range(len(percent_error.values)):
        for j in range(len(percent_error.values[0])):
            if percent_error[j][i] > percent_error_tolerance:
                print(
                    f"ERROR: output[{i}][{j}] has percent error {percent_error[j][i]}% with difference {difference[j][i]}"
                )


def compute_percent_error(actual: np.array, expected: np.array) -> pd.DataFrame:

    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        return pd.DataFrame(
            [
                abs(((actual[i][j] - expected[i][j]) * 100) / expected[i][j])
                for j in range(len(actual[i]))
            ]
            for i in range(len(actual))
        )


if __name__ == "__main__":
    main()
