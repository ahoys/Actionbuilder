/*
	File: fn_isValidkey.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: ARRAY - DATABASE
	1: OBJECT/NUMBER - object or id to be translated

	Returns:
	BOOL - true to valid key
*/

private["_array","_key"];
_array	= [_this, 0, [],[[]]] call BIS_fnc_param;
_key	= [_this, 1, -1, [0]] call BIS_fnc_param;

// Array or key can't be empty
if (isNil "_array" || isNil "_key") exitWith {
	["Required parameters missing!"] call BIS_fnc_error;
	false
};

if ((_key < 0) || (_key >= (count _array)) || (count _array < 1)) exitWith {false};

true