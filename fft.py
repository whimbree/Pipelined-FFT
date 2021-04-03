import numpy as np
import matplotlib.pyplot as plt
import scipy.fftpack

x = [0.00001, 0.00002, 0.00003, 0.00004, 0.00005, 0.00006, 0.00007, 0, 0, 0, 0, 0, 0,0,0,0]
print (np.fft.fft(x))