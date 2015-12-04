/*
	File: fn_initPortals.sqf
	Author: Ari Höysniemi

	Description:
	Validates portals

	Parameter(s):
	NOTHING

	Returns:
	ARRAY - portals
*/

private["_portals","_portal","_objects","_groups"];
_portals = ["RHNET_ab_modulePORTAL_F"] call Actionbuilder_fnc_getTypes;

{
	
	// Register units
	_portal 	= _x;
	_objects	= [_portal] call Actionbuilder_fnc_getSyncedObjects;
	_groups		= [_portal] call Actionbuilder_fnc_getSyncedGroups;
		
	ACTIONBUILDER_portal_objects pushBack _portal;
	ACTIONBUILDER_portal_objects pushBack [_objects];
		
	ACTIONBUILDER_portal_groups pushBack _portal;
	ACTIONBUILDER_portal_groups pushBack [_groups];
	
} forEach _portals;

{
	
	// Delete units
	[_x, false] spawn Actionbuilder_fnc_deleteSyncedUnits;
	
	// Register portal
	ACTIONBUILDER_locations pushBack _x;
	
} forEach _portals;

_portals