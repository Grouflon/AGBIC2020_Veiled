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
{!The person has disappeared through the door.}
The house hall spreads in front of you.
-> choice
= choice
+ {!finger_hall_door_opened} [Inspect the door <left_door>]
  The door is locked from the other side.
  -> choice

+ {finger_hall_door_opened} [Go through the door <left_door>]
  -> Finger_Bottom

+ [Inspect the door <right_door>]
  The door is broken. You won't go any further this way.
  -> choice

+ {!hall_scanner_used} [{Follow the man|Inspect the electronic lock} <lab_door>]
  The door seems electronically locked. There is a small device besides it.
  -> Hall_Scanner

+ {hall_scanner_used} [Rush through the door <lab_door>]
  Not written yet
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
This kind of technology feels out of place here.
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
      Seems like some sort of biometric device.
      Apparently it needs to scan your eye and your finger.
  }
  -> choice

+ {can_use_scanner} [Use the eye and finger <device>]
  ~ hall_scanner_used = true
  Ho lord, what are you doing...
  #variant: Used
  Pressing the severed body parts onto the device seems to be putting the house in motion.
  Suddenly the door opens.
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
    A wide balcony.
}
-> choice
= choice
+ [Go down the stairs <stairs>]
  -> Hall_Main

+ {!eye_fleeing_blob}[Inspect the door <left_door>]
  The door is locked from the other side.
  You knock to the door but no one answers.
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
