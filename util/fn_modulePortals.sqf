/*
	File: fn_modulePortals.sqf
	Author: Ari Höysniemi

	Description:
	Returns synchronized portal modules

	Parameter(s):
	0: OBJECT - master object

	Returns:
	ARRAY - a list of portals
*/

private ["_master","_return"];
_master	= param [0, objNull, [objNull]];
_return	= [];

{
	if (_x isKindOf "RHNET_ab_modulePORTAL_F") then {
		_return pushBack _x;
	};
} forEach (synchronizedObjects _master);

_return