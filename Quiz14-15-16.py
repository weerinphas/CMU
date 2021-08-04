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
column_num = int(input("Number of column: "))
row_num = int(input("Number of row: "))
listResult = []

for i in range(0, row_num):
    for j in range(0, column_num):
        if i < j:
            value = 0.
            listResult.append(value)
        elif i == j:
            value = 1.
            listResult.append(value)
        else:
            value = -1.
            listResult.append(value)

matrixResult = np.array(listResult)
matrixResult_shaped = np.reshape(matrixResult, (row_num, column_num))
print(matrixResult_shaped)

