height = int(input("Height: "))
if height < 1 or height > 8:
    height = int(input("Height: "))
for hash in range(1, height + 1):
    space = height - hash
    print((" " * space) + ("#" * hash) + "  " + ("#" * hash))
