# MTA Lockpicking Mechanic

Lockpicking mechanics like from other games

Authors
========================================================================

- Rick <Main Developer>
- Payro <3D Graphic/Modeller>

The content of the repository
========================================================================

W repozytorium znajduje się:
* Client side LUA code
* Original models

INSTALLATION
========================================================================
```
1. PUT THE DIRECTORY CONTENT IN THE TARGET SERVER RESOURCE PATH
2. Enter the commmand `refresh` or `start lockpick`
```

CONTROL
=========================================================================
```
D KEY - ROTATES LOCK CLICK OF STEPS
Use the mouse to move the pick lock
```

Events
=========================================================================
```
onClientPlayerStartlockpicking
This event is triggered when the player starts the lockpicking mechanic
```

```
onClientPlayerStoplockpicking
This event triggers when the player stop the mechanic
parameters: boolean success

success - means whether the player has opened the lock
```
