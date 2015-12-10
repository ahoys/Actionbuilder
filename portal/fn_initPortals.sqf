/*
	File: fn_initPortals.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Validates portals

	Parameter(s):
	NOTHING

	Returns:
	NOTHING
*/

private["_portal","_objects","_groups"];

{
	
	// Register units
	_portal 	= _x;
	_objects	= [_portal] call Actionbuilder_fnc_getSyncedObjects;
	_groups		= [_portal] call Actionbuilder_fnc_getSyncedGroups;
		
	ACTIONBUILDER_portal_objects pushBack _portal;
	ACTIONBUILDER_portal_objects pushBack [_objects];
		
	ACTIONBUILDER_portal_groups pushBack _portal;
	ACTIONBUILDER_portal_groups pushBack [_groups];
	
} forEach ACTIONBUILDER_portals;

{
	
	// Delete units
	[_x, false] spawn Actionbuilder_fnc_deleteSyncedUnits;
	
} forEach ACTIONBUILDER_portals;

true