LIST inventory = crowbar, shed_key, ladder

VAR checked_door_once = false

->Frontyard
//->Bedroom

inventory ? (crowbar)

=== Frontyard ===
#location: frontyard
We finally arrive at the old factory.
The place seems abandonned except for a faint light dancing from one of the broken windows of the first floor...
->choice
= choice
~ temp can_force_door = checked_door_once && (inventory ? crowbar)
+ {!can_force_door} [Open the door <door>]
    The door does not seems to have been opened in years.
    It is jammed.
    ~ checked_door_once = true
    ->choice
+ {can_force_door} [Force the door with the crowbar <door>]
    You force the door with the crowbar and enter the factory.
    ~ inventory -= (crowbar)
    ->Hall

+ [Inspect the backyard <backyard>]
    You find a crowbar in the backyard.
    ~ inventory += (crowbar)
    ~ inventory += (shed_key)
    ~ inventory += (ladder)
    ->choice

=== Hall ===
#location: hall
Everything in the hall seems stuck in time but for the natural decay. It is as if people had just stopped coming to work one day.
Some things seems to have been recently moved though.
->choice
= choice
+ [Inspect the bedroom <bedroom>]
    You find a crowbar.
    ~ inventory += (crowbar)
    ->choice

+ [Climb the stairs <stairs>]
    #palette: blood
    You use your crowbar.
    ~ inventory -= (crowbar)
    ->choice

=== Room ===
#location: room
An abandonned bedroom.
The medical equipment suggests that some medical experiments were done here.
->choice
= choice
+ [Inspect the bed <bed>]
    It is still warm.
    Someone has been lying here recently.
    ->choice

+ [Look at the window <window>]
    JUMPSCARE !
    ->end

=== Bedroom ===
#location: bedroom_front
Nice bedroom
What do we do ?
->choice
= choice
+ [Inspect the bathroom <door>]
  You enter the bathroom.
  ->Bathroom
+ [Look at the bed <bed>]
  Nothing on the bed, nothing under.
  ->choice
+ [Inspect the crucifix <crucifix>]
  People here should have been quite religious.
  ->choice
+ [Open the door <locked_door>]
  You try to open the door but it is jammed.
  ->choice

=== Bathroom ===
#location: bathroom
Nice bathroom
What do we do ?
->choice
= choice
+ [Inspect the tub <tub>]
  Dirty.
  ->choice
+ [Back to the bedroom <back>]
  ->Bedroom

=== end ===
THE END!
-> END
