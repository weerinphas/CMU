"""
Homework03:
Mathematics : "Optimization Model"
Author: Weerinphas Chimnam
Student ID: 640631127
Date August 9,2021
Version1

Assume you open your ice cream shop, there are only two types of ice cream, vanilla and strawberry. 
When a box of ice cream is sold, you will get the benefit for $2 for vanilla ice cream and $3 for strawberry ice cream. 
To make the ice cream, the fresh milk is required. To make a box of vanilla ice cream requires 0.5 liter and strawberry ice cream requires 0.2 liter. 
You daily order 10 liters of fresh milk. 
To promote your ice cream shop, you give a doll for each ice cream box. The number of dolls, that you can give to customers, is 30 dolls per day. 
So, how many boxes of vanilla ice cream and strawberry ice cream that you would like to produce to get maximum profit ? 
Use Python to find the answer ; provide solving explanation in PDF file
"""

# import numpy as np
# from scipy.linalg import solve
# # Build constraint matrixs
# # x = np.array([x1, x2])

# A = np.array([[0.5, 0.2],[1, 1]])
# B = np.array([10, 30])
# x = solve(A, B)
# print(x)

# max = 2*x[0] + 3*x[1]
# print(max)

import numpy as np
from scipy.linalg import solve
# Build constraint matrixs
# x = np.array([x1, x2])

A = np.array([[2, 2],[1, 5]])
B = np.array([1200, 1000])
# x.optimixe()
# print(x)

# max = 30*x[0] + 10*x[1]
# print(max)