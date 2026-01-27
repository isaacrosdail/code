import inspect
from sqlalchemy.orm import InstrumentedAttribute
from sqlalchemy import Column

# Fake SQLAlchemy Column
class Column:
    def __init__(self, type_):
        self.type_ = type_
    
    def __get__(self, instance, owner):
        # Simplified descriptor behavior
        if instance is None:
            return self
        return instance.__dict__.get(self.name, None)
    
    def __set__(self, instance, value):
        instance.__dict__[self.name] = value
    
    def __set_name__(self, owner, name):
        self.name = name


# Fake SQLAlchemy InstrumentedAttribute (what Column becomes on the class?)
class InstrumentedAttribute:
    def __init__(self, name):
        self.name = name


# Mock Task model
class Task:
    id = Column(int)
    name = Column(str)
    is_done = Column(bool)
    
    def __init__(self):
        self.id = 123
        self.name = "Buy groceries"
        self.is_done = False
        self._internal_state = "secret"
    
    @property
    def subtype(self):
        return "urgent" if self.is_done else "pending"
    
    @property
    def created_at_local(self):
        return "2025-01-15"
    
    def regular_method(self):
        return "I'm a method!"


# Now test your introspection!
task = Task()

print("=== Inspecting Task class ===")
for name, obj in inspect.getmembers(task.__class__):
    if isinstance(obj, (property, Column)) and not name.startswith("_"):
        print(f"{name:20} → {type(obj).__name__:30} -> {obj!r}")