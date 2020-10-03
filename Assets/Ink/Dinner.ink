VAR dinner_inspected_photo = false
VAR dinner_torn_photo = false
VAR dinner_took_tape = false

=== Dinner_View02 ===
// interactions: back, shelf, table
#location: Dinner_View02
A classy dining room.
{!The silverware has been set and the dinner is ready to be served, but why all this decorum?}
{!Was someone expected?}
-> choice
= choice
+ [Bath to the hall <back>]
  -> Hall_Main

+ [Inspect the table <table>]
  Only one plate has been served.
  -> Dinner_Plate

+ [Look at the buffet <shelf>]
  {!You take a closer look at the frames on the buffet.}
  -> Dinner_Buffet

=== Dinner_Plate ===
// interactions: back, plate
#location: Dinner_Plate
Ew, french cuisine apparently.
-> choice
= choice
+ [Back to the room <back>]
  -> Dinner_View02

+ [Inspect the plate <plate>]
  Yikes, no thanks!
  -> choice

=== Dinner_Buffet ===
#location: Dinner_Buffet
{
  - dinner_took_tape:
    #variant: No_Tape
  - dinner_torn_photo:
    #variant: Open
}
A few family photos are on display on the buffet.
-> choice
= choice
+ [Back to the room <back>]
  ->Dinner_View02

+ [Look at the photo <big_frame>]
  Predator smile.
  -> choice

+ [Look at the photo <small_frame>]
  Smiling kid.
  -> choice

+ {!dinner_took_tape} [Look at the photo <tape_frame>]
  {!The wedding photo catch your attention.}
  -> Dinner_Photo

=== Dinner_Photo ===
// interactions: back, photo
// variants: Open, No_Tape
#location: Dinner_Photo
{
  - dinner_torn_photo:
    #variant: Open
    A hidden case with a tape in it.

  - dinner_took_tape:
    #variant: No_Tape
    An empty hidden case.

  - else:
    A happy couple.
}
-> choice
= choice
+ [Back to the buffet <back>]
  -> Dinner_Buffet

+ {!dinner_inspected_photo} [Look at the photo <photo>]
  ~ dinner_inspected_photo = true
  Maybe they are your hosts.
  The photograph seems to be torn on the corner.
  -> choice

+ {dinner_inspected_photo && !dinner_torn_photo} [Take off the photo <photo>]
  ~ dinner_torn_photo = true
  You remove the photo from the frame.
  #variant: Open
  You uncover a hidden case with a tape in it.
  -> choice

+ {dinner_torn_photo && !dinner_took_tape} [Take the tape <photo>]
  You take the tape and inspect it.
  #variant: No_Tape
  ~ dinner_took_tape = true
  ~ inventory += (tape)
  "To Jean-Jacques" is written on the label.
  -> choice
