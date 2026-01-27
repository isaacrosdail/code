
from typing import List, Dict, Set

# nums = [1,2,3,4,5,6,7]
# target = 6

nums = [3,2,4]
target = 6

def twoSum(nums: List[int], target: int) -> List[int]:
    for i, num in enumerate(nums):
        for j, num2 in enumerate(nums):
        # i, j positions
        # num, num2 are the nums at these position
        # then i != j to ensure we aren't using same idx twice
            if num + num2 == target and i != j:
                return [i, j]
    return [69, 69]


def twoSumOptimal(nums: List[int], target: int) -> List[int]:
    prev_map = {} # maps value to index of said value
    # ie, keyed by number value to number's index

    for i, num in enumerate(nums):
        # Calc current difference
        diff = target - num
        # if this difference is already in the hashmap,
        # we can return the solution
        # a pair of the indices
        # prevMap[diff]
        print(f"{i}: {num} {diff} {prev_map}")

        if diff in prev_map:
            # prevMap[diff] => idx of the earlier number whose value equals diff?
            # i is ofc the idx of current element/entry
            return [prev_map[diff], i]
        prev_map[num] = i
    return [69, 69]

print(twoSumOptimal(nums, target))
