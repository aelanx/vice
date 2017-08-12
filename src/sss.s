# # TODO: fix start button
# # TODO: disable stricken stages (works for 8-player)
# code 0x0C24694C, "stage striking 1"
#   b new_end
#
# code 0x0C69BC80, "stage striking 2"
# new_end:
#   lwz r3, 0x160(r27)
#   bl sss_getCursorType
#   li r14, 0
#   cmpwi r3, 0x02 # return if cursor == my music
#   beq _end
#
#   cmpwi r3, 0x00
#   bne _banSelectedStage
#   li r14, 1
#
#   _banSelectedStage:
#     lwz r3, 0x148(r27)
#     li r4, BUTTON_C_UP
#     mr r5, r4
#     bl isButtonDown
#     cmpwi r3, 0x00
#     beq _unbanSelectedStage
#       mr r3, r28
#       mr r4, r14
#       li r5, 0
#       bl setStageBanState
#
#   _unbanSelectedStage:
#     lwz r3, 0x148(r27)
#     li r4, BUTTON_C_DOWN
#     mr r5, r4
#     bl isButtonDown
#     cmpwi r3, 0x00
#     beq _defaultBanList
#       mr r3, r28
#       mr r4, r14
#       li r5, 8
#       bl setStageBanState
#
#   _defaultBanList:
#     lwz r3, 0x148(r27)
#     li r4, BUTTON_DPAD_UP
#     mr r5, r4
#     bl isButtonDown
#     cmpwi r3, 0x00
#     beq _clearBans
#       li r8, 0
#       mr r4, r14
#       li r5, 0
#
#       _loop0:
#         bl setStageBanState
#         addi r8, r8, 1
#         mr r3, r8
#         cmplwi r3, NUM_STAGES
#         ble _loop0
#
#   _clearBans:
#     lwz r3, 0x148(r27)
#     li r4, BUTTON_DPAD_DOWN
#     mr r5, r4
#     bl isButtonDown
#     cmpwi r3, 0x00
#     beq _end
#       li r8, 0
#       mr r4, r14
#       li r5, 8
#
#       _loop1:
#         bl setStageBanState
#         addi r8, r8, 1
#         mr r3, r8
#         cmplwi r3, NUM_STAGES
#         ble _loop1
#
#   # _testThing:
#   #   lwz r3, 0x148(r27)
#   #   li r4, BUTTON_C_DOWN
#   #   li r5, 0
#   #   bl isButtonDown
#   #   cmpwi r3, 0x00
#   #   beq _end
#   #     li r8, 0
#   #     li r3, 0
#
#   #     _loop2:
#   #       bl getStageParamEntry
#
#   #       lbz r5, 0x04(r3)
#   #       xori r5, r5, 1
#   #       stb r5, 0x04(r3)
#
#   #       addi r8, r8, 1
#   #       mr r3, r8
#   #       cmplwi r3, NUM_STAGES
#   #       ble _loop2
#
#   _end:
#     lmw r25, 0x44(r1)
#     lwz r0, 0x64(r1)
#     mtlr r0
#     addi r1, r1, 0x60
#     blr
#
# ######
# getStageParamEntry: # r3:stageId
#     lis r12, 0x1080
#     lwz r12, -0x5E78(r12)
#     addi r13, r12, 4
#
#     cmplwi    r3, NUM_STAGES
#     lwz       r10, 0(r13)
#     li        r9, -1
#     ble       loc_30A916C
#     lwz       r12, 8(r10)
#     cmpwi     r12, 0
#     li        r11, 0
#     beq       loc_30A917C
#     lwz       r8, 0xC(r10)
#     mtctr     r12
#     addi      r8, r8, -0x54
#
#   loc_30A914C:
#     lwzu      r12, 0x54(r8)
#     cmplw     r12, r3
#     bne       loc_30A9160
#     mr        r9, r11
#     b         loc_30A917C
#
#   loc_30A9160:
#     addi      r11, r11, 1
#     bdnz      loc_30A914C
#     b         loc_30A917C
#
#   loc_30A916C:
#     lwz       r12, 8(r10)
#     cmplw     r3, r12
#     bge       loc_30A917C
#     mr        r9, r3
#
#   loc_30A917C:
#     li        r12, -1
#     xor       r11, r9, r12
#     addic     r12, r11, -1
#     subfe.    r12, r12, r11
#     lwz       r12, 0xC(r10)
#     bne       _getStageParamEntry_end
#     li        r9, 1
#
#   _getStageParamEntry_end:
#     mulli     r11, r9, 0x54
#     add       r12, r12, r11
#     mr        r3, r12
#     blr
#
# setStageBanState: # r3:stageId, r4:stageMode, r5:state
#   mflr r7
#   bl getStageParamEntry
#
#   cmpwi     r4, 0
#   beq       _stageIsOmega
#   stw       r5, 0x24(r3)
#   b _setStageBanState_end
#
#   _stageIsOmega:
#     stw       r5, 0x28(r3)
#
#   _setStageBanState_end:
#     mtlr r7
#     blr
