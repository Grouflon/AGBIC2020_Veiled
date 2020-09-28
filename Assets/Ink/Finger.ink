VAR finger_hall_door_opened = false

=== Finger_Bottom ===
// interactions: door, hole, stairs
// variants: Opened
#location: Finger_Bottom
{
  - finger_hall_door_opened:
    #variant: Open
}
{!You fall into a small chamber.}
The room continues up to a small staircase.
-> choice
= choice
+ {!finger_hall_door_opened} [Unlock the door <door>]
  The lock is accessible from this side.
  #variant: Open
  You open the door.
  ~ finger_hall_door_opened = true
  -> choice

+ {finger_hall_door_opened} [{Go through the door|Go to the hall} <door>]
  {!It leads to the hall.}
  -> Hall_Main

+ [Look at the hole <hole>]
  You came from here.
  Let's hope the thing won't follow you.
  -> choice

+ [Climb up the stairs <stairs>]
  Not written yet
  -> choice
