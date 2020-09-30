VAR finger_hall_door_opened = false
VAR finger_bathroom_opened = false
VAR finger_inspected_door = false
VAR finger_scissors_taken = false
VAR finger_inspected_hand = false
VAR finger_cut = false
VAR finger_octopus_appeared = false

=== Finger_Bottom ===
// interactions: door, hole, stairs
// variants: Opened
#location: Finger_Bottom
{
  - finger_hall_door_opened:
    #variant: Open
}
{!You fall into a small chamber.}
The small lounge continues up to a small staircase.
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
  {!You engage through the stairs.}
  -> Finger_Stairs_Up

=== Finger_Stairs_Up ===
// interactions: back, up
// variant: Blob_01, Blob_02, Blob_03
// sequences : Blob
#location: Finger_Stairs_Up
The stairs climb up to the first floor.
-> choice
= choice
+ [Down the stairs <back>]
  -> Finger_Bottom
+ [Up the stairs <up>]
  -> Finger_Corridor_Up

=== Finger_Stairs_Down ===
// interactions: back, down
// variant: Blob_01, Blob_02, Blob_03
// sequences : Blob
The stairs leads back to the lounge.
-> choice
= choice
+ [Down to the lounge <down>]
  -> Finger_Bottom

+ [Back to the first floor <back>]
  -> Finger_Corridor_Up

=== Finger_Corridor_Up ===
// interactions: back, right_door, front_door
// variant: Blob_01, Blob_02, Blob_03
// sequences : Blob
#location: Finger_Corridor_Up
A long corridor spreads before you.
-> choice
= choice
+ [Back to the stairs <back>]
  -> Finger_Stairs_Up

+ [Enter the room <right_door>]
  {!You slowly push the door and enter the room.}
  //-> Kid_Curtain
  -> choice

+ [Explore forward <front_door>]
  {!The corridor turns and opens up into a larger room.}
  -> Finger_Bedroom_Far

=== Finger_Bedroom_Far ===
// interactions: back, shelves, door
// variant: Open, Blob_01, Blob_02, Blob_03
// sequences : Blob
#location: Finger_Bedroom_Far
{
  - finger_bathroom_opened:
    #variant: Open
}
Strange room.
It looks like a bedroom but all furnitures are gone.
-> choice
= choice
+ [Back to the corridor <back>]
  -> Finger_Corridor_Up

+ [Examine the shelves <shelves>]
  Lots of books complicated books about medecine, anatomy, history and so on.
  The people living here must be quite educated.
  -> choice

+ [Inspect the door <door>]
  {!You approach the closed door.}
  -> Finger_Bedroom_Close

=== Finger_Bedroom_Close ===
// interactions: back, door, trinket
// variant: Open
#location: Finger_Bedroom_Close
{
  - finger_bathroom_opened:
    #variant: Open
    The door to the bathroom.
  - else:
    A wooden sliding door.
}
-> choice
= choice
~ temp can_open_door = finger_inspected_door && (inventory ? tarot)
+ [Back to the room <back>]
  -> Finger_Bedroom_Far

+ [Examine the trinket <trinket>]
  A weird trinket.
  -> choice

+ {!finger_bathroom_opened && !can_open_door}[Inspect the door <door>]
  ~ finger_inspected_door = true
  The door seems loosely locked from the other side. You can distinguish the silouhette of the lock between the two doors.
  Maybe you could unlock it with a thin object.
  -> choice

+ {!finger_bathroom_opened && can_open_door}[Lift the lock <door>]
  You insert the card between the two doors.
  ~ finger_bathroom_opened = true
  #variant: Open
  After some fiddling, you finally manage to lift the lock and open the door.
  A horrid stench coming from the room assault you.
  -> choice

+ {finger_bathroom_opened} [Enter the room <door>]
  The smell is unbearable but you have to press on.
  -> Finger_Bathroom

=== Finger_Bathroom ===
// interactions: back, tub, mirror
// variants: Blob_01, Blob_02, Blob_03
// sequences: Blob
#location: Finger_Bathroom
Something terrible happened here.
-> choice
= choice
+ [Back to the door <back>]
  -> Finger_Bedroom_Close

+ [Look at the mirror <mirror>]
  There is something lying in the tub.
  -> choice

+ [Inspect the tub <tub>]
  You gather your mental strength and look at the tub.
  -> Finger_Tub

=== Finger_Tub ===
// interactions: back, tub, hand, cissors
// variant: No_Scissors, Blob_01, Blob_02, Blob_03
#location: Finger_Tub
{
  -finger_scissors_taken:
    #variant: No_Scissors
}
Someone is lying inside the tub, lifeless.
-> choice
= choice
+ [Back to the bathroom <back>]
  -> Finger_Bathroom

+ [Examine the tub <tub>]
  Why did she do that?
  What is happening here?
  -> choice

+ {!finger_scissors_taken} [Take the scissors <scissors>]
What are you going to do with those scissors?
#variant: No_Scissors
~ inventory += (scissors)
~ finger_scissors_taken = true
You can't believe that you are thinking about this.
-> choice

+ [Examine the hand <hand>]
  You lean closer to the hand.
  -> Finger_Hand

