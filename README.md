![Actionbuilder](https://github.com/ahoys/Actionbuilder/blob/master/actionbuilder.png)

## Overview
Actionbuilder is a powerful mission creation extension for Arma 3. Actionbuilder enables higher AI unit count, complex randomized waypoint routes, live unit spawning and more. The core idea is to allow creation of highly randomized Arma scenarios with as little work as possible.


## Modules

### Actionpoint
Actionpoints are in change of event triggering. One actionpoint can hold multiple portals and can decide which portals to activate.

Actionpoints are controlled by in-game triggers.

### Portal
Portals are responsible of the unit spawning. The user can link units, groups and vehicles to portals that will spawn after the portal activates.

### Waypoint
Waypoints hold the information what to do after a portal has activated and the related units spawned. For example a waypoint may order the spawned units to move to some other location.

There can be multiple waypoints synchronized to a one portal. Waypoints can also be synchronized to eachother, creating randomization.