VAR intro_checked_gate = false
VAR intro_checked_tools = false

=== Intro_Car_Driving ===
// interactions: road
#location: Intro_Car_Driving
You have been driving for as long as you can remember.
You need his help to save your child.
-> choice
= choice
+ [Continue driving <road>]
  Hours pass, you are exhausted.
  -> Intro_Car_Parked

=== Intro_Car_Parked ===
// interactions: car, forest
#location: Intro_Car_Parked
You finally arrive at the scientist estate.
You need to cross the forest.
-> choice
= choice
+ [Go back in the car <car>]
You won't turn back.
Not now.
Not so close from your goal.
-> choice

+ [Enter the forest <forest>]
You enter the forest.
-> Intro_Forest

=== Intro_Forest ===
// interactions: back, trees, track
#location: Intro_Forest
A gloomy forest
-> choice
= choice
+ [Back to the car <back>]
  -> Intro_Car_Parked

+ [Press on <track>]
  You continue until you reach the house.
  -> Intro_Portail

+ [Look at the trees <trees>]
  Creepy trees.
  -> choice


=== Intro_Portail ===
// interactions: back, tools, gate
// variants: no_bar, gate_opened
#location: Intro_Portail
The road is blocked by a big iron gate.
It is too high to climb over.
->choice
= choice
~ temp can_open_gate = intro_checked_gate && (inventory ? crowbar)
+ [Back to the forest <back>]
  You go back to the forest.
  -> Intro_Forest

+ {!can_open_gate}[Inspect the gate <gate>]
  ~ intro_checked_gate = true
  It is locked by an old rusty chain.
  Maybe you can force it open with some kind of tool.
  -> choice

+ {can_open_gate}[Break the chain <gate>]
  #variant: Gate_Opened
  ~ inventory -= (crowbar)
  It required some effort but the chain finally breaks.
  The gate is now open, you advance past it.
  -> Exterior_Front

+ {!intro_checked_tools}[Search the abandonned tools <tools>]
  ~ intro_checked_tools = true
  Among the abandonned tools lies a big iron bar.
  This may be useful to break the door open.
  -> choice

+ {intro_checked_tools && !(inventory ? crowbar)}[Take the iron bar <tools>]
  Seems sturdy enough.
  #variant: No_Bar
  Not a very elegant tool but you need to get in there.
  ~ inventory += (crowbar)
  -> choice
