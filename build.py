import re
from os import path, linesep
from subprocess import Popen, check_output, PIPE
from sys import stdout
from glob import glob
import struct

functions = {
    'sss_getCursorType': 0x0C98C738,
    'isButtonDown': 0x0D09884C
}

source_files = [path.splitext(path.basename(p))[0] for p in glob('src/*.s')]

# assemble
for name in source_files:
    with open('src/'+name+'.s', 'r') as file:
        file_data = file.read()
        file_data = '.include "inc/common.s"\n' + file_data + '\n'

        p = Popen(['powerpc-eabi-as', '-o', 'bin/'+name+'.o', '--'], stdin=PIPE)
        p.communicate(file_data)

object_files = ['bin/'+name+'.o' for name in source_files]

# collect section addresses
sections = []
for obj_file in object_files:
    data = check_output(['powerpc-eabi-objdump', '-D', obj_file])
    lines = data.split('\r\n')
    for line in lines:
        m = re.match('Disassembly of section \.(.*):', line)
        if m != None:
            sections.append(m.group(1))

# build linker script
with open('bin/link.ld', 'w') as file:
    for func_name in functions:
        file.write('%s = 0x%08X;\n' % (func_name, functions[func_name]))

    file.write('\nSECTIONS {')
    for section in sections:
        file.write('\n\t. = %s;\n' % section)
        file.write('\t.%s : {}\n' % section)
    file.write('}\n')

# link objects
check_output(['powerpc-eabi-ld', '-T', 'bin/link.ld', '-o', 'bin/out.elf'] + object_files)

# build final output
data = check_output(['powerpc-eabi-objdump', '-D', 'bin/out.elf'])

codes = []
currentCode = None

lines = data.split(linesep)
for line in lines:
    # start of code
    m = re.match('Disassembly of section \.(.*):', line)
    if m != None:
        if currentCode != None:
            codes.append(currentCode)

        currentCode = {
            'address': m.group(1)[2:],
            'instructions': []
        }
        continue

    # instruction
    m = re.match(' [0-9a-f]{7}:\t(.. .. .. .. )\t(.*)', line)
    if m != None:
        currentCode['instructions'].append(m.group(1).replace(' ', ''))
        continue

def writeu32be (file, value):
    file.write(struct.pack(">I", value))

#
with open('bin/codes.bin', 'w') as file:
    writeu32be(file, 0x4D4F4453) # magic "MODS"
    writeu32be(file, 1) # version
    writeu32be(file, len(codes))
    writeu32be(file, 0) # pad

    for code in codes:
        writeu32be(file, 0) # type
        writeu32be(file, int(code['address'], 16))
        writeu32be(file, len(code['instructions']))

        for inst in code['instructions']:
            writeu32be(file, int(inst, 16))

