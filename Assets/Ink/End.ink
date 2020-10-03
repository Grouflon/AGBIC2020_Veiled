
=== End_Stairs ===
// interactions: stairs
#location: End_Stairs
Just as you pass the door, it closes behind you.
A huge staircase unfolds before you.
-> choice
= choice
+ [Go back to the hall <back>]
  The door is locked behind you.
  You can't go back.
  -> choice

+ [Go down the stairs <stairs>]
  You delve down into the unknown complex.
  -> End_Corridor

=== End_Corridor ===
// interactions: door
#location: End_Corridor
At some point, the stairs ends into a large corridor.
There is a single door at the end with light coming out of it.
+ [Go to the door <door>]
  You open the door.
  The light is blinding at first.
  -> End_Room

=== End_Room ===
// interactions: chair, glass, screen
// sequences: wait
#location: End_Room
You hear the door lock behind you quickly after you enter.
After a few moments, the silence is broken by the crackling voice of a speaker.
#clear:
"Well, we were waiting for you sir."
#sequence: Wait
"Please make yourself comfortable and grab a seat".
-> choice
= choice
+ [Sit on the chair <chair>]
  Reluctantly, you approach the chair.
  "Let's make a little experiment you and I would you?"
  Once seated, you finally get a sight of what is behind the glass.
  -> End_Mirror

+ [Look at the glass <glass>]
  This seems to open up on another room.
  You can't see its content from here.
  -> choice

+ [Look at the screen <screen>]
  Cryptic characters and notes keep scrolling on the screen.
  -> choice

= Waited
"Indulge me and take a seat please."
"You may have all night, but that's not the case for everyone here."
-> choice

=== End_Mirror ===
#location: End_Mirror
To be continued
-> end
