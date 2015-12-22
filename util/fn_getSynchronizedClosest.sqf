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

private["_master","_excludes","_mirror","_selected","_selectedDistance"];
_master		= param [0, objNull, [objNull]];
_mirror		= param [1, false, [false]];
_selected	= objNull;

{
	if !((_x isKindOf "LOGIC") || (_x isKindOf "EmptyDetector")) then {
		_distance = _x distance _master;
		if (isNil "_selectedDistance") then {
			_selected 					= _x;
			_selectedDistance 			= _distance;
		} else {
			if (_mirror) then {
				if (_distance > _selectedDistance) then {
					_selected 			= _x;
					_selectedDistance 	= _distance;
				};
			} else {
				if (_distance < _selectedDistance) then {
					_selected 			= _x;
					_selectedDistance 	= _distance;
				};
			};
		};
	};
} forEach synchronizedObjects _master;

_selected