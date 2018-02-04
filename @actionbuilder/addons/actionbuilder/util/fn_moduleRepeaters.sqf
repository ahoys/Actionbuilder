/*
	File: fn_moduleRepeaters.sqf
	Author: Ari Höysniemi

	Description:
	Returns synchronized repeater modules

	Parameter(s):
	0: OBJECT - master object

	Returns:
	ARRAY - a list of repeaters
*/
private _master = param [0, objNull, [objNull]];
private _return = [];

{
	if (_x isKindOf "RHNET_ab_moduleREPEATER_F") then {
		_return pushBack _x;
	};
} forEach synchronizedObjects _master;

_return
