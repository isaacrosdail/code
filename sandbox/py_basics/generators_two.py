# Ways to consume a generator expression:

numbers = [1, 2, 3, 4, 5]

## We can use a generator expression to replace generator function syntax/format:
# Loop over it (most common)
gen = (n ** 2 for n in numbers)
for value in gen:
    print(value)

# Convert to list/set/tuple
gen = (n ** 2 for n in numbers)
result = list(gen)  # [1, 4, 9, 16, 25]

# Use in functions that take iterables
gen = (n ** 2 for n in numbers)
total = sum(gen)  # 55

###### NOTE: Why use a generator expression over a list comprehension?
# When:
# 1. One-time iteration is enough
# 2. Large datasets (millions of rows)
# 3. Passing to functions like sum(), max(), any(), all() (these consume iterables)
# 4. Chaining operations (more advanced)


# List comprehension
result = [n ** 2 for n in range(1000000)]
# Creates ALL million items in memory NOW
# Memory usage: ~8MB+ for the list

# Generator expression  
result = (n ** 2 for n in range(1000000))
# Creates items ONLY when asked -> ie, NOTHING for rn
# It just remembers the recipe
# Memory usage: tiny generator object (~200)

# But there's one bit of crucial nuance here: When the generator DOES create items, it
# only creates ONE AT A TIME, as we iterate.
# That means: Even when the above generator starts iterating, it does NOT create ALL items
# EX: Here, we only compute like 11 values, NOT a million
gen2 = (n ** 2 for n in range(1000000))
for val in gen:
    if val > 100:
        break

# This might be useful for processing CSV files for that import/export feature (not that our db is large enough anyway but still!)
##  rows = (process_row(row) for row in csv.reader(file))
def paginate_results(query, page_size=100):
    offset = 0
    while True:
        batch = query.limit(page_size).offset(offset).all()
        if not batch:
            break
        for item in batch:
            yield item   # Lazy! only fetches next page when needed
        offset += page_size