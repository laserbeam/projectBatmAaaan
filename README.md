projectBatmAaaan
================

BatmaaaAAAaaAAAAAAAAAaaaAAAAAAn!

projectBatmAaaan is a prototype me and a few coleagues of mine made for our semester project at Aalborg University Esbjerg. Due to popular demand, here's the game and the code!

You play as a blind character in a maze, and the way you see the maze is by makins sounds which will reflect of walls. This is a short 4 level prototype, should take about 10-15 minutes to complete. Use the pitch of your voice and the amplitude of your screams, shouts, whistling, singing, talking or whatever sound you want to make to play.

WASD to move around, mouse to aim, your voice to see and act.

WARNING!
--------

The game needs audio input! The current version here is the one used for testing. There is no built in calibration!!! If your microphone doesn't respond properly, tweak the levels of your default microphone in Windows control panel so that when it is silent nothing happens in the game and when you talk quietly you get to see something on the screen!

Uncompress bin.zip and run Batman.exe from there to play the prototype.

Current status and further development
--------------------------------------

We're still busy with finishing our project report, not sure when and how we'll build this game further. Expect at least an OSX port sometime during the summer (or if someone wants to help with porting it, knock yourselves out and hit me with a pull request).

Known bugs
----------

Don't slam too hard into sharp corners, the current way of treating collisions doesn't like it.

About the code
--------------

The code is written in Processing, go to the homepage for details http://processing.org

You will also need to get proControll http://creativecomputing.cc/p5libs/procontroll/ and install it following this guide: http://wiki.processing.org/w/How_to_Install_a_Contributed_Library

The code is not amazingly pretty and if the game will ever be a full commercial game it will suffer some heavy refactoring, and maybe will be ported to MOAI or some other engine. Start in Batman.pde and have fun!