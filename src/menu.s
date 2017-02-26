code 0x0D3FA768, "never lock home menu"
	li r3, 1

code 0x0C24B1A4, "boot to menu"
	li r3, 6

# button sequence tweaks
code 0x0CC88148, "smash tour -> css"
	b 0x144
# code 0x0CC88278, "notices -> softlock :v" # wait, what? why?
# 	b 0x14C

# 0x0CC880C0 _ 304

# # ????
# code 0x0C678B58, ""
# 	nop
# 	nop
# 	b 0x3C


# 11FA0078
# 008: gameMode
# 02C: timeLimit
# 034: stockCount
# 048: customFighters
# 080: launchRate
# 0F0: stockTimeLimit
# 144: scoreDisplay