=== Finger_Hand ===
// interactions: back, hand
// variant: Cut
#location: Finger_Hand
{
  -finger_cut:
    #variant: Cut
}
The hand of the dead person is hanging from the side of the tub.
Its skin is dark and reminds you of the creature.
-> choice
= choice
~ temp can_cut_finger = finger_inspected_hand && (inventory ? scissors)
+ [Back to the tub <back>]
  -> Finger_Tub

+ {!can_cut_finger} [Inspect the hand <hand>]
  ~ finger_inspected_hand = true
  If this hand belongs to the owner, it may work on the electronic lock.
  If only you had some way to take it with you.
  -> choice

+ {can_cut_finger} [Cut off the finger <hand>]
  The horror of the situations is numbing.
  ~ inventory += (finger)
  ~ finger_cut = true
  #variant: Cut
  The blade cuts through the flesh easily.
  This is not the consistance of human flesh.
  -> Finger_Tub_Chase

// since there is no much choice it is simpler to duplicate the rooms and make new declarations for the whole chase
=== Finger_Tub_Chase ===
#location: Finger_Tub
#variant: Blob_01
The poor victim suddenly disappears inside the tub.
-> choice
= choice
+ {finger_octopus_appeared}[Back to the bathroom <back>]
  -> Exit

+ {finger_octopus_appeared}[Back to the bathroom <back_2>]
  You step back, paralized by fear.
  -> Finger_Bathroom_Chase

+ {!finger_octopus_appeared}[Look inside the tub <whole_tub>]
  Is she gone?
  #variant: Blob_02
  #sequence: Blob
  ~ finger_octopus_appeared = true
  A dark mass starts to grow and a tentacle emerges from the tub.
  -> choice

+ {finger_octopus_appeared}[Look at the creature <whole_tub>]
  What is that thing? You need to get out of here fast.
  -> choice

= Blob_03
#variant: Blob_03
Another tentacle burst out of the dark mass and swings at you. You dodged this one but may not be so lucky next time.
-> choice

= Exit
You step back, paralized by fear.
-> Finger_Bathroom_Chase

=== Finger_Bathroom_Chase ===
#location: Finger_Bathroom
#variant: Blob_01
#sequence: Blob
It keeps coming out.
Where is all this coming from?
->choice
= choice
+ [Look at the creature <tub>]
  So scary.
  -> choice

+ [Look in the mirror <mirror>]
  This keeps coming out, how is this possible ?
  -> choice

+ [Back to the room <back>]
  You stumble out of the bathroom.
  -> Finger_Bedroom_Chase

= Blob_02
#variant: Blob_02
More tentacles.
-> choice

= Blob_03
#variant: Blob_03
Too much tentacles.
-> choice

= Dead
It grabbed you, you're dead
-> end

=== Finger_Bedroom_Chase ===
#location: Finger_Bedroom_Far
#variant: Blob_01
#sequence: Blob
It knows you are here.
It's coming after you now.
-> choice
= choice
+ [Rush to the corridor <back>]
  You face back and start to run.
  -> Finger_Corridor_Chase

+ [Look at the creature <door>]
  So scary.
  -> choice

= Blob_02
#variant: Blob_02
More tentacles.
-> choice

= Blob_03
#variant: Blob_03
Too much tentacles.
-> choice

= Dead
It grabbed you, you're dead
-> end

=== Finger_Corridor_Chase ===
#location: Finger_Corridor_Down
#sequence: Blob
Is it still following you?
-> choice
= choice
+ [Back to the room <back>]
  There is no way you are going back there.
  -> choice

+ [Run to the stairs <stairs>]
  Out of breath, you rush down the stairs.
  -> Finger_Stairs_Down_Chase

= Blob_01
#variant: Blob_01
It is still after you.
-> choice

= Blob_02
#variant: Blob_02
More tentacles.
-> choice

= Blob_03
#variant: Blob_03
Too much tentacles.
-> choice

= Dead
It grabbed you, you're dead
-> end

=== Finger_Stairs_Down_Chase ===
#location: Finger_Stairs_Down
As you begin your descent, a tentacle grabs your feet.
You lose balance and fall down the stairs.
-> Finger_Stairs_Up_Chase

=== Finger_Stairs_Up_Chase ===
#location: Finger_Stairs_Up
#variant: Blob_01
#sequence: Blob
It's coming after you.
-> choice
= choice
+ [Look at the creature <up>]
  So Scary.
  -> choice

// Peut-être qu'on peut faire le relevage en 2 temps ?
+ [Stand up and run <back>]
  You get back on your feet and run to the lounge.
  -> Finger_Bottom_Chase

= Blob_02
#variant: Blob_02
More tentacles.
-> choice

= Blob_03
#variant: Blob_03
Too much tentacles.
-> choice

= Dead
It grabbed you, you're dead
-> end

=== Finger_Bottom_Chase ===
#location: Finger_Bottom
#variant: Blob_01
#sequence: Blob
You almost reached the hall.
-> choice
= choice
+ [Look at the creature <stairs>]
  So scary.
  -> choice

+ [Look at the hole <hole>]
  Please, make that the other one won't pop out.
  -> choice

+ [Flee to the hall <door>]
  You boom inside the hall and shut the door behind you.
  -> Hall_Main

= Blob_02
#variant: Blob_02
More tentacles.
-> choice

= Blob_03
#variant: Blob_03
Too much tentacles.
-> choice

= Dead
It grabbed you, you're dead
-> end
