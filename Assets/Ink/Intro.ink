VAR intro_checked_gate = false
VAR intro_checked_tools = false

=== Intro_Car_Driving ===
// interactions: road
#location: Intro_Car_Driving
It has been one year since the accident. One endlessly long year looking for the truth.
You know your child is alive. All the answers are out there.
-> choice
= choice
+ [Continue driving <road>]
  Hours pass, you are exhausted.
  -> Intro_Car_Parked

=== Intro_Car_Parked ===
// interactions: car, forest
#location: Intro_Car_Parked
{!You finally arrive at the location you've been given.}
Better keep a low profile and go trough the woods
-> choice
= choice
+ [Go back in the car <car>]
You shudder at what you had to do to obtain this adress.
No way you're backing out now
-> choice

+ [Enter the forest <forest>]
You enter the forest.
-> Intro_Forest

=== Intro_Forest ===
// interactions: back, trees, track
#location: Intro_Forest
Ominous twisted trees watch you venture deeper into the woods
-> choice
= choice
+ [Back to the car <back>]
  -> Intro_Car_Parked

+ [Press on <track>]
  You continue until you reach the house.
  -> Intro_Portail

+ [Look at the trees <trees>]
  Everything look so quiet here. You shiver.
  -> choice


=== Intro_Portail ===
// interactions: back, tools, gate
// variants: no_bar, gate_opened
#location: Intro_Portail
The property is closed off by a large gate.
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
  It has seen betters days, maybe there is a way to break it.
  -> choice

+ {can_open_gate}[Break the chain <gate>]
  ~ inventory -= (crowbar)
  You put all your weight on the bar. The chain finally surrenders.
  #variant: Gate_Opened
  The gate opens with a creaking noise, you enter the front yard.
  -> Exterior_Front

+ {!intro_checked_tools}[Search the abandonned tools <tools>]
  ~ intro_checked_tools = true
  Among the rusty tools lies a big iron bar.
  This may be useful to break the chain.
  -> choice

+ {intro_checked_tools && !(inventory ? crowbar)}[Take the iron bar <tools>]
  Seems sturdy enough.
  #variant: No_Bar
 Not very subtle but you need to get in.
  ~ inventory += (crowbar)
  -> choice
