/*
	File: fn_remote.sqf
	Author: Ari Höysniemi

	Description:
	Assign a portal to a remote client

	Parameter(s):
	0: OBJECT - headless client
	1: OBJECT - portal to be assigned

	Returns:
	Nothing
*/

_target		= _this select 0;
_portal		= _this select 1;

if (_target == format ["%1", player]) then {
	[_portal] spawn Actionbuilder_fnc_spawnUnits;
};

true