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
{!You fall hard into an unknown room.}
The small lounge seems to lead up to a steep staircase.
-> choice
= choice
+ {!finger_hall_door_opened} [Unlock the door <door>]
  You notice the lock on the door was on.
  #variant: Open
  You unlock it and open the door.
  ~ finger_hall_door_opened = true
  -> choice

+ {finger_hall_door_opened} [{Go through the door|Go to the hall} <door>]
  {!It leads back to the hall.}
  -> Hall_Main

+ [Look at the hole <hole>]
  That's where you came from.
  Let's hope the thing won't follow you.
  -> choice

+ [Climb up the stairs <stairs>]
  {!You cautiously start to climb. It's pretty steep.}
  -> Finger_Stairs_Up

=== Finger_Stairs_Up ===
// interactions: back, up
// variant: Blob_01, Blob_02, Blob_03
// sequences : Blob
#location: Finger_Stairs_Up
The stairs leads up to the first floor.
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
#music: lvl0
#crossfade: 3.0
A long corridor spreads before you.
{!You try to be quiet but the flooring is squeaky.}
-> choice
= choice
+ [Back to the stairs <back>]
  -> Finger_Stairs_Up

+ [Enter the room <right_door>]
  {!You slowly push the door and enter the room.}
  -> Kid

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
It looks like a bedroom but the main furniture are gone.
-> choice
= choice
+ [Back to the corridor <back>]
  -> Finger_Corridor_Up

+ [Examine the shelves <shelves>]
  And odd collection of mismatched books and artefact.
  You pick one but can't decipher the language.
  -> choice

+ [Inspect the door <door>]
  {!You approach the closed door.}
  -> Finger_Bedroom_Close

=== Finger_Bedroom_Close ===
// interactions: back, door, trinket
// variant: Open
#location: Finger_Bedroom_Close
#music: lvl0
#crossfade: 3.0
{
  - finger_bathroom_opened:
    #variant: Open
    The door to the bathroom.
  - else:
    A wooden sliding door. A beautiful mural is painted on it.
}
-> choice
= choice
~ temp can_open_door = finger_inspected_door && (inventory ? tarot)
+ [Back to the room <back>]
  -> Finger_Bedroom_Far

+ [Examine the trinket <trinket>]
  It's a large sea shell with fragrant beads inside.
  -> choice

+ {!finger_bathroom_opened && !can_open_door}[Inspect the door <door>]
  ~ finger_inspected_door = true
  The door seems loosely locked from the other side. You can distinguish the silouhette of a simple latch between the two doors.
  You could probably push it up with a thin object.
  -> choice

+ {!finger_bathroom_opened && can_open_door}[Lift the lock <door>]
  You insert the card between the two doors.
  ~ finger_bathroom_opened = true
  ~ inventory -= (tarot)
  #variant: Open
  You gently push the latch up and slide open the door.
  You're immediatly seized by a strong acrid smell.
  -> choice

+ {finger_bathroom_opened} [Enter the room <door>]
  The memory of the creature flash before your eyes but you have to press on.
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
  In the reflection, you see something lying in the tub.
  -> choice

+ [Inspect the tub <tub>]
  You gather your mental strength and slowly peak at the tub.
  -> Finger_Tub

=== Finger_Tub ===
// interactions: back, tub, hand, cissors
// variant: No_Scissors, Blob_01, Blob_02, Blob_03
#location: Finger_Tub
#music: lvl1
#crossfade: 3.0
{
  -finger_scissors_taken:
    #variant: No_Scissors
}
Someone is lying inside the tub, lifeless.
Little bits of mold are floating in the placid blood.
-> choice
= choice
+ [Back to the bathroom <back>]
  -> Finger_Bathroom

+ [Examine the body <tub>]
  Why did she do that?
  What is happening here?
  -> choice

+ {!finger_scissors_taken} [Take the scissors <scissors>]
What are you going to do with those scissors?
#variant: No_Scissors
~ inventory += (scissors)
~ finger_scissors_taken = true
You can't believe that you are thinking about this.
This house starts to weight on you.
-> choice

+ [Examine the hand <hand>]
  You lean closer to the hand.
  -> Finger_Hand

=== Finger_Hand ===
// interactions: back, hand
// variant: Cut
#location: Finger_Hand
#music: lvl1
#crossfade: 3.0
{
  -finger_cut:
    #variant: Cut
}
The hand of the woman is hanging from the side of the tub.
Despite bright red painted nails, the bloated skin is dark and reminds you of the creature.
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
  ~ inventory -= (scissors)
  ~ finger_cut = true
  #variant: Cut
  The blade cuts through the flesh easily.
  It feels like there wasn't any solid bones.
  -> Finger_Tub_Chase

// since there is no much choice it is simpler to duplicate the rooms and make new declarations for the whole chase
=== Finger_Tub_Chase ===
#location: Finger_Tub
#variant: Blob_01
You almost scream as the hand retracts and body disappears inside the tub.
-> choice
= choice
+ {finger_octopus_appeared}[Back to the bathroom <back>]
  -> Exit

+ {finger_octopus_appeared}[Back to the bathroom <back_2>]
  You step back, paralized by fear.
  -> Finger_Bathroom_Chase

+ {!finger_octopus_appeared}[Look inside the tub <whole_tub>]
  #sequence: Blob
  You can't see anything through the crimson water.
  #variant: Blob_02
  ~ finger_octopus_appeared = true
  Ripples sudently appear and a tentacle emerges from the tub.
  -> choice

+ {finger_octopus_appeared}[Look at the creature <whole_tub>]
  Your eyes widen in horror? You need to get out of here fast.
  -> choice

= Blob_03
#variant: Blob_03
Another tentacle burst out of the dark mass swinging erratically.
You dodged this one but may not be so lucky next time.
-> choice

= Exit
You stumble back, paralized.
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
  The stench is getting worse.
  -> choice

+ [Look in the mirror <mirror>]
  This keeps coming out, how is this possible ?
  -> choice

+ [Back to the room <back>]
  You crawl out of the bathroom.
  -> Finger_Bedroom_Chase

= Blob_02
#variant: Blob_02
Smaller tentacles joins the party.
-> choice

= Blob_03
#variant: Blob_03
The large one is getting dangerously close.
-> choice

= Dead
#dead:
#music: none
#crossfade: 8.0
Unable to move as tremors seize you, you feel the cold touch of a tentacle wrapping around your head.
The burst of pain knocks unconsious. Lucky for you, you won't hear the sound of your every bones crushing.
+ [try again]
  -> Finger_Try_Again

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
  Adrenaline is racing in your veins.
  -> choice

= Blob_02
#variant: Blob_02
How can it be so big!
-> choice

= Blob_03
#variant: Blob_03
That can't be real!
-> choice

= Dead
#dead:
#music: none
#crossfade: 8.0
A large tentacle violentely throw you against the wall.
Head bleeding, you're unable to move. The dark mass reaches your body and crush you.
+ [try again]
  -> Finger_Try_Again

=== Finger_Corridor_Chase ===
#location: Finger_Corridor_Down
#sequence: Blob
Is it still coming?
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
It's getting more agile.
-> choice

= Blob_02
#variant: Blob_02
Tentacles creeps from everywhere.
-> choice

= Blob_03
#variant: Blob_03
You feel something trying to grasp at your arm.
-> choice

= Dead
#dead:
#music: none
#crossfade: 8.0
You are violently pulled backward.
A bright flash of light blinds you as your neck snaps under the grip of the monster.
+ [try again]
  -> Finger_Try_Again

=== Finger_Stairs_Down_Chase ===
#location: Finger_Stairs_Down
You throw yourself down but a tentacle grabs your feet.
You lose balance and tumble down the stairs.
-> Finger_Stairs_Up_Chase

=== Finger_Stairs_Up_Chase ===
#location: Finger_Stairs_Up
#variant: Blob_01
#sequence: Blob
You feel dizzy.
-> choice
= choice
+ [Look at the creature <up>]
  Oh lord.
  -> choice

// Peut-être qu'on peut faire le relevage en 2 temps ?
+ [Stand up and run <back>]
  You get back on your feet and run to the lounge.
  -> Finger_Bottom_Chase

= Blob_02
#variant: Blob_02
Tentacles are sliding bewteen the railing bars.
-> choice

= Blob_03
#variant: Blob_03
Do something!
-> choice

= Dead
#dead:
#music: none
#crossfade: 8.0
As the tentacles seized your legs, you see the body coming down, crushing you in it's way.
+ [try again]
  -> Finger_Try_Again

=== Finger_Bottom_Chase ===
#location: Finger_Bottom
#variant: Blob_01
#sequence: Blob
You almost reached the hall.
-> choice
= choice
+ [Look at the creature <stairs>]
  Quick!
  -> choice

+ [Look at the hole <hole>]
  Please, make that the other one won't show up. Not now.
  -> choice

+ [Flee to the hall <door>]
  You boom inside the hall and shut the door behind you.
  You hear the creature crashing on the door. thankfully it doesn't open from this side.
  -> Hall_Main

= Blob_02
#variant: Blob_02
Tentacles are bursting from everywhere.
-> choice

= Blob_03
#variant: Blob_03
It's getting at the door!
-> choice

= Dead
#dead:
#music: none
#crossfade: 8.0
The creature covers your only escape.
Helpless, you're quickly taken by its slimy embrace.
You pray every god known to man as you feel life leaving your body.
+ [try again]
  -> Finger_Try_Again

=== Finger_Try_Again ===
~ inventory += (scissors)
~ inventory -= (finger)
~ finger_cut = false
~ finger_octopus_appeared = false
-> Finger_Hand
