from string import Template
import math

# real: cos(-2pi*k / FFT_PTS)
# img: sin(-2pi*k / FFT_PTS)
# shift left by data width - 1
# (above is assuming that we are using fixed point with one sign bit and the rest as fractional bits)


def main():

    twiddle_factors_per_line = 10
    filename = "user_pkg.vhd"

    num_points = int(input("How many points is the FFT?: "))
    if math.floor(math.log(num_points, 4)) != math.ceil(math.log(
            num_points, 4)):
        print("num_points must be a power of 4")
        return

    data_width = int(input("What is the data width?: "))

    array_value_template = '$index => x"$value"'
    array_value_template = Template(array_value_template)

    with open(filename, "w") as f:

        f.write("library ieee;\n"
                "use ieee.std_logic_1164.all;\n"
                "use ieee.numeric_std.all;\n"
                "use ieee.math_real.all;\n\n"
                "package user_pkg is\n\n")

        f.write(
            f"constant DATA_WIDTH : positive := {data_width};\n" +
            "subtype DATA_RANGE is natural range DATA_WIDTH - 1 downto 0;\n\n")

        f.write(
            f"constant NUM_POINTS : positive := {num_points};\n" +
            "constant NUM_INTERNAL_STAGE_PAIRS : positive := positive((log2(real(NUM_POINTS)) / log2(real(4))) - real(1));\n\n"
            +
            "type TWIDDLE_ARRAY is array (natural range <>) of std_logic_vector(DATA_RANGE);\n"
            +
            f"subtype TWIDDLE_RANGE is natural range 0 to NUM_POINTS - 1;\n\n")

        # REAL TWIDDLE FACTOR GENERATION

        f.write(
            f"constant TWIDDLE_FACTORS_REAL : TWIDDLE_ARRAY(TWIDDLE_RANGE) := ("
        )

        for k in range(0, num_points):
            f.write(
                array_value_template.substitute(
                    index=k,
                    value='{:0x}'.format(
                        gen_twiddle_factor(math.cos, k, num_points,
                                           data_width)).zfill(
                                               math.ceil(data_width / 4))))
            if k != num_points - 1:
                f.write(",")
            if (k + 1) % twiddle_factors_per_line == 0:
                f.write("\n")

        f.write(");\n\n")

        # IMAGINARY TWIDDLE FACTOR GENERATION

        f.write(
            f"constant TWIDDLE_FACTORS_IMAG : TWIDDLE_ARRAY(TWIDDLE_RANGE) := ("
        )

        array_value_template = '$index => x"$value"'
        array_value_template = Template(array_value_template)

        for k in range(0, num_points):
            f.write(
                array_value_template.substitute(
                    index=k,
                    value='{:0x}'.format(
                        gen_twiddle_factor(math.sin, k, num_points,
                                           data_width)).zfill(
                                               math.ceil(data_width / 4))))
            if k != num_points - 1:
                f.write(",")
            if (k + 1) % twiddle_factors_per_line == 0:
                f.write("\n")

        f.write(");\n\n")

        f.write(
            "constant ZERO : std_logic_vector(DATA_RANGE) := (others => '0');\n\n"
            "constant NEGATIVE_ONE : std_logic_vector(DATA_RANGE) := ((DATA_WIDTH - 1) => '1', others => '0');\n\n"
        )

        f.write("end user_pkg;")


def gen_twiddle_factor(trig_func, k, num_points, data_width) -> int:
    epsilon = 0.0001

    value = trig_func(-2 * math.pi * k / num_points)
    trunc_value = value * 2**(data_width - 1)
    # https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
    trunc_value = int(trunc_value) & (2**data_width - 1)
    if abs(value - 1.0) < epsilon:
        trunc_value -= 1
    return trunc_value


if __name__ == "__main__":
    main()