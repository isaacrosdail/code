# Best Time to Buy & Sell Stock (ID#121)

# prices = [7,1,5,3,6,4]
prices = [7,6,4,3,1]

# prices[i] = price of given stock on the i-th day

# Invariant: min_price is ALWAYS the lowest price seen so far before or at the current day.
# Check is sorta: "Does today improve the invariant (max_profit) given the current anchor (min_price)?"

def maxProfit(prices: list[int]) -> int:
    min_price = prices[0]
    max_profit = 0
    for i, curr_price in enumerate(prices):
        print(f"D:{i} $:{curr_price} Lowest: {min_price}")
        if curr_price < min_price:
            min_price = curr_price

        maybe_max_profit = prices[i] - min_price
        if maybe_max_profit > max_profit:
            max_profit = maybe_max_profit

    return max_profit

print(maxProfit(prices))
