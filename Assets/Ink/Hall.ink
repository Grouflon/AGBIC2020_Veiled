VAR hall_scanner_used = false
VAR hall_scanner_inspected = false

=== Hall_TopDown ===
// variant: No_Guy
#location: Hall_TopDown
As you enter, you see someone rushing through the door just below you.
#variant: No_Guy
Who was he ?
You run after him.
-> Hall_Main

=== Hall_Main ===
// left_door, right_door, lab_door, stairs
#location: Hall_Main
{
  -finger_octopus_appeared:
    {!You really hope it don't know how to open doors.}
  -else:
    {!The man has disappeared through the door.}
}
{
  -hall_scanner_used:
    The door is now open.
  -else:
    You are in the main hall.
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

+ [Inspect the door <right_door>]
  You grasp the handle. The door seem to weep as you push it open.
  -> choice

+ {!hall_scanner_used} [{Follow the man|Inspect the biometric lock} <lab_door>]
  You throw yourself at the door in vain.
  -> Hall_Scanner

+ {hall_scanner_used} [Follow the man <lab_door>]
  The result of using the scanners is a bit messy but it worked.
  -> end

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
~ hall_scanner_inspected = true
You notice a small box besides it. This high tech device feels out of place here.
-> choice
= choice
~ temp can_use_scanner = hall_scanner_inspected && (inventory ? eyeball) && (inventory ? finger)
+ [Back to the hall <back>]
  -> Hall_Main

+ {!can_use_scanner} [Inspect the device <device>]
  {
    -inventory ? eyeball:
      The eye is not enough to operate the device.
      You also need a fingerprint.
    -else:
      It seems like some sort of biometric device.
      Apparently it needs to scan your eye and your finger.
  }
  -> choice

+ {can_use_scanner} [Use the eye and finger <device>]
  ~ hall_scanner_used = true
  Ho lord, what are you doing...
  #variant: Used
  You press both eye and finger onto the scanner. 
  You squish them hard and you eventually get a reading.
  You hear the door unlock.
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
  {The door opens|}
  -> Eye_Bedroom

+ {eye_fleeing_blob}[Inspect the door <left_door>]
  The creature came from here.
  You would rather not know what is inside.
  -> choice

+ {eye_fleeing_blob}[Inspect the door <front_door>]
  There is no way you are going back there.
  -> choice
