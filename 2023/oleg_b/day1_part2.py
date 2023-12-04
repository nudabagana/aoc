numbers_match = {'1': 1,
                 '2': 2,
                 '3': 3,
                 '4': 4,
                 '5': 5,
                 '6': 6,
                 '7': 7,
                 '8': 8,
                 '9': 9,
                 'one': 1,
                 'two': 2,
                 'three': 3,
                 'four': 4,
                 'five': 5,
                 'six': 6,
                 'seven': 7,
                 'eight': 8,
                 'nine': 9}

elf_file = 'elf_text.txt'

calibration_val = 0

with open(elf_file) as elf_txt:
    for line in elf_txt.readlines():
        found_left = {line.find(x): numbers_match[x] for x in numbers_match.keys() if line.find(x) >= 0}
        found_right = {line.rfind(x): numbers_match[x] for x in numbers_match.keys() if line.find(x) >= 0}
        first_number = int(found_left[min(found_left.keys())]) * 10
        last_number = int(found_right[max(found_right.keys())])
        full_number = first_number + last_number
        calibration_val += full_number

print(calibration_val)
