from sys import exit


def inputnum():
    try:
        num = input("Number: ")
        check = int(num)
        return num
    except ValueError:
        inputnum()


num = str(inputnum())
if len(num) not in range(12, 17):
    print("INVALID")
    exit(1)
count = 0
sum = 0
for i in range(1, len(num) + 1):
    n = int(num[-i])
    count += 1
    if count % 2 == 0:
        n *= 2
        if n > 9:
            sum += (n // 10) + (n % 10)
        else:
            sum += n
    else:
        sum += n
if sum % 10 != 0:
    print("INVALID")
    exit(2)
n = int(num[0] + num[1])
if n in [34, 37] and len(num) in [14, 15]:
    print("AMEX")
elif n in range(50, 56) and len(num) in [15, 16]:
    print("MASTERCARD")
elif n in range(39, 51) and len(num) in [12, 13, 15, 16]:
    print("VISA")
else:
    print("INVALID")
    exit(3)
