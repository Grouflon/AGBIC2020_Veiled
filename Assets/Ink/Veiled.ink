LIST inventory = crowbar, ladder, eyeball, attic_key

VAR checked_door_once = false
VAR eye_visited_bathroom = false
VAR eye_visited_cagibi = false
VAR eye_cross_down = false
VAR eye_tried_cagibi_door = false
VAR eye_fleeing_blob = false

//->Frontyard
->Eye_Bedroom

=== Eye_Bedroom ===
// interactions: back, right_door, left_door, bed, crucifix, bedside_table
// variants : cross_down
#location: Eye_Bedroom
{
  - eye_cross_down:
    #variant: cross_down
}
Nice bedroom.
-> choice
= choice
/*+ [Back to the corridor <back>]
  -> Corridor*/

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
  It falls on the ground.
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
~ eye_visited_bathroom = true
#location: Eye_Bathroom
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
  Gross.
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

=== Eye_Syringe
// interactions: back, eyeball, syringe
// variants: no_eye
#location: Eye_Syringe
Double Gross.
-> choice
= choice
+ [Inspect the syringe <syringe>]
  What is wrong with this place ?
  -> choice

+ {!(inventory ? eyeball)}[Take the eyeball <eyeball>]
  Why do I need this again ?
  ~ inventory += (eyeball)
  #variant: no_eye
  You hear a loud tumbling noise coming from the bedroom behind
  -> choice

+ [Back to the bathroom <back>]
  -> Eye_Bathroom

=== Eye_Cagibi ===
// interactions: back, heater, door
~ eye_visited_cagibi = true
#location: Eye_Cagibi
Small room.
-> choice
= choice
~ temp can_open_door = eye_tried_cagibi_door && (inventory ? attic_key)

+ [Inspect the heater <heater>]
  Hot!
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

=== Eye_Blob
// interactions: back, blob, key, door
#location: Eye_Blob
{
  - eye_fleeing_blob:
    #variant: bigger_blob
}
What is that thing?!
-> choice
= choice
+ [Approach the dark heap <blob>]
  {
    - eye_fleeing_blob:
      It is growing and moving in my direction.
      I need to get out of here.
    - else:
      Ho lord, I think it is still moving.
      Something seems to be coming out of it.
  }
  -> choice

+ {!(inventory ? attic_key)}[Look at the tainted object <key>]
  It seems like it came out of this thing
  -> Eye_Blob_Key

+ [Go through the door <door>]
  It came out of there.
  Going this way is out of the question.
  -> choice

+ [Back to the bathroom <back>]
  {
    - eye_fleeing_blob:
      You rush to the bathroom, hoping it won't follow you there.
  }
  -> Eye_Bathroom

=== Eye_Blob_Key
// interactions: back, key
#location: Eye_Blob_Key
A key emerges from the pool of black blood.
+ [Take the key <key>]
  It is disgusting but you put the key in your bag
  ~ inventory += (attic_key)
  #variant: no_key
  You hear a very loud noise. The thing is waking up.
  ~ eye_fleeing_blob = true
  -> Eye_Blob

+ [Back to the bedroom <back>]
  -> Eye_Blob

=== Eye_Attic ===
// interactions: switch, skeleton, sign, hole
// variants: lit
#location: Eye_Attic
It is dark in here.
-> dark
= dark
+ [Activate the switch <switch>]
  #variant: lit
  Everythings lights up.
  Olala.
  -> light

= light
+ [Touch the skeleton <skeleton>]
  Hello you !
  -> light

+ [Read the scribblings <sign>]
  He or she was counting days.
  -> light

+ [Slip through the hole <hole>]
  See you suckers.
  -> end

=== end ===
THE END!
-> END
