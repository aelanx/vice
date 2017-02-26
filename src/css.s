code 0x0C93FC10, "unlock all dlc"
  li r3, 1

# code 0x0C8BF38C, "disable miis (borked)"
#   li r4, 0

code 0x0D3F8998, "allow disabled names"
  li r3, 1
  blr

## wtf is this?
# code 0x0C049774
#   li r31, 3

# code 0x0D0A9120, "8-player, all stages"
#   li r3, 8
#   blr
