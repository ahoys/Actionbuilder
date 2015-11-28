/*
	File: fn_modulePortal.sqf
	Author: Ari Höysniemi

	Description:
	Initializes a new portal

	Parameter(s):
	0: OBJECT - portal module

	Returns:
	Nothing
*/

// No clients allowed -----------------------------------------------------------------------------
if (!isServer) exitWith {false};

// Required functions -----------------------------------------------------------------------------
if (isNil "Actionbuilder_fnc_unitSpawn" || isNil "Actionbuilder_fnc_registerUnits") exitWith {
	["Could not find a required function!"] call BIS_fnc_error;
	false
};

// Initialize variables if required ---------------------------------------------------------------
if (isNil "ACTIONBUILDER_portals") then {ACTIONBUILDER_portals = []};
if (isNil "ACTIONBUILDER_portal_objects") then {ACTIONBUILDER_portal_objects = []};
if (isNil "ACTIONBUILDER_portal_groups") then {ACTIONBUILDER_portal_groups = []};

// Define portal ----------------------------------------------------------------------------------
private["_portal","_unitSync"];
_portal		= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_unitSync	= [_portal,true,false] call Actionbuilder_fnc_registerUnits;

// Register portal --------------------------------------------------------------------------------
if (((count (_unitSync select 0)) < 1) && ((count (_unitSync select 1)) < 1)) exitWith {false};
if ((count (_unitSync select 0)) > 0) then {
	ACTIONBUILDER_portal_objects pushBack _portal;
	ACTIONBUILDER_portal_objects pushBack (_unitSync select 0);	// [portal1,[objects],portal2,[objects]]
};
if ((count (_unitSync select 1)) > 0) then {
	ACTIONBUILDER_portal_groups pushBack _portal;
	ACTIONBUILDER_portal_groups pushBack (_unitSync select 1);	// [portal1,[groups],portal2,[groups]]
};
ACTIONBUILDER_portals pushBack _portal;

true