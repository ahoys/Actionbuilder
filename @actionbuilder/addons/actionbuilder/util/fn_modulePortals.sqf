/*
	File: fn_modulePortals.sqf
	Author: Ari Höysniemi

	Description:
	Returns synchronized portal modules

	Parameter(s):
	0: OBJECT - master object
	1: BOOL - true to give an error on other module synchronizations

	Returns:
	ARRAY - a list of portals
*/
private _master	= param [0, objNull, [objNull]];
private _validate = param [1, false, [false]];
private _return = [];

{
	if (_x isKindOf "RHNET_ab_modulePORTAL_F") then {
		_return pushBack _x;
	} else {
		if (_validate) then {
			if (_x isKindOf "Logic" && !(_x isKindOf "RHNET_ab_moduleREPEATER_F")) then {
				["Not supported module %1 synchronized to %2.", typeOf _x, _master] call BIS_fnc_error;
			};
		};
	};
} forEach synchronizedObjects _master;

_return