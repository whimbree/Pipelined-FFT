import numpy as np
import matplotlib.pyplot as plt
import scipy.fftpack

num_points = 16

x = []
for i in range(1, num_points + 1):
    x.append(0.0001 * i)

print(x)

print()

print(np.fft.fft(x))
