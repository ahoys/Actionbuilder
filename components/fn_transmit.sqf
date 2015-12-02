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

// Wait initialization
waitUntil {
	!isNil "ACTIONBUILDER_actionpoints" && 
	!isNil "ACTIONBUILDER_locations" && 
	!isNil "ACTIONBUILDER_portal_objects" && 
	!isNil "ACTIONBUILDER_portal_objects" &&
	!isNil "ACTIONBUILDER_workload" &&
	!isNil "ACTIONBUILDER_waypoint_used"
};

// Count required
_actionpointsC	= count (["RHNET_ab_moduleAP_F"] call Actionbuilder_fnc_getTypes);
_portalsC		= count (["RHNET_ab_modulePORTAL_F"] call Actionbuilder_fnc_getTypes);
_waypointsC		= count (["RHNET_ab_moduleWP_F"] call Actionbuilder_fnc_getTypes);

// Wait for every module to get registered
waitUntil {
	(count ACTIONBUILDER_actionpoints >= _actionpointsC) && 
	(count ACTIONBUILDER_locations >= (_portalsC + _waypointsC))
};

// All done, transmit
publicVariable "ACTIONBUILDER_locations";
publicVariable "ACTIONBUILDER_portal_objects";
publicVariable "ACTIONBUILDER_portal_groups";
publicVariable "ACTIONBUILDER_workload";

true