# zip takes multiple iterables and yields tuples of their elements pairwise.
# if one iterable is shorter, it stops at the shortest length

a = [1,2,3]
b = [4,5,6]

# for a, b in zip(a, b):
#     print(a, b)

# A common pattern for adjacent pairs is:
# Zip a with version of a shifted right by one
# since [1:] -> everything except the first element
# So idx alignment produces: (seq[0], seq[1]) then (seq[1], seq[2]), etc.
# Because zip stops at the shortest iterable, we'll never get an out of bounds pair :D
result = zip(a, a[1:])
print(list(result))