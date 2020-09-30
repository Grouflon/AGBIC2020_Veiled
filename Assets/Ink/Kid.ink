VAR kid_curtain_opened = false
VAR kid_down = false
VAR kid_melted = false
VAR kid_player_inspected = false
VAR kid_used_tape = false

=== Kid ===
// interactions: back, curtain, frames, player, kid
// variants: Open, Kid_Down, Melt_01, Melt_02, Melt_03
// sequences: Melt
#location: Kid
{
  -kid_melted:
    #variant: Melt_03
    The smell makes your guts inside out.
  -kid_down:
    #variant: Kid_Down
    He is dead. What kind of monster could have done that?
  -kid_curtain_opened:
    #variant: Open
    The poor kid. You have to do something about it.
  -else:
    This looks like a child's room.
}
-> choice
= choice
+ [Back to the corridor <back>]
  -> Finger_Corridor_Up

+ {!kid_curtain_opened}[Open the curtain <curtain>]
  You slowly approach your hand and pull the curtain open.
  #variant: Open
  ~ kid_curtain_opened = true
  Good Lord the poor child.
  Quick, you must help him!
  -> choice

+ {kid_curtain_opened && !kid_down} [Take the kid down <curtain>]
  You try to help the poor child, but you arrived too late.
  #variant: Kid_Down
  ~ kid_down = true
  He is dead.
  Who could have done that. Are there any clues on the body ?
  -> choice

+ {kid_down && !kid_melted} [Search the body <kid>]
  His hand is clutched around something.
  -> Kid_Hand

+ {kid_melted} [Look at the body <kid>]
  Poor kid.
  It breaks your heart.
  -> choice


+ {!kid_player_inspected}[Inspect the desk <player>]
  A small desk full of toys.
  -> Kid_Player

+ {kid_player_inspected}[Inspect the tape player <player>]
  -> Kid_Player

+ [Inspect the {wall|frames} <frames>]
  {!There are frames on the wall.}
  -> Kid_Frames

= Melt
#location: Kid
#variant: Kid_Down
~ kid_melted = true
What's happening?! His skin is burning!
#sequence: Melt
-> choice

= Melt_01
#variant: Melt_01
-> choice
= Melt_02
#variant: Melt_02
-> choice
= Melt_03
#variant: Melt_03
-> choice

=== Kid_Hand ===
// interactions: back, hand
// variants: Card_Taken
#location: Kid_Hand
What is it? A card?
-> choice
= choice
+ [Back to the room <back>]
  -> Kid

+ [Take the card <hand>]
  This is a tarot card.
  ~ inventory += (tarot)
  #variant: Card_Taken
  "The hanged", how ironic.
  -> Kid.Melt

=== Kid_Player ===
// interactions: back, player
// variants: Tape
#location: Kid_Player
Your attention is caught by a toy tape player.
-> choice
= choice
~ temp can_use_player = kid_player_inspected && (inventory ? tape)
+ [Back to the room <back>]
  -> Kid

+ {!can_use_player}[Inspect the player <player>]
  ~ kid_player_inspected = true
  There is no tape in it.
  -> choice

+ {!can_use_player && kid_used_tape}[Play the tape <player>]
  #variant: Tape
  ~ kid_used_tape = true
  You insert the tape in the player and press play.
  A lullaby starts to play.
  Heartbreaking.
  -> choice

=== Kid_Frames ===
#location: Kid_Frames
A set of family photographs.
-> choice
= choice
+ [back to the roon <back>]
  -> Kid

+ [Inspect the frames <frames>]
  Everyone looks sad.
  -> choice
