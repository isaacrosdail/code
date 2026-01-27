
############ TEST / PRACTICE 1
# When announce(hello) runs:
# If defines the wrapper function, returns the wrapper object, then
# that returned wrapper gets assigned to wrapped_hello()
# def announce(fn):
#     def wrapper():
#         print("Before the function runs")
#         fn()
#         print("After the function runs")
#     return wrapper

# def hello():
#     print("Hello!")

# # Manual wrapping, no @
# # So at read time, we're loading the gun (wrapped_hello()) with the bullet (announce(hello))
# wrapped_hello = announce(hello)

# print("Calling original hello():")
# hello()

# print("\nCalling wrapped_hello():")
# # At call time, we pull the trigger - the wrapper fires, printing "before", running hello(), then printing "after"
# wrapped_hello()
##############


############## TEST / PRACTICE 2
# def announce(fn):
#     print("announce() called — wrapping", fn.__name__)
#     def wrapper():
#         print(f"Before {fn.__name__}")
#         fn()
#         print(f"After {fn.__name__}")
#     return wrapper

# def greet():
#     print("Hello!")

# print(">>> Assigning wrapped_greet")
# wrapped_greet = announce(greet)  # read-time wrapping

# print(">>> Calling wrapped_greet")
# wrapped_greet()

# print(">>> Calling announce(greet)() directly")
# announce(greet)()

### Step by Step:
# 1. Python defines announce (no output yet)
# 2. Python defines greet (no output yet)
# 3. Prints: >>> Assigning wrapped_greet
# 4. Executes wrapped_greet = announce(greet)
#       - Calls announce immediately with fn = greet
#       - Inside announce, prints: announce() called - wrapping greet
#       - Builds a new wrapper function (closing over greet)
#       - Returns that wrapper; wrapped_greet now points to it
#           No "before"/"after" yet - the wrapper hasn't been called
# 5. Prints: >>> Calling wrapped_greet
# 6. Executes wrapped_greet
#       - This calls the wrapper created in step 4
#       - Wrapper prints: Before greet
#       -
#
#

# # 1. Defines our function
# def say_hi():
#     print("Hi")

# # 2. Defines the wrapper factory
# # When we call wrapped_hi(say_hi), Python:
# def wrapped_hi(fn):         # <- Passes the function object say_hi into fn
#     print("wrapping...")    # <- Prints "wrapping..." (because that line is at the top level of wrapped_hi)
#     def wrapped_func():     # <- Defines wrapped_func (a closure over fn)
#         print("Before")
#         fn()
#         print("After")
#     return wrapped_func     # <- Returns the wrapped_func object
# # NOTE: It does not run wrapped_func yet - it just returns it.

# wrapped_hi(say_hi)      # <- Doing only this just prints "wrapping..."
# # That's cause we're only calling wrapped_hi, but are ignoring what it returns

# # We need to store the function in a variable and then call it, like:
# new_hi = wrapped_hi(say_hi)
# new_hi()

##############


############## TEST / PRACTICE 3
def log_call(fn):
    def wrapper(*args, **kwargs):
        print(f"Calling {fn.__name__}")
        result = fn(*args, **kwargs)
        print(f"Finished {fn.__name__}")
        return result
    return wrapper

@log_call
def greet(name):
    print(f"Hi {name}")

greet("Alice")
greet("John")

import inspect

def get_dunders(obj_or_class):
    """Get all dunder methods/attributes from an object or class.
    Args:
        obj_or_class: Instance or class to inspect
    Returns:
        Dict mapping dunder names to their values/objects
    Example:
        get_dunders(task) -> {'__str__': <method>, '__tablename__': 'tasks', ...}
    """
    # This works, but we can do better.
    # result = {}
    # for name, obj in inspect.getmembers(obj_or_class):
    #     if name.startswith('__') and name.endswith('__'):
    #         result[name] = obj
    # return result
    return {
        k: v
        for (k, v) in inspect.getmembers(obj_or_class)
        if k.startswith("__") and k.endswith("__")
    }


class MyClass:
    def thing(self) -> str:
        return "hello"


# print(get_dunders(MyClass))


### Let's put the timer decorator stuff here too. Will move this to an appropriate place after:


# def timer(func): # type: ignore[no-untyped-def]
#     """Decorator that prints how long a function takes to run."""
#     # Preserves original function's name/docstring
#     @wraps(func)   #  <- slow_function gets passed as func
#     def wrapper(*args, **kwargs): # type: ignore[no-untyped-def]  # wrapper becomes the new slow_function, so when
#         # someone calls slow_function(), theyre actually calling wrapper()
#         # YOUR CODE HERE:
#         # 1. Record start time
#         start = time.time()
#         # 2. Call the original function
#         result = func(*args, **kwargs)
#         # 3. Record end time
#         end = time.time()
#         print(f"Took {end - start} sec.")
#         # 4. Print the difference
#         # 5. Return the function's result
#         return result
#     return wrapper

# # Test it:
# @timer
# def slow_function(): # type: ignore[no-untyped-def]
#     time.sleep(1)
#     return "done"

# print(slow_function())  # Should print timing info + "done"


# def timing(name: str) -> Callable[[Callable[P, R]], Callable[P, R]]:
#     def timing_dec(func: Callable[P, R]) -> Callable[P, R]:
#         @wraps(func)
#         def timing_dec_impl(*args: P.args, **kwargs: P.kwargs) -> R:
#             t0 = time.monotonic()
#             try:
#                 return func(*args, **kwargs)
#             finally:
#                 t1 = time.monotonic()
#                 print(f"LOG: {name} took: {t1 - t0}")
#         return timing_dec_impl
#     return timing_dec

# @timing('g.timing')
# def g(x: int) -> int:
#     return x ** x

# g(10)

# @contextlib.contextmanager
# def timing_ctx(name: str) -> Generator[None, None, None]:
#     t0 = time.monotonic()
#     try:
#         yield
#     finally:
#         t1 = time.monotonic()
#         print(f"LOG: {name} took: {t1 - t0}")
