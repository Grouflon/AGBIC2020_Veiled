->Frontyard

=== Frontyard ===
#location: frontyard
We finally arrive at the old factory.
The place seems abandonned except for a faint light dancing from one of the broken windows of the first floor...
->choice
= choice
+ [Open the door <door>]
    The door does not seems to have been opened in years.
    It is jammed at first but after a few tries you manage to open it.
    ->Hall

+ [Inspect the backyard <backyard>]
    There is nothing of interest in the backyard.
    ->choice

=== Hall ===
#location: hall
Everything in the hall seems stuck in time but for the natural decay. It is as if people had just stopped coming to work one day.
Some things seems to have been recently moved though.
->choice
= choice
+ [Inspect the bedroom <bedroom>]
    There used to be a door there but it is gone now. The room is wide open.
    ->Bedroom

+ [Climb the stairs <stairs>]
    #palette: blood
    The stairs havec crumbled. You won't be able to reach the upper floors this way.
    ->choice

=== Bedroom ===
#location: bedroom
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

=== end ===
THE END!
-> END
