VAR hall_scanner_used = false
VAR hall_scanner_seen = false
VAR hall_scanner_inspected = false

=== Hall_TopDown ===
// variant: No_Guy
#location: Hall_TopDown
As you enter, you see someone rushing through the door just below you.
#variant: No_Guy
Who was he?
You run after him.
-> Hall_Main

=== Hall_Main ===
// left_door, right_door, lab_door, stairs
#location: Hall_Main
#music: lvl0
#crossfade: 3.0
{
  -hall_scanner_used:
    {!The result of using the scanners is a bit messy but it worked. You hear the door unlock.}
    Nothing stands between the man and you now.
  -finger_octopus_appeared:
    {!You hear the creature crashing on the door.}
    {!Thankfully it doesn't open from this side.}
    You are in the main hall.
  -hall_scanner_seen:
    You are in the main hall.
  -else:
    The man has disappeared through the door in front of you.
	Surely he must know something.
}
-> choice
= choice
+ {!finger_octopus_appeared && !finger_hall_door_opened} [Inspect the door <left_door>]
  The door is locked from the other side.
  -> choice

+ {!finger_octopus_appeared && finger_hall_door_opened} [Go through the door <left_door>]
  -> Finger_Bottom

+ {finger_octopus_appeared} [Go through the door <left_door>]
  The creature is surely still lurking behind. There is no way you are going back there.
  -> choice

+ [Open the door <right_door>]
  {!You grasp the cold handle. The door seem to weep as you push it open.}
  -> Dinner_View02

+ {!hall_scanner_seen} [Follow the man <lab_door>]
  You throw yourself at the door in vain.
  It is desperately shut, but as you inspect it, you find a strange contraption besides it.
  -> Hall_Scanner

+ {hall_scanner_seen && !hall_scanner_used} [Inspect the biometric lock <lab_door>]
  -> Hall_Scanner

+ {hall_scanner_used} [Follow the man <lab_door>]
  You dive into the passage that just opened.
  -> End_Stairs

+ [Climb the stairs <stairs>]
  You may find some leads on the first floor.
  -> Hall_FirstFloor

=== Hall_Scanner ===
// interactions: back, device
// variants: Used
#location: Hall_Scanner
{
  - hall_scanner_used:
    #variant: Used
}
~ hall_scanner_seen = true
There is a small box besides the door.
This high tech device feels out of place here.
-> choice
= choice
~ temp can_use_scanner = hall_scanner_inspected && (inventory ? eyeball) && (inventory ? finger)
+ [Back to the hall <back>]
  -> Hall_Main

+ {!can_use_scanner} [Inspect the device <device>]
  {
    -hall_scanner_inspected && (inventory ? eyeball):
      The eye is not enough to operate the device.
      You also need a fingerprint.
    -else:
      ~hall_scanner_inspected = true
      It seems like some sort of biometric device.
      Apparently it needs to scan your eye and your finger.
  }
  -> choice

+ {can_use_scanner} [Use the eye and finger <device>]
  ~ hall_scanner_used = true
  Ho lord, what are you doing?
  #variant: Used
  You press both eye and finger onto the scanner.
  ~ inventory -= (eyeball)
  ~ inventory -= (finger)
  You squish them hard and you eventually get a reading.
  -> Hall_Main

=== Hall_FirstFloor ===
// interactions: stairs, left_door, front_door
// variants: Slimed
#location: Hall_FirstFloor
{
  -eye_fleeing_blob:
    #variant: Slimed
    What a mess.
  -else:
    What a stark constrast. The persian carpet on the floor feels rather nice but the ceiling however is falling off.
}
-> choice
= choice
+ [Go down the stairs <stairs>]
  -> Hall_Main

+ {!eye_fleeing_blob}[Inspect the door <left_door>]
  The door is locked from the other side. You hear humming coming from the room.
  You knock on the door but no one answers.
  -> choice

+ {!eye_fleeing_blob}[Inspect the door <front_door>]
  {The door opens.|}
  -> Eye_Bedroom

+ {eye_fleeing_blob}[Inspect the door <left_door>]
  The creature came from here.
  You would rather not know what is inside.
  -> choice

+ {eye_fleeing_blob}[Inspect the door <front_door>]
  There is no way you are going back there.
  -> choice
