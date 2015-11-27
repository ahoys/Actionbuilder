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

private["_group","_possibilities","_reference","_investigateAll","_refUnit","_c","_subjects","_currentDirection","_currentLocation","_objectsAhead","_target"];
_group				= [_this, 0, grpNull, [grpNull]] call BIS_fnc_param;
_possibilities		= [_this, 1, [], [[objNull]]] call BIS_fnc_param;
_reference			= [_this, 2, [objNull,true], [[objNull,true]]] call BIS_fnc_param;
_investigateAll		= [_this, 3, false, [false]] call BIS_fnc_param;
_refUnit			= _reference select 0;
_c					= true;
_subjects			= [];
_objectsAhead		= [];

if (isNull _group || (count _possibilities < 1)) exitWith {_objectsAhead};
if (_investigateAll) then {_subjects = units _group} else {_subjects = [leader _group]};

// use reference object
if !(isNil "_refUnit") then {
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
	_target = _x;
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