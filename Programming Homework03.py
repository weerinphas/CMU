"""
Homework03:
Make it the GAME: "Take x sticks from the pile with smart computer"
Author: Weerinphas Chimnam
Student ID: 640631127
Date July 27,2021
Version1

"""

import random

number_of_stick = int(input("How many sticks (N) in the pile: "))

if number_of_stick>=1:
    player_name = str(input("What your name: "))
    pick_Player = random.choice([player_name,"smart computer"])
    print(pick_Player, "plays first")

    def player():
        global number_of_stick, player_name,pick_Player
        player_pick = int(input(player_name + ", how many sticks you will take (1 or 2): "))
        if (player_pick == 1 or player_pick == 2):
            number_of_stick -= player_pick
            if(number_of_stick > 0):
                print("There are ", number_of_stick, "sticks in the pile")
                pick_Player = "smart computer"
            elif(number_of_stick == 0):
                print(player_name + " takes the last stick.")
                print("smart computer win")
        elif (player_pick < 1):
            print("No you cannot take less than 1 sticks!")
        elif (player_pick > 2):
            print("No you cannot take more than 2 sticks!")

    def smart_com(number_of_stick):
        choice = (number_of_stick-1) % 3
        if choice == 2:
            for i in range(number_of_stick-(choice-1), choice-1, -3):
                if number_of_stick - i == 0:
                    com_pick = 1
                    break
                else:
                    com_pick = 2
                    break
        elif choice == 0:
            for i in range(number_of_stick-2, choice-1, -3):
                if number_of_stick - i == 0:
                    com_pick = 1
                    break
                elif number_of_stick - i == 1:
                    com_pick = 2
                    break
                else:
                    com_pick = random.randint(1, 2)
                    break
        else:
            for i in range(number_of_stick-(choice-1), choice, -3):
                if number_of_stick - i == 0:
                    com_pick = 1
                    break
                elif number_of_stick - i == 1:
                    com_pick = 2
                    break
                else:
                    com_pick = random.randint(1, 2)
        return com_pick

    def computer():
        global number_of_stick, player_name     
        if (number_of_stick > 2):
            com_pick = smart_com(number_of_stick)
            print("I, smart computer take: ", com_pick)
            number_of_stick -= com_pick
            print("There are ", number_of_stick, "sticks in the pile")
        elif (number_of_stick == 2 or number_of_stick == 1):
            com_pick = 1
            print("I, smart computer take: ", com_pick)
            number_of_stick -= com_pick
            if(number_of_stick > 0):
                print("There are ", number_of_stick, "sticks in the pile")
            elif(number_of_stick == 0):
                print("I, smart computer takes the last stick.")
                print(player_name, "wins (I, smart computer, I'm sad T_T)")

    while True:
        if(number_of_stick != 0):
            if (pick_Player == player_name):
                player()
            elif(pick_Player == "smart computer"):
                computer()
                pick_Player = player_name
        elif(number_of_stick == 0):
            break
else:
  print("Error, The number of sticks (N) in the pile must more than 0")
