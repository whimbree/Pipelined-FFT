from string import Template
import math

# real: cos(2pi*k / FFT_PTS)
# img: sin(2pi*k / FFT_PTS)
# shift left by data width - 1
# (above is assuming that we are using fixed point with one sign bit and the rest as fractional bits)


def main():
    num_points = int(input("How many points is the FFT?: "))
    data_width = int(input("What is the data width?: "))

    constant_template = 'constant $key  : std_logic_vector(DATA_RANGE) := x"$value";'
    constant_template_obj = Template(constant_template)

    print()

    for k in range(0, num_points):
        real_value = math.cos(2 * math.pi * k / num_points)
        real_value *= 2**(data_width - 1)
        real_value = int(real_value) & (2**data_width - 1)
        # Prevent 0x8000... from causing overflows
        if real_value == 2**(data_width - 1):
            real_value -= 1
        # https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
        print(
            constant_template_obj.substitute(
                key="REAL_" + str(k),
                value='{:0x}'.format(real_value).zfill(
                    math.ceil(data_width / 4))))

    print()

    for k in range(0, num_points):
        imag_value = math.sin(2 * math.pi * k / num_points)
        imag_value *= 2**(data_width - 1)
        imag_value = int(imag_value) & (2**data_width - 1)
        # Prevent 0x8000... from causing overflows
        if imag_value == 2**(data_width - 1):
            imag_value -= 1
        # https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
        print(
            constant_template_obj.substitute(
                key="IMAG_" + str(k),
                value='{:0x}'.format(imag_value).zfill(
                    math.ceil(data_width / 4))))


if __name__ == "__main__":
    main()