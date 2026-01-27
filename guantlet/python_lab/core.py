
# What's the difference between these? Are b and c identical in every way?
a = 5
b = float(a)
c = 5.0

print(b == c) # == checks value
print(b is c) # is checks identity (same obj in memory)

# Walrus operator
# Lets you assign & use a variable in the same expression

if (n := len("hello")) > 3:
    print(n)

# Real-world use cases
import re
if match := re.match(r"(\d+)", "123abc"):
    print("Number:", match.group(1))

nums = [x for x in range(10) if (y := x * 2) > 10]
print(nums)
res = [x for x in range(10)]
print(res)