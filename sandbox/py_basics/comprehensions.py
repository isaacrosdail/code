# Found regarding this question:
# https://stackoverflow.com/questions/13184275/how-to-retrieve-python-list-of-sqlalchemy-result-set

# Note that comprehensions with nested for's (for .... for....) are usually avoided since they are pain to read
# But flattening a 2d list IS a solid one to memorize
matrix = [[1, 2], [3, 4], [5, 6]]
flattened = [num for row in matrix for num in row]

# Posted by zzzeek, modified by community. See post 'Timeline' for change history
# Retrieved 2026-01-03, License - CC BY-SA 3.0
# result = [("idk"), ("just"), ("an"), ("example")]

# result = [r[0] for r in result]
#  VS.
# result = [r for r, in result] # for dealing with discrete columns? idk


#################### A note on when to use list vs generator comprehensions:
# List:
# Need to iterate multiple times (generators exhaust after one pass!)
# Need indexing (result[5])
# Need len() (can't get the length of a generator without consuming it)
#
# Generator:
# One-time
#
#
#


numbers = [1, 2, 3, 4, 5]

# Squared vals, but only for odd numbers
# result = [n ** 2 for n in numbers if n % 2 != 0]
# words = ["hello", "world", "python", "hi"]

# result = [len(w) for w in words if w.startswith("h")]
# result = [(n, n * 10) for n in numbers if n % 2 == 0]

# result = [n % 2 for n in numbers]

# NOTE: There are two "flavors" of comprehensions in a way:
# IF at the end        -> filters items (skip/include)
# IF in the expression -> transforms items (choose between two values)
# result = ["even" if n % 2 == 0 else "odd" for n in numbers]

# result = ["small" if n < 3 else "big" for n in numbers]

######## DICT COMPREHENSIONS ########
# result = {n: n ** 2 for n in numbers} # building a "number to its square" lookup table :D
words = ["hello", "world", "python"]
# result = {word: len(word) for word in words}

# result = {n: "even" for n in numbers if n % 2 == 0}

user_data = [("alice", 25), ("bob", 30), ("charlie", 35)]
# result = {k:v for (k, v) in user_data if v >= 30}

# result = {n: [n, n] for n in numbers}


######### SET COMPREHENSIONS ##########
# {expression for item in iterable}

# result = {n ** 2 for n in numbers} # Remember: sets auto-dedupe


######### Generator Comprehensions ##########
# The parentheses here create a generator expression
# Lazy evaluation and all that jazz
# (n ** 2 for n in numbers)

words = ["hello", "world", "hello", "python", "world"]
# result = {w for w in words if len(w) > 4}

# We can define a generator with this icky, verbose function syntax
def squares_gen():
    for n in numbers:
        yield n ** 2

## OR, we could just use a generator expression!
gen = (n ** 2 for n in numbers)
print(gen)  # This prints the OBJECT's mem address, since we haven't used next() yet!

print(next(gen))