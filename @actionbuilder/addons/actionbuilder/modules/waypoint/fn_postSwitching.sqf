/*
	File: fn_postSwitching.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an Actionbuilder component, outside calls are not supported.

	Description:
	Assigns a new waypoint to a group.

	Parameter(s):
	0: GROUP - The target group.
	1: ARRAY - The current position.

	Returns:
	NOTHING
*/
if (!isServer && hasInterface) exitWith {};

private _group = param [0, grpNull, [grpNull]];
private _pos = param [1, [], [[]]];

if (isNull _group || _pos isEqualTo []) exitWith {false};

// Random delay before switching post.
sleep (random [10, 30, 60]);

// Look for valid houses nearby.
private _houses = [];
{
	_houses pushBack ([_x] call BIS_fnc_buildingPositions);
} forEach nearestObjects [
	_pos,
	["house"],
	25
];

// Select a random house & position.
private _wpPos = selectRandom (selectRandom _houses);

// Create a new house position waypoint.
private _wp = _group addWaypoint [_wpPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointStatements ["true", format ["[group this, %1] spawn Actionbuilder_fnc_postSwitching", _wpPos]];

true
