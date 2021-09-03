VAR end_recognized_child = false

=== End_Stairs ===
// interactions: stairs
#location: End_Stairs
#music: none
#crossfade: 8.0
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
#music: end
#crossfade: 20.0
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
#music: end0
#crossfade: 8.0
You hear the door lock behind you quickly after you enter.
After a few moments, the silence is broken by a crackling speaker sound.
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
// interactions: child
// variants:
#location: End_Mirror
#music: end1
#crossfade: 8.0
Another dark entity lies inert in the other room.
You don't understand what is expected of you now.
After a few moments of silence, the man's voice booms again.
#clear:
"A touching reunion, really."
"I'd hate to interrupt, but unfortunately we need to go on with the procedure."
"Would you mind having a closer look at our friend here?"
-> choice
= choice
+ {!end_recognized_child} [Look at the monster <child>]
  You fight your instinctive disgust and try to focus your attention on the creature before you.
  #variant: Stand_Up
  Suddenly it starts to move and rise.
  #clear:
  Its shape looks strangely humanoid now.
  Almost familiar.
  You start to cry.
  #clear:
  "Okay that's enough, we both know what you are seeking here."
  "I can fulfill your wish but you need to do one thing for me first."
  "Check the tray on the board please."
  ~ end_recognized_child = true
  -> choice

+ {end_recognized_child} [Look at the tray <plate>]
  ->End_Tray

=== End_Tray ===
// interactions: syringe
// variants: No_Syringe, Hand_01, Hand_02, Hand_03, Hand_04
// sequences: Do_It
#location: End_Tray
The saturated voice is more and more assertive.
"You can be together again you know."
"But before that I need you to administrate yourself my special treatment."
-> choice
= choice
+ {!(inventory ? syringe)} [Take the syringe <tray>]
  As your will falters, you take the syringe in your hand.
  #variant: No_Syringe
  You can't stop the tears flowing down your face.
  ~ inventory += (syringe)
  #sequence: Do_It
  #variant: Hand_01
  What is going to happen if you do that?
  -> choice

+ {(inventory ? syringe)} [Inject the treatment <hand>]
  #break_sequence:
  ~ inventory -= (syringe)
  Your mind is broken, there is nothing you can do now.
  You see yourself inserting the needle inside your arm and press the syringe.
  #variant: Hand_02
  #sequence: Injection
  What now?.
  -> No_Choice

= No_Choice
+ [dummy]
  ->No_Choice

= Do_It
"Do it now!" screams the voice.
-> choice

= Conciliate
"This void in your heart, this longing"
"It can all fade away. Let it flow in your veins."
-> choice

= Injected
#variant: Hand_03
Suddenly a tide of pain rush through your whole body.
You can't move, you can't breathe and a nightmarish buzzing sound is filling your ears.
#clear:
As you feel your body stretch and change, everything becomes more and more distant.
#variant: Hand_04
Even the sound, even the pain is fading out, except for a small humming voice.
->End_Window

=== End_Window ===
// variants: Daddy
#location: End_Window
As the suffering slowly fades, you start to remember.
#music: none
#crossfade: 10.0
That voice that you missed for so long now.
#variant: Daddy
And that sweet face.
#clear:
"Daddy..."
#end:
The end.
Veiled.
A game made for AGBIC 2020 by Rémi Bismuth & Nicolas Millot.
Thank you for playing.
+ [try again]
  -> end
