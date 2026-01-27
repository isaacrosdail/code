

my_name = "Sarah"
print(f"{my_name:20}")


names = [
    "Bob",
    "Ben",
    "Joe",
    "Jen",
    "Tim"
]
# We can create dedicated slices :D
# my_str[start:end:step]
# OR we can do this
# slice(start, end, step)
winners = slice(0, 3, None)
rev = slice(None, None, -1)

print(names[winners])
print(names[rev])