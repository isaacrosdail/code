
class Thing:
    def __init__(self): # <- initializer, configures MADE objects
        pass
    def __new__(self):  # <- constructor, THIS does the MAKING part. This dunder is called when we do my_obj = Thing()
        pass

