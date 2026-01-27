# So why use Sets anyway?

# 1. Fast membership checking
# O(1) vs O(n)
# Bad: list lookup is slow with many items
# ALLOWED_IPS = ["192.168.1.1", "10.0.0.5", ...]  # 10,000 IPs
# if request.remote_addr in ALLOWED_IPS:  # checks every item sequentially

# # Good: set lookup is instant
# ALLOWED_IPS = {"192.168.1.1", "10.0.0.5", ...}
# if request.remote_addr in ALLOWED_IPS:  # hash lookup, instant


# 2. Removing duplicates
tags = ["python", "flask", "python", "web", "flask"]
unique_tags = set(tags)  # {"python", "flask", "web"}

my_set = {1, 2, 3, 4}
my_other_set = {3, 4, 5, 6}

my_difference = my_set - my_other_set   # {1, 2}
my_intersection = my_set & my_other_set # {3, 4}
my_union = my_set | my_other_set        # {1, 2, 3, 4, 5, 6}
my_symmetric_difference = my_set ^ my_other_set

print(my_union)


# So wtf are sets used for anyway? Aside from being fast af for membership checks:

# Tag/Permission Operations
user_permissions = {"read", "write", "delete"}
required_permissions = {"write", "admin"}

# <=  is subset check
if required_permissions <= user_permissions:
    pass
    # allow_action()

# What permissions are they missing?
missing = required_permissions - user_permissions   # {"admin"}

# Finding What Changed
old_followers = {1, 5, 10, 15}
new_followers = {1, 5, 20, 25}

new_follows = new_followers - old_followers # {20, 25}
unfollows = old_followers - new_followers   # {10, 15}


# De-duping while processing:
all_items = [1,2,3,4,5]
# Processing unique items from multiple sources
seen_ids = set()
for item in all_items:
    process(item)
    seen_ids.add(item.id)


# Finding common elements across collections
# What tags do all these posts share?
post1_tags = {"python", "tutorial", "beginner"}
post2_tags = {"python", "webdev", "tutorial"}
post3_tags = {"python", "tutorial", "advanced"}

common = post1_tags & post2_tags & post3_tags  # {"python", "tutorial"}