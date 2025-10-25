def grade(text):
    words = 1
    sentences = 0
    letters = 0
    for i in range(len(text)):
        if text[i] == " " and text[i - 1] != " ":
            words += 1
        elif (text[i] == "." and text[i - 1] != ".") or (text[i] == "?" and text[i - 1] != "?") or (text[i] == "!" and text[i - 1] != "!"):
            sentences += 1
        if text[i].isalpha():
            letters += 1
    L = (letters / words) * 100
    S = sentences
    S = (S / words) * 100
    index = (0.0588 * L) - (0.296 * S) - 15.8
    return index


text = input("Text: ")
score = round(grade(text), 0)
if score > 1 and score < 16:
    print(f"Grade {score}")
elif score <= 1:
    print(f"Before Grade 1")
else:
    print(f"Grade 16+")
