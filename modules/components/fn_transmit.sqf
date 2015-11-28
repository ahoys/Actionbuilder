/*
	File: fn_transmit.sqf
	Author: Ari Höysniemi

	Description:
	Transmits all essential Actionbuilder variables to other clients,
	mainly for headless client purposes

	Parameter(s):
	Nothing

	Returns:
	Nothing
*/

_actionpointsC	= count (["RHNET_ab_moduleAP_F"] call Actionbuilder_fnc_listClients});
_portalsC		= count (["RHNET_ab_modulePORTAL_F"] call Actionbuilder_fnc_listClients});
_waypointsC		= count (["RHNET_ab_moduleWP_F"] call Actionbuilder_fnc_listClients});

// Wait initialization
waitUntil {
	!isNil "ACTIONBUILDER_actionpoints" && 
	!isNil "ACTIONBUILDER_portals" && 
	!isNil "ACTIONBUILDER_waypoints" && 
	!isNil "ACTIONBUILDER_portal_objects" && 
	!isNil "ACTIONBUILDER_portal_objects" &&
	!isNil "ACTIONBUILDER_workload"
};

// Wait for every module to get registered
waitUntil {
	(count ACTIONBUILDER_actionpoints >= _actionpointsC) && 
	(count ACTIONBUILDER_portals >= _portalsC) && 
	(count ACTIONBUILDER_waypoints >= _waypointsC)
};

// All done, transmit
publicVariable "ACTIONBUILDER_portals";
publicVariable "ACTIONBUILDER_portal_objects";
publicVariable "ACTIONBUILDER_portal_groups";
publicVariable "ACTIONBUILDER_workload";

// Signal clients to continue
ACTIONBUILDER_signal = true;
publicVariable "ACTIONBUILDER_signal";

true