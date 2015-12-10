/*
	File: fn_initPortals.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Validates portals, registers units

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
		
	RHNET_AB_G_PORTAL_OBJECTS pushBack _portal;
	RHNET_AB_G_PORTAL_OBJECTS pushBack [_objects];
		
	RHNET_AB_G_PORTAL_GROUPS pushBack _portal;
	RHNET_AB_G_PORTAL_GROUPS pushBack [_groups];
	
} forEach RHNET_AB_G_PORTALS;

{
	
	// Delete units
	[_x, false] spawn Actionbuilder_fnc_deleteSyncedUnits;
	
} forEach RHNET_AB_G_PORTALS;

true