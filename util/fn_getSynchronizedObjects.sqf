/*
	File: fn_getSynchronizedObjects.sqf
	Author: Ari Höysniemi

	Description:
	Return an array of synchronized objects.

	Parameter(s):
	0: OBJECT - object with synchronizations
	1 (Optional): BOOL - true to remove object after the registeration (default: false)

	Returns:
	ARRAY of OBJECTs
*/

private["_master","_remove","_objects"];
_master		= param [0, objNull, [objNull]];
_remove		= param [1, false, [false]];
_objects	= [];

{
	if ((isNull group _x) && (side _x == CIVILIAN)) then {
		_objects pushBack _x;
		if (_remove) then {
			deleteVehicle _x;
		};
	};
} forEach synchronizedObjects _master;

_objects