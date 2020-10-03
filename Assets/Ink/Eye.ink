VAR eye_visited_bathroom = false
VAR eye_visited_cagibi = false
VAR eye_cross_down = false
VAR eye_tried_cagibi_door = false
VAR eye_fleeing_blob = false
VAR eye_inspected_blob = false
VAR eye_can_take = false
VAR eye_inspected_hole = false

=== Eye_Bedroom ===
// interactions: back, right_door, left_door, bed, crucifix, bedside_table
// variants : cross_down
#location: Eye_Bedroom
{
  - eye_cross_down:
    #variant: cross_down
}
This bedroom is rather cozy.
-> choice
= choice
+ [Back to the corridor <back>]
  -> Hall_FirstFloor

+ [Inspect the {eye_visited_bathroom:bathroom|room} <right_door>]
  You enter the room.
  -> Eye_Bathroom

+ [Inspect the door <left_door>]
  The door is jammed.
  -> choice

+ [Inspect the bed <bed>]
  It seems to have been used recently.
  -> choice

+ {!eye_cross_down} [Inspect the crucifix <crucifix>]
  #variant: cross_down
  It falls on the ground. Bad omen.
  ~ eye_cross_down = true
  -> choice

  + [Inspect the bedside table <bedside_table>]
  There is a family album here.
  -> Eye_Bedroom_Album

=== Eye_Bedroom_Album ===
// interactions: back
#location: Eye_Bedroom_Album
Everyone looks sad.
+ [Back to the room <back>]
  -> Eye_Bedroom

=== Eye_Bathroom ===
// interactions: back, tub, door, sink
// variants: Dark_01, Dark_02, Dark_03
// sequences: Chased
~ eye_visited_bathroom = true
#location: Eye_Bathroom
{
  - eye_fleeing_blob:
    -> Chased
}
A dirty bathroom.
-> choice
= choice
+ [Back to the bedroom <back>]
  {
    - eye_fleeing_blob:
      You are not going back in there.
      -> choice
    - inventory ? eyeball:
      -> Eye_Blob
    - else:
      -> Eye_Bedroom
  }

+ [Inspect the tub <tub>]
  The bottom of the tub is filled caked goo. Gross.
  -> choice

+ {!(inventory ? eyeball)} [Search the sink <sink>]
  You come closer to the sink
  -> Eye_Syringe

+ [Go through the door <door>]
  {
    - !eye_visited_cagibi:
      What is on the other side ?
  }
  -> Eye_Cagibi


= Chased
#sequence: Chased
It is following you.
->choice

= Dark_01
#variant: Dark_01
It is coming closer.
-> choice

= Dark_02
#variant: Dark_02
What are you waiting for?
-> choice

= Dark_03
#variant: Dark_03
You feel its wamrth on your neck.
-> choice

= Dead
You feel the flesh touching your. A chill fusing down your spine.
The dread doesn't last long as the creature suck you in, thick tar like liquid filling your lungs
-> end

=== Eye_Syringe
// interactions: back, eyeball, syringe
// variants: no_eye
#location: Eye_Syringe
Eww.
As you try to repress a heave, you start to seriously question this place.
-> choice
= choice
+ [Inspect the syringe <syringe>]
  It's empty of its content
  -> choice

+ {!(inventory ? eyeball) && !hall_scanner_inspected} [Look at the eyeball <eyeball>]
  
  -> choice

+ {!(inventory ? eyeball) && hall_scanner_inspected}[Take the eyeball <eyeball>]
  As gross as touching this eye is, it may work on the door scanner.
  ~ inventory += (eyeball)
  #variant: no_eye
  It's still warm.
  As you take the eye, you hear a loud tumbling noise coming from the bedroom behind.
  -> choice

+ [Back to the bathroom <back>]
  -> Eye_Bathroom

=== Eye_Cagibi ===
// interactions: back, heater, door
// variants: Dark_01, Dark_02, Dark_03
// sequences: Chased
~ eye_visited_cagibi = true
#location: Eye_Cagibi
{
  - eye_fleeing_blob:
    -> Chased
}
A Small storage room.
-> choice
= choice
~ temp can_open_door = eye_tried_cagibi_door && (inventory ? attic_key)

