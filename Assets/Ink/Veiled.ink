// https://github.com/inkle/ink/blob/master/Documentation/RunningYourInk.md
// https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md

LIST inventory = crowbar, ladder, eyeball, attic_key, cissors, finger

/*// Debug Chase
~ inventory += (attic_key)
-> Eye_Blob*/

/*// Debug Eye Bedroom
->Eye_Bedroom*/

//-> Hall_TopDown
-> Intro_Car_Driving

INCLUDE Intro.ink
INCLUDE Exterior.ink
INCLUDE Hall.ink
INCLUDE Eye.ink

=== end ===
THE END!
-> END
