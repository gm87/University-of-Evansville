Interactive Fiction Engine
=====
### By Graham Matthews

Running the Program
-----
The program takes one command line argument (unless you are Dr. Roberts in which case the directories are in the source folder to make your life just a bit easier). Start the program with the directory of the rooms folder.

Creating Rooms
-----
Rooms must include at least a name and a description. Attributes are defined using the attribute name and a colon, followed by a space. (ex name: room1).

Other room attributes include connected rooms (defined by using direction and room name) and listen which gives the player a description of noise in the room.
To connect a room to the north of a room, include "n: northroom" in the file of the room you wish to connect. Replace 'northroom' with the name of the room you wish to connect.

Linking rooms is case sensitive.

Objects are added to the room by defining their source file location in the room file using the object: attribute.

As of now, win/loss conditions are only specified by entering a winning/losing room. 
To set a room to a "winning" or "losing" room add "gameover:" to a room's attributes. 
The room's description will automatically be printed upon winning/losing the game to allow
for a game over message.

Creating Objects
-----
Objects must include at least a name, description, and pickup value. Attributes are defined using the attribute name and a colon, followed by a space. (ex name: object1).

Set pickup to true if the player can take the object and add it to its inventory, or false if the object should not be able to be picked up.

Player Commands
-----
##### go (direction)
Allows movement from room to room. Movement supported in eight directions (n, nw, ne, e, s, sw, se, w). If player moves in the direction where there is not a room, player remains in current room and is shown an error message.

##### take (object)
Allows player to add object currently in room to inventory. Object is removed from room and can be taken to other rooms via the player's inventory.

##### drop (object)
Allows player to drop object currently in inventory to room. Object will stay there even if player leaves the room.

##### examine (object)
Gives player a description of an object in the current room or in the player's inventory.

##### inventory
Lists player's current inventory.

##### look
Prints long description of current room.

##### listen
Allows player to listen for clues in current room. If no listen was specified for the room, player is shown generic message.

Example Files
----
C:\Users\Graham\Desktop\oodhw2\rooms\room1.txt
```aidl
name: Office cubicle
description: You awake in your office cubicle, peeling your face off from the keyboard. Your alarm clock flashes 8:04 AM. There are no windows, but one light dangling from the ceiling. The doorway of your cubicle is to the east of you, and a filing cabinet is below your desk.
listen: The office is quiet... quieter than usual. Maybe nobody has come in for the day yet? That's unusual, though. The CEO is always here by 7:30, at least.
e: Office hallway
object: C:\Users\Graham\Desktop\oodhw2\objects\ceokey.txt
object: C:\Users\Graham\Desktop\oodhw2\objects\filingcabinet.txt
```
C:\Users\Graham\Desktop\oodhw2\objects\filingcabinet.txt
```aidl
name: Filing cabinet
examine: You open the unlocked filing cabinet (that seems like a security issue, hopefully nothing in here is important...) and find a key.
pickup: false
```

To Do
----
- Add usability of items
- Add win conditions
- Add lose conditions