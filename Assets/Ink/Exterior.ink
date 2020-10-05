VAR exterior_seen_guy = false
VAR exterior_seen_backyard = false
VAR exterior_inspected_wares = false
VAR exterior_inspected_back_window = false
VAR exterior_used_ladder = false
VAR exterior_visited_shed = false

=== Exterior_Front ===
// interactions: statue, door, left, right
#location: Exterior_Front
This mansion, once opulent, looks rather abandonned.
A towering statue seems to watch over the property.
-> choice
= choice
+ [Knock on the door <door>]
  {!You knock repeatedly to the door but no one answers.}
  Maybe you can find another way in.
  -> choice

+ [Examine the statue <statue>]
  Strange slender dark silouhettes.
  They represent a family, but their alien look gives you chills.
  -> choice

+ [Go around the right corner <right>]
  -> Exterior_Right

+ [Go around the left corner <left>]
  -> Exterior_Left

=== Exterior_Right ===
// interactions: left, window, right
// variant: No_Guy
#location: Exterior_Right
{
  - exterior_seen_guy:
    #variant: No_Guy
}
The way to the back is blocked by a large empty ditch. It's not dry enough to cross.
{
  -!exterior_seen_guy:
    You caught something moving on the first floor.
}
-> choice
= choice
+ [Back to the front yard <left>]
  Maybe there is another way around.
  -> Exterior_Front

+ {!exterior_seen_guy} [Examine the window <window>]
  ~ exterior_seen_guy = true
  You can distinguish a ghostly figure through the window.
  # variant: No_Guy
  You call it out but it suddenly fades away.
  -> choice

+ {exterior_seen_guy} [Examine the window <window>]
  The strange figure has vanished.
  Was it really there in the first place?
  -> choice

+ [Examine the buildings <right>]
  Crossing the ditch does not seem like a good idea.
  You wouldn't want to get stuck.
  -> choice

=== Exterior_Left ===
// interactions: back, shed, front
#location: Exterior_Left
{
  -!exterior_seen_backyard:
    You walk along an overgrown french garden.
}
There is a shed on the left.
-> choice
= choice
+ [Back to the front yard <back>]
  -> Exterior_Front

+ [Enter the shed <shed>]
  {
    - !exterior_visited_shed:
      The shed is not locked.
  }
  -> Exterior_Shed

+ [Go to the back yard <front>]
  The path leads to the backyard.
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
A thick layer of dust covers everything.
Nothing has been touched in a long time.
-> choice
= choice
+ [Back to the alley <back>]
  -> Exterior_Left

+ [Search among the clutter <stuff>]
  Warped wood planks and broken windows.
  Nothing useful in there.
  -> choice

+ {!exterior_inspected_wares} [Inspect the tool bench <ladder>]
  A ladder rests on the side of the bench.
  It could be useful to enter the house.
  ~ exterior_inspected_wares = true
  -> choice

+ {exterior_inspected_wares && !(inventory ? ladder) && !exterior_used_ladder} [Take the ladder <ladder>]
  It's heavier than it looks.
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
A tiled terrace is nested at the back of the house.
-> choice
= choice
~ temp can_use_ladder = exterior_inspected_back_window && (inventory ? ladder)
+ [Back to the alley <back>]
  -> Exterior_Left

+ {!can_use_ladder && !exterior_used_ladder} [Inspect the window <window>]
  The shutters are not fully closed and the window behind them seems open.
  If you had a way to get up there, you could sneak inside.
  ~ exterior_inspected_back_window = true
  -> choice

+ {can_use_ladder && !exterior_used_ladder} [Put the ladder <ladder>]
  #variant: Put_Ladder
  ~ exterior_used_ladder = true
  ~ inventory -= (ladder)
  You put the ladder against the wall.
  It is tall enough to reach the window.
  -> choice

+ {exterior_used_ladder} [Climb the ladder <ladder>]
  You climb the ladder and enter the house.
  -> Hall_TopDown
