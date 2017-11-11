/*
	File: fn_objectsAhead.sqf
	Author: Ari Höysniemi

	Description:
	Returns a list of objects that are located ahead

	Parameter(s):
	0: GROUP - target group
	1: ARRAY - list of objects to be investigated
	2 (Optional): ARRAY in format
		0: OBJECT - reference object for overriding the group's direction
		1: BOOL - true to ignore reference, if the reference's direction is 0. (default: true)
	3 (Optional): BOOL - true to check all group members instead of just the leader, overriding parameter 2 (default: false)

	Returns:
	ARRAY - List of found objects ahead
*/

private _group				= param [0, grpNull, [grpNull]];
private _possibilities		= param [1, [], [[objNull]]];
private _reference			= param [2, [objNull, true], [[objNull, true]]];
private _investigateAll		= param [3, false, [false]];
private _refUnit			= _reference select 0;
private _c					= true;
private _subjects			= [];
private _objectsAhead		= [];

if (isNull _group || (count _possibilities < 1)) exitWith {_objectsAhead};
if (_investigateAll) then {_subjects = units _group} else {_subjects = [leader _group]};

// use reference object
if !(isNil "_refUnit") then {
	private _currentDirection = 0;
	private _currentLocation = [];
	if (_reference select 1) then {
		if (getDir _refUnit != 0) then {
			_currentDirection = getDir _refUnit;
			_currentLocation = position _refUnit;
			_c = false;
		};
	} else {
		_currentDirection = getDir _refUnit;
		_currentLocation = position _refUnit;
		_c = false;
	};
};

{
	private _target = _x;
	{
		if (_c) then {
			_currentDirection = getDir _x;
			_currentLocation = position _x;
		};
		if ([_currentLocation, _currentDirection, 180, position _target] call BIS_fnc_inAngleSector) then {
			_objectsAhead pushBack _target;
		};
	} forEach _subjects;
} forEach _possibilities;

_objectsAhead