import re
import struct
import os
from subprocess import Popen, check_output, PIPE
from sys import stdout
from glob import glob

functions = { }

if not os.path.exists('bin'):
    os.makedirs('bin')

# load functions from map file
with open('cross_f.map') as file:
    lines = file.read().split('\n')
    for line in lines:
        m = re.match(' 0002:([0-9A-F]{8})\s+(.*)', line)
        if m == None: continue

        name = m.group(2)
        if name.startswith('nullsub'): continue
        if name.startswith('jpt_'): continue
        if name.startswith('def_'): continue
        if name.startswith('j_'): continue
        if ' ' in name: continue

        name = re.sub('[^a-zA-Z0-9_]', '_', name)

        functions[name] = int(m.group(1), 16)

source_files = [os.path.basename(p).split('.')[0] for p in glob('src/*.s')]

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
codes = []
current_code = None

output = ''
data = check_output(['powerpc-eabi-objdump', '-D', 'bin/out.elf'])
lines = data.split('\r\n')

for line in lines:
    m = re.match('Disassembly of section \.(.*):', line)
    if m != None:
        if current_code != None: codes.append(current_code)
        current_code = (int(m.group(1)[2:], 16), [])
        continue

    m = re.match(' ?[0-9a-f]{7,8}:\t(.. .. .. .. )\t(.*)', line)

    if m != None:
        current_code[1].append(int(m.group(1).replace(' ', ''), 16));
        continue

codes.append(current_code)

def uint32(i):
    return struct.pack('>L', i)

with open('0005000010144F00.mods', 'wb') as f:
    f.write('MODS'.encode('ascii'))
    f.write(uint32(1))
    f.write(uint32(len(codes)))
    f.write(uint32(0))
    for code in codes:
        f.write(uint32(0))
        f.write(uint32(code[0]))
        f.write(uint32(len(code[1])))
        for instr in code[1]:
            f.write(uint32(instr))
