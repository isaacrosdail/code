
# print("Welcome to heck, fecker. Press q to leave")

# while True:
#     # Everything from input() is a string, so you must cast when you want numbers/etc
#     match name := input('Name? '):
#         case 'q':
#             break
#         case s if s.isdigit():
#             print(int(s) * 2)
#         case _:
#             print(f"Name was dumb")

# while (line := input(">> ")) != "":
#     print(f"Echo: {line}")

balance = 100
while True:
    try:
        num = float(input('Deposit: '))
        break
    except ValueError:
        print('Must be valid quantity')

balance += num
print(f'Balance: {balance}')