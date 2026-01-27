
from typing import Generator

# Generators take 3 vals
# First is the type we're going to yield
# Second is the type that is sent TO the generator
# Third is what we RETURN from the generator
def fibonacci_generator() -> Generator[int, None, None]:
    a, b = 0, 1
    while True:
        yield a
        a, b = b, (a + b)

def main() -> None:
    fib_gen: Generator[int, None, None] = fibonacci_generator()
    n: int = 10
    line_break: str = '-' * 20

    while True:
        input(f"Tap 'enter' for the next {n} numbers of the fiboncci sequence")
        for i in range(n):
            print(f'{next(fib_gen)}')

        print(line_break)

if __name__ == '__main__':
    main()

# The presence of yield + (a value) is what makes Python recognize "this is a generator function"
# Generator function -> a def that contains yield
# Generator object -> what you get when you CALL that function

