/*
	File: fn_getSynchronizedObjectTypes.sqf
	Author: Ari Höysniemi

	Description:
	Return an array of types, positions and directions of synchronized objects.

	Parameter(s):
	0: OBJECT - object with units synchronized
	1 (Optional): BOOL - true to remove object after the registeration (default: false)

	Returns:
	ARRAY of OBJECTs ex. [[typeOf x, getPosWorld x, getDir x], ... , [typeOf n, getPosWorld n, getDir n]]
*/

private["_master","_remove","_objects"];
_master		= param [0, objNull, [objNull]];
_remove		= param [1, false, [false]];
_objects	= [];

{
	if ((isNull group _x) && (side _x == CIVILIAN)) then {
		_objects pushBack [typeOf _x, getPosATL _x, getDir _x];
		if (_remove) then {
			deleteVehicle _x;
		};
	};
} forEach synchronizedObjects _master;

_objects