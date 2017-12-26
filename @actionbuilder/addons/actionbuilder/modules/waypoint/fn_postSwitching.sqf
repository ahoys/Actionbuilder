/*
	File: fn_postSwitching.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an Actionbuilder component, outside calls are not supported.

	Description:
	Assigns a new waypoint to a group.

	Parameter(s):
	0: GROUP - The target group.
	1: ARRAY - The origin position.

	Returns:
	NOTHING
*/
if (!isServer && hasInterface) exitWith {false};

private _group = param [0, grpNull, [grpNull]];
private _origin = param [1, [], [[]]];

if (isNull _group || _origin isEqualTo []) exitWith {false};

// Wait until the FPS is high enough.
waitUntil {diag_fps > 20};

// Random delay before switching post.
if (daytime > 8 && daytime < 20) then {
	// Day.
	sleep (random 120);
} else {
	// Night.
	sleep (random 480);
};

// Look for valid houses nearby.
private _houses = [];
{
	private _positions = [_x] call BIS_fnc_buildingPositions;
	if !(_positions isEqualTo []) then {
		// Add only houses that have positions set.
		_houses pushBack _positions;
	};
} forEach nearestObjects [
	_origin,
	["house"],
	25
];

// No locations available.
if (_houses isEqualTo []) exitWith {false};

// Select a random house & position.
private _wpPos = selectRandom (selectRandom _houses);

// Create a new house position waypoint.
private _wp = _group addWaypoint [_wpPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointStatements ["true", format ["[group this, %1] spawn Actionbuilder_fnc_postSwitching", _origin]];

true
