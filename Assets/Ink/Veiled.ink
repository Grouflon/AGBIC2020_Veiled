// https://github.com/inkle/ink/blob/master/Documentation/RunningYourInk.md
// https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md

LIST inventory = crowbar, ladder, eyeball, attic_key, scissors, finger, tape, tarot

/*// Debug Chase
~ inventory += (attic_key)
-> Eye_Blob*/

/*// Debug Eye Bedroom
->Eye_Bedroom*/

/*// eye
->Eye_Bedroom

/*-> Finger_Tub_Chase
~ inventory += (tarot)*/
//-> Finger_Bottom
-> Intro_Car_Driving

INCLUDE Intro.ink
INCLUDE Exterior.ink
INCLUDE Hall.ink
INCLUDE Dinner.ink
INCLUDE Eye.ink
INCLUDE Kid.ink
INCLUDE Finger.ink

=== end ===
THE END!
-> END
