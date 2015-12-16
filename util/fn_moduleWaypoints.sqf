/*
	File: fn_moduleWaypoints.sqf
	Author: Ari Höysniemi

	Description:
	Returns synchronized waypoint modules

	Parameter(s):
	0: OBJECT - master object

	Returns:
	ARRAY - a list of waypoints
*/

private ["_master","_return"];
_master	= param [0, objNull, [objNull]];
_return	= [];

{
	if (_x isKindOf "RHNET_ab_moduleWP_F") then {
		_return pushBack _x;
	};
} forEach (synchronizedObjects _master);

_return