/*
	File: fn_getSynchronizedClosest.sqf
	Author: Ari Höysniemi

	Description:
	Return the closest synchronizated object (discards logics and triggers)

	Parameter(s):
	0: OBJECT - object with synchronizations
	1: BOOL - true to mirror function and look for the furthest object (default: false)

	Returns:
	OBJECT
*/

private _master = param [0, objNull, [objNull]];
private _mirror = param [1, false, [false]];
private _selected = objNull;
private _selectedDistance = -1;

{
	if !((_x isKindOf "LOGIC") || (_x isKindOf "EmptyDetector")) then {
		private _distance = _x distance _master;
		if (_selectedDistance == -1) then {
			_selected = _x;
			_selectedDistance = _distance;
		} else {
			if (_mirror) then {
				if (_distance > _selectedDistance) then {
					_selected = _x;
					_selectedDistance = _distance;
				};
			} else {
				if (_distance < _selectedDistance) then {
					_selected = _x;
					_selectedDistance = _distance;
				};
			};
		};
	};
} forEach synchronizedObjects _master;

_selected