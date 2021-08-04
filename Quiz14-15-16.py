"""
Quiz 14-15-16:
Topic : Matrix
Author: Weerinphas Chimnam
Student ID: 640631127
Date August 4,2021

"""

import numpy as np
from scipy.linalg import solve

# Quiz14
A = np.array([[1.,2,], [3.,4.]])
b = np.array([1.,4.])
x = solve(A, b)
print(x)

# Quiz15
M = np.array([[1,2,3], 
              [4,5,6], 
              [7,8,9], 
              [10,11,12]])
print(M[2,:]) #select the third row only,first column: 7
print(M[2:]) #select from the third row,first column: 7 to the last row

# Quiz16
n = int(input("Number of column: "))
m = int(input("Number of row: "))
matrixResult = np.array([])

for i in range(0, m):
    for j in range(0, n):
        if i < j and j != m:
            value = 0.
        elif i == j or j == m:
            value = 1.
        else:
            value = -1.
        matrixResult = np.append(matrixResult,value)

matrixResult_shaped = np.reshape(matrixResult, (m, n))
print(matrixResult_shaped)