+ [Inspect the heater <heater>]
  The gentle heat feels comforting
  -> choice

+ {!can_open_door} [Open the door <door>]
  The small iron door is locked.
  ~ eye_tried_cagibi_door = true
  -> choice

+ {can_open_door} [Use the key <door>]
  Unlocked.
  ~ inventory -= (attic_key)
  -> Eye_Attic

+ [Back to the bathroom <back>]
  {
    - eye_fleeing_blob:
      You are not going back in there.
      -> choice
    - else:
      -> Eye_Bathroom
  }

= Chased
#sequence: Chased
It is still coming!
->choice

= Dark_01
#variant: Dark_01
You hear it moan just behind you.
-> choice

= Dark_02
#variant: Dark_02
Quick!
-> choice

= Dark_03
#variant: Dark_03
It's touching your back
-> choice

= Dead
you jump forward to escape its grasp, falling onto the heater. You scream as you burn your face.
A swift death relieves you from the pain as the creature crush you in the corner.
-> end

=== Eye_Blob
// interactions: back, blob, door
// variants: Blob_02, Blob_03
// sequences: Spawning
#location: Eye_Blob
{
  -inventory ? attic_key:
    ->Blob_01
}
What is that thing?! The stench emanating from it makes you retch.
-> choice
= choice
+ {!eye_inspected_blob} [??? <blob>]
  ~ eye_inspected_blob = true
  You get a closer look and notice its surface is slowly pulsing.
  Oh Lord! Something is spurting from one of its pores.
  ->choice

+ {eye_inspected_blob && !eye_fleeing_blob} [Approach the dark heap <blob>]
  You step closer to the creature, trying to control your nausea.
  -> Eye_Blob_Key

+ {eye_fleeing_blob} [Look at the creature <blob>]
  It is growing and moving in your direction.
  You need to act fast
  -> choice

+ [Go through the door <door>]
  It came from the corridor.
  Going back this way is out of question.
  -> choice

+ [Back to the bathroom <back>]
  {
    - eye_fleeing_blob:
      You rush to the bathroom, hoping it won't follow you there.
  }
  -> Eye_Bathroom

= Blob_01
~ eye_fleeing_blob = true
#sequence: Spawning
It seems to be growing
-> choice

= Blob_02
#variant: Blob_02
It's coming at you
-> choice

= Blob_03
#variant: Blob_03
You can almost feel its grasp
-> choice

= Dead
You feel a warm wet touch clenching you arm. You are violently pulled backward. 
you grasp for air but a hot sticky liquid fills your lungs. 
-> end

=== Eye_Blob_Key
// interactions: back, key
#location: Eye_Blob_Key
You realise it was a key emerging from the goo.
+ [Take the key <key>]
  Trying not to touch the flesh, you grab the key with the tip of your fingers.
  ~ inventory += (attic_key)
  #variant: no_key
  You hear a very loud noise. It's waking up.
  -> Eye_Blob

+ [Back to the bedroom <back>]
  -> Eye_Blob

=== Eye_Attic ===
// interactions: switch, skeleton, sign, hole
// variants: lit
#location: Eye_Attic
~ inventory -= (attic_key)
You lock the door behind you, hoping that it will keep the hideous thing away.
It is pitch black in there.
-> dark
= dark
+ [Turn the light on <switch>]
  #variant: lit
  The bright tube light hurts your eyes.
  What you discover doesn't make you very hopeful.
  -> light

= light
+ [Inspect the skeleton <skeleton>]
  The skin has shrunk around the skinny bones. It's practically mummified.
  -> light

+ [Read the scribblings <sign>]
  The occupant was counting days.
  And many days have passed apprently.
  -> light

+ {!eye_inspected_hole} [Inspect the floor <hole>]
  ~ eye_inspected_hole = true
  Planks have been torn away. Look like the person here was making an escape.
  You can see a room below.
  -> light

+ {eye_inspected_hole} [Try to break the floor <hole>]
  You start kicking the remaining planks hard.
  Their mouldy reamains break easily. you pass your head in the hole and slip.
  -> Finger_Bottom
