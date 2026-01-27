"""
Sorting algorithms library (practice/expansion stuff here).
Each algorithm:
- Operates in place unless otherwise noted.
- Is annotated with stability characteristics.
- Will be evaluated for time and space complexity.

- (TODO) selection_sort, insertion_sort, quick_sort, merge_sort, etc.
"""

from typing import Any

"""
So say we have myList = [1, 6, 3, 9, 0]
1. 1 vs 6 -> no swap
2. 6 vs 3 -> swap ---> so now? myList = [1, 3, 6, 9, 0]
3. 6 vs 9 -> no swap
4. 9 vs 0 -> swap
So after one pass:
    myList = [1, 3, 6, 0, 9]

could we raise efficiency by saving the value for the lowest somehow?
After first pass: = [1, 3, 9, 0, 6]
"""

# Class to make Task objects for testing
class SimpleTask:
    def __init__(self, title, priority):
        self.title = title
        self.priority = priority

# Stable
def bubble_sort_simple(myList):
    """Already implemented."""

# Stable
def bubble_sort(myList: list[Any], key: str, reverse: bool = False) -> None:
    """Already implemented."""

# Slightly more efficient than bubble sort
def selection_sort():
    pass

# Good for small datasets
# Stable
def insertion_sort():
    pass

# Faster, but more complex
# Divide & conquer, choose a pivot and partition the array around that.
# Generally not stable
def quick_sort():
    pass

# Most implementations produce a stable sort
def merge_sort():
    pass

# Stable
def count_sort():
    pass

def bucket_sort():
    pass

def bogo_sort():
    pass

# Timsort - Hybrid, stable
def timsort():
    pass


"""
Sorting algorithms library.

Implements classic sorting algorithms for practice.
Each algorithm:
- Operates in place unless otherwise noted.
- Is annotated with stability characteristics.
- Will be evaluated for time and space complexity.

NOTE:
These implementations are obviously for learning purposes only.
I would of course use Python's built-in `sorted()` or database `ORDER BY` in
any real-world scenario.
"""

from typing import Any


# Stable
def bubble_sort_simple(my_list: list[Any]) -> None:
    # Outer loop decides whether to continue
    for i in range(len(my_list) - 1):
        no_swaps = True
        for j in range(len(my_list) - i - 1):
            # If arr[j] > arr[j+1], swap
            if my_list[j] > my_list[j + 1]:
                no_swaps = False
                temp = my_list[j]
                my_list[j] = my_list[j + 1]
                my_list[j + 1] = temp
        if no_swaps:
            break


# Stable
def bubble_sort(my_list: list[Any], key: str, *, reverse: bool = False) -> None:
    """
    Sort a list of object in place using bubble sort algorithm.
    Args:
        my_list: List of objects to sort
        key: Name of the attribute by which to sort (as string)
        reverse: If True, sort in descending order. If False, ascending. Default: False
    Returns:
        None (modifies the list in place)
    """
    # Outer loop decides whether to continue
    for i in range(len(my_list) - 1):
        no_swaps = True
        for j in range(len(my_list) - i - 1):
            if reverse:
                # Swap current with next if it's less than (smaller bubbles to end)
                should_swap = getattr(my_list[j], key) < getattr(my_list[j + 1], key)
            else:
                # Swap current with next it it's greater than (largest bubbles to end)
                should_swap = getattr(my_list[j], key) > getattr(my_list[j + 1], key)
            if should_swap:
                no_swaps = False
                temp = my_list[j]
                my_list[j] = my_list[j + 1]
                my_list[j + 1] = temp
        # traverse 1x without swap => sorted fully
        if no_swaps:
            break
