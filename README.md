![Actionbuilder](https://github.com/ahoys/Actionbuilder/blob/master/images/logos/actionbuilder.png)

## Overview
Actionbuilder is a powerful mission creation extension for Arma 3. Actionbuilder enables a fully randomizable unit spawning, new kind of waypoints, generally higher AI count and other benefits with as little effort as possible.

## Introduced Modules

### Actionpoint
Actionpoints are in charge of event handling. Actionpoints decide when and what portals to activate.

Actionpoints are controlled by in-game triggers and can hold multiple portals.

### Portal
Portals are responsible of unit spawning. You can link editor placed units to portals which are then loaded into the portals. The moment when Actionpoint triggers, all the linked portals will spawn their loaded units.

### Waypoint
Waypoints control the spawned units. For example a waypoint may order the spawned units to find the closest player.

There can be multiple waypoints synchronized to a one portal. Waypoints can also be synchronized to each other, creating randomization.