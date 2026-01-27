
# Yield is like return, but PAUSABLE

# Normal function:
# If you call this, you get 1, function is then done forever.
def count():
    return 1
    return 2  # never runs
    return 3  # never runs


# Generator function (has yield):
def count2():
    yield 1
    yield 2
    yield 3

# print((count2()))

def c():
    x = yield   # Yields None, can receive a value into x?
    return x

# Create the generator
g = c()

# Start the generator (as before next(g) is invoked, we'd just get the generator obj itself right?)
print(next(g))

# Send a val in (it becomes x since it is passed in as yield?)
try:
    g.send(5)
except StopIteration as e:
    print(e.value)
