
# Assignment + condition in the same line
# Perfect for: avoiding duplicate expensive calls
# Cannot use it where assignment would be misleading/ambiguous (ex: as a standalone statement)
# Should NOT use it to hide mutation.

#### PRECEDENCE ORDER
# := (walrus/assignment expression) - LOWEST precedence
# lambda
# if – else (ternary/conditional expression)
# or
# and
# not... and so on up to highest precedence operators

# The core rule is:
#  := only binds the value of an expression;
#  It does not exist to make side-effects more compact or to replace statements.
#  Anything that returns None (like list.append, dict.update, set.add) is therefore a dead end for walrus,
#  because rebinding would destroy your variable.

# # FOR EXAMPLE: Here, this does not work.
# def filter(self, strategy):
#     # res = []
#     for n in self.vals:
#         if not strategy.removeValue(n):
#             res := res.append(n)         # Mutating as we use the walrus operator = Python says NO.
#     return res

# # Pattern:
# if (result := expensive_func()) is not None:
#     ...


# Here, this gets parsed as:
# if (thing := (5 == 6)):
# So thing becomes False
# Whereas it looks like we're
if thing := 5 == 6:
    print("Not what you think")

# Nifty way to do "keep taking input as long as input is non-empty"
while (line := input('> ')) != '':
    ...


## Tricky bits involving ternary operator
val = "    hello     "

# Ternary evaluates BEFORE walrus assignment
# result1 = (stripped := val.strip()) if stripped else None
my_str = stripped := val.strip() if stripped else None