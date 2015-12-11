/*
	File: fn_getClosestSynced.sqf
	Author: Ari Höysniemi

	Description:
	Returns the closest synchronized unit

	Parameter(s):
	0: OBJECT - point of reference

	Returns:
	OBJECT - the closest object, null if none
*/

private["_reference","_units","_closest","_distance"];
_reference = param [0, objNull, [objNull]];

if (isNil "_reference") exitWith {
	["Required init reference missing!"] call BIS_fnc_error;
	objNull
};

_units = _reference call BIS_fnc_moduleUnits;

if (count _units < 1) exitWith {objNull};
_closest = objNull;
_distance = -1;

{
	if (!isNil "_x") then {
		if (((_x distance _reference) < _distance) || (_distance < 0)) then {
			if (isNull objectParent _x) then {
				// MAN
				_distance = (_x distance _reference);
				_closest = _x;
			} else {
				// VEHICLE
				_distance = (objectParent _x distance _reference);
				_closest = objectParent _x;
			};
		};
	};
} forEach _units;

_closest