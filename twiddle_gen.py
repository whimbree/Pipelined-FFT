from string import Template
import math

# real: cos(2pi*k / FFT_PTS)
# img: sin(2pi*k / FFT_PTS)
# shift left by data width - 1 
# (above is assuming that we are using fixed point with one sign bit and the rest as fractional bits)

def main():
    num_points = int(input("How many points is the FFT?: "))
    data_width = int(input("What is the data width?: "))
    
    constant_template = "constant $key  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#$value#, DATA_WIDTH));"
    constant_template_obj = Template(constant_template)
    
    print()
    
    for k in range(0, num_points):
        real_value = math.cos(2*math.pi*k/num_points)
        real_value *= 2**(data_width-1)
        real_value = int(real_value)
        # https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
        print(constant_template_obj.substitute(key="REAL_" + str(k), value='{:x}'.format(real_value & (2**data_width-1))))
        
    print()
        
    for k in range(0, num_points):
        imag_value = math.cos(2*math.pi*k/num_points)
        imag_value *= 2**(data_width-1)
        imag_value = int(imag_value)
        # https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
        print(constant_template_obj.substitute(key="IMAG_" + str(k), value='{:x}'.format(imag_value & (2**data_width-1))))
    

if __name__ == "__main__":
    main()