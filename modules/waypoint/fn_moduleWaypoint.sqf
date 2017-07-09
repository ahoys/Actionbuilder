/*
	File: fn_moduleWaypoint.sqf
	Author: Ari Höysniemi

	Description:
	Makes sure everything is set up correctly in the mission editor

	Parameter(s):
	0: OBJECT - waypoint module

	Returns:
	BOOL - true if valid check
*/
// Make sure there are portals or waypoints available ---------------------------------------------
private _valid = true;

// Invalid modules synchronized, return an error.
// This is important because the modules may end up in a group and cause module position changes.
{
	if (((typeOf _x) != "RHNET_ab_moduleWP_F") && ((typeOf _x) != "RHNET_ab_modulePORTAL_F")) exitWith {
		["Not supported module %1 synchronized to waypoint %2.", typeOf _x, _this select 0] call BIS_fnc_error;
		_valid = false;
	};
} forEach (_this select 0) call BIS_fnc_moduleModules;

_valid