.set r0, 0
.set r1, 1
.set r2, 2
.set r3, 3
.set r4, 4
.set r5, 5
.set r6, 6
.set r7, 7
.set r8, 8
.set r9, 9
.set r10, 10
.set r11, 11
.set r12, 12
.set r13, 13
.set r14, 14
.set r15, 15
.set r16, 16
.set r17, 17
.set r18, 18
.set r19, 19
.set r20, 20
.set r21, 21
.set r22, 22
.set r23, 23
.set r24, 24
.set r25, 25
.set r26, 26
.set r27, 27
.set r28, 28
.set r29, 29
.set r30, 30
.set r31, 31

.macro code addr, name=""
.section ".\addr"
.endm

BUTTON_A           = 0x00001
BUTTON_B           = 0x00002
BUTTON_DPAD_UP     = 0x00004
BUTTON_DPAD_RIGHT  = 0x00008
BUTTON_DPAD_DOWN   = 0x00010
BUTTON_DPAD_LEFT   = 0x00020
BUTTON_STICK_UP    = 0x00040
BUTTON_STICK_RIGHT = 0x00080
BUTTON_STICK_DOWN  = 0x00100
BUTTON_STICK_LEFT  = 0x00200
BUTTON_C_UP        = 0x00400
BUTTON_C_RIGHT     = 0x00800
BUTTON_C_DOWN      = 0x01000
BUTTON_C_LEFT      = 0x02000
# ????             = 0x04000
BUTTON_L           = 0x08000
BUTTON_R           = 0x10000
BUTTON_START       = 0x20000

NUM_STAGES = 0xC7
