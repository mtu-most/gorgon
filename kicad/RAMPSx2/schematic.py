#!/usr/bin/python3
import pcb

pins = {
	"AREF":pcb.IN,
	"GND3":pcb.POWER_GND,
	"RST":pcb.IN,
	"3V3":pcb.POWER_IN,
	"5V":pcb.POWER_IN,
	"GND1":pcb.POWER_GND,
	"GND2":pcb.POWER_GND,
	"V_IN":pcb.POWER_OUT,
	"GND4":pcb.POWER_GND,
	"GND5":pcb.POWER_GND,
	"5V_4":pcb.POWER_IN,
	"5V_5":pcb.POWER_IN,
}

for p in range(54):
	pins[p] = pcb.BI
for p in range(16):
	pins['AD%d' % p] = pcb.BI

RAMPS=pcb.Part("arduino_shields:ARDUINO_MEGA_SHIELD", pins)("RAMPS")
RAMPS.sparse()

pins = {x:pcb.BI for x in range(3,19)}
pins[1] = pcb.POWER_OUT
pins[2] = pcb.POWER_GND

MOTORHEADER = pcb.Part("Pin_Headers:Pin_Header_Straight_1x18", pins)("MOTOR_HEADER")

pins = {x:pcb.BI for x in range(1,11)}
pins[1] = pcb.POWER_OUT
pins[2] = pcb.POWER_GND

TEMPHEADER = pcb.Part("Pin_Headers:Pin_Header_Straight_2x05", pins)("TEMP_HEADER")

#gnd = pcb.Net("ground")
#for p in range(1,6):
#	RAMPS['GND%d' % p] = gnd

# AUX-4
RAMPS['5V'] = MOTORHEADER[1], '5V'
MOTORHEADER[2] = RAMPS["GND2"], "GND"
for i, p in enumerate(("AD0", "AD1", 38, "AD6", "AD7", 48, 46, 36, 34, 28, 26, 18, 15, 14, 2, 3)):
	RAMPS[p] = MOTORHEADER[i + 3], p

# Enable bus
for p in ("AD2", "AD8", 24, 30):
	RAMPS[p] = RAMPS[38]

TEMPHEADER[1] = None
TEMPHEADER[2] = None
TEMPHEADER[3] = RAMPS["AD13"], "AD13"
TEMPHEADER[4] = RAMPS[19], 19
TEMPHEADER[5] = RAMPS["AD14"], "AD14"
TEMPHEADER[6] = RAMPS[8], 8
TEMPHEADER[7] = None
TEMPHEADER[8] = RAMPS[9], 9
TEMPHEADER[9] = RAMPS["AD15"], "AD15"
TEMPHEADER[10] = RAMPS[10], 10

pcb.write("RAMPSx2")
