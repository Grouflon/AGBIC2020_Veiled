VAR exterior_seen_guy = false
VAR exterior_seen_backyard = false
VAR exterior_inspected_wares = false
VAR exterior_inspected_back_window = false
VAR exterior_used_ladder = false
VAR exterior_visited_shed = false

=== Exterior_Front ===
// interactions: statue, door, left, right
#location: Exterior_Front
Big mansion.
Creepy statue.
-> choice
= choice
+ [Knock to the door <door>]
  {!You knock repeatedly to the door but no one answers.}
  Maybe you can find another way in.
  -> choice

+ [Examine the statue <statue>]
  Strange dark silouhettes.
  Are they human?
  -> choice

+ [Go round the right corner <right>]
  -> Exterior_Right

+ [Go round the left corner <left>]
  -> Exterior_Left

=== Exterior_Right ===
// interactions: left, window, right
// variant: No_Guy
#location: Exterior_Right
{
  - exterior_seen_guy:
    #variant: No_Guy
}
The way to the back of the house is blocked from here.
{
  -!exterior_seen_guy:
    You've seen something moving on the first floor.
}
-> choice
= choice
+ [Back to the front yard <left>]
  Maybe there is another way around.
  -> Exterior_Front

+ {!exterior_seen_guy} [Examine the window <window>]
  ~ exterior_seen_guy = true
  You can distinguish a ghostly figure through the first floor window.
  # variant: No_Guy
  You call out to it but it suddenly fades away.
  -> choice

+ {exterior_seen_guy} [Examine the window <window>]
  The strange figure has vanished.
  -> choice

+ [Examine the buildings <right>]
  There are buildings blocking the way.
  There is no way around the house from here.
  -> choice

=== Exterior_Left ===
// interactions: back, shed, front
#location: Exterior_Left
{
  -!exterior_seen_backyard:
    This leads to the back of the house.
}
There is a small shed on the left.
-> choice
= choice
+ [Back to the front yard <back>]
  -> Exterior_Front

+ [Enter the shed <shed>]
  {
    - !exterior_visited_shed:
      The shed is unlocked.
  }
  -> Exterior_Shed

+ [Go to the back yard <front>]
  The way opens to the backyard of the house.
  -> Exterior_Back

=== Exterior_Shed ===
// interactions: back, ladder, stuff
// variant: No_Ladder
~ exterior_visited_shed = true
#location: Exterior_Shed
{
  - (inventory ? ladder) || exterior_used_ladder:
    #variant: No_Ladder
}
Various tools and gardening wares.
-> choice
= choice
+ [Back to the alley <back>]
  -> Exterior_Left

+ [Search the tools <stuff>]
  Various construction wares.
  Nothing useful in there.
  -> choice

+ {!exterior_inspected_wares} [Inspect the wares <ladder>]
  There is a ladder among the wares.
  It could be useful to enter the house.
  ~ exterior_inspected_wares = true
  -> choice

+ {exterior_inspected_wares && !(inventory ? ladder) && !exterior_used_ladder} [Take the ladder <ladder>]
  This is heavy.
  ~ inventory += (ladder)
  #variant: No_Ladder
  Hopefully you won't have to carry it around for too long.
  -> choice

=== Exterior_Back ===
// interactions: back, window, ladder
// variant: Put_Ladder
~ exterior_seen_backyard = true
#location: Exterior_Back
{
  - exterior_used_ladder:
    #variant: Put_Ladder
}
The back of the house.
-> choice
= choice
~ temp can_use_ladder = exterior_inspected_back_window && (inventory ? ladder)
+ [Back to the alley <back>]
  -> Exterior_Left

+ {!can_use_ladder && !exterior_used_ladder} [Inspect the window <window>]
  The shutters are open and the window is broken.
  If you had a way to rise up there, you could sneak inside.
  ~ exterior_inspected_back_window = true
  -> choice

+ {can_use_ladder && !exterior_used_ladder} [Put the ladder <ladder>]
  #variant: Put_Ladder
  ~ exterior_used_ladder = true
  ~ inventory -= (ladder)
  You put the ladder against the wall.
  It is enough to reach the window.
  -> choice

+ {exterior_used_ladder} [Climb the ladder <ladder>]
  You climb the ladder and enter the house.
  -> Hall_TopDown
