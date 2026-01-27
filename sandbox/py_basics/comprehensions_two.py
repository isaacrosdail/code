
# Flattens nested iterables:
matrix = [[1, 2], [3, 4], [5, 6]]
flattened = [num for row in matrix for num in row]

# BUT chain.from_iterable is from the itertools module & it's perfect here. It evaluates lazily, like generators.
from itertools import chain

data = [[1, 2], [3, 4], [5, 6]]
result = list(chain.from_iterable(data))
# [1, 2, 3, 4, 5, 6]


# Nested comp gets messy fast
result = [item for sublist in data for item in sublist if item > 5]

# Chain + filter is clearer
result = (item for item in chain.from_iterable(data) if item > 5)