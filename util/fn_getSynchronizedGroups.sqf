/*
	File: fn_getSynchronizedGroups.sqf
	Author: Ari Höysniemi

	Description:
	Return an array of synchronized groups.

	Parameter(s):
	0: OBJECT - object with synchronizations
	1 (Optional): BOOL - true to remove groups after the registeration (default: false)

	Returns:
	ARRAY of GROUPSs
*/

private["_master","_remove","_groups"];
_master		= param [0, objNull, [objNull]];
_remove		= param [1, false, [false]];
_groups		= [];

{
	if (_x isKindOf "MAN") then {
		if !(group _x in _groups) then {
			_groups pushBack group _x;
		};
		if (_remove) then {
			deleteVehicle _x;
		};
	};
} forEach synchronizedObjects _master;

_groups