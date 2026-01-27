
nums: list[int] = [1,2,3,4,5,5,6]

def contains_duplicate(nums: list[int]) -> bool:

    # For each entry, we just wanna know "Seen before?"
    # freq is irrelevant, only binary seen/not seen
    seen = set()
    for i, num in enumerate(nums):
        # so what does "seen" mean?
        # it means its in set 'seen'
        # each iter, then, check if seen, if not, add to seen
        if num in seen:
            return True
        seen.add(num)
    else:
        return False


print(contains_duplicate(nums))
