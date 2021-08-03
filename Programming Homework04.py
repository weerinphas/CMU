"""
Homework04:
Write a program : "Find a largest number"
Author: Weerinphas Chimnam
Student ID: 640631127
Date August 1,2021
Version1_Method1

"""

print("Please enter four non negative number")
listPosition = ['First','Second','Third','Fourth']
listNumber = []
listProb = []

for i in range (4):
    while True:
        number_input = int(input(listPosition[i] +  " number: "))
        if (number_input >= 0):
            listNumber.append(number_input)
            i += 1
            break  
        else:
            print("The number must be non negative number and not more than 99")

print("The list of four numbers: ", listNumber)

def perm(a, k=0):
    if k == len(a):
        result_str = "".join(map(str, a))
        listProb.append(int(result_str))
    else:
        for i in range (k, len(a)):
            a[k], a[i] = a[i] ,a[k]
            perm(a, k+1)
            a[k], a[i] = a[i], a[k]

perm(listNumber)
print("A largest number is", max(listProb))