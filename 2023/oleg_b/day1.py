'''
the elf text should be inside the file "elf_text.txt"
the calibration number printed at the code finish
part 1
'''

import re


elf_file = 'elf_text.txt'
calibration_val = 0

with open(elf_file) as elf_txt:
    for line in elf_txt.readlines():
        first_number = int(re.search(r'\d+', line).group(0)[0]) * 10
        last_number = int(re.search(r'\d+', line[::-1]).group(0)[0])
        full_number = first_number + last_number
        calibration_val += full_number

print(calibration_val)
