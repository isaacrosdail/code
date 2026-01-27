# Note: This is new to Python 3.9+ so it MIGHT be a "use at home, not at work" :( we'll see lol
# Two flavors:

# 1:  |=  This one MUTATES the dict to add the right side
# 2:  |   This one DOES NOT mutate anything - it creates a new dict with the combination


dict1 = {"a": 1, "b": 2}
dict2 = {"c": 3, "d": 4}
result = dict1 | dict2    # combines both into NEW dict
dict1 |= dict2
print(dict1)


# Order REALLY matters when there are conflicts:
dict1 = {"a": 1, "x": 100}
dict2 = {"b": 2, "x": 200}
dict3 = {"c": 3, "x": 300}

result = dict1 | dict2 | dict3