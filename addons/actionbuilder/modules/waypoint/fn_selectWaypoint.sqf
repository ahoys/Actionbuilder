/*
	File: fn_selectWaypoint.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_addWaypoint.sqf
	
	Description:
	Select a randomized waypoint

	Parameter(s):
	0: OBJECT - current location
	1: OBJECT - previous location
	2: ARRAY - banned locations

	Returns:
	OBJECT - the selected portal if any
*/
private _location = param [0, objNull, [objNull]];
private _previousLocation = param [1, objNull, [objNull]];
private _bannedLocations = param [2, [], [[]]];
private _candidates = [];
private _candidatesLocked = [];
private _candidatesPriority = [];
private _candidatesAhead = [];
private _selected = objNull;

// 1a. Find all possibilities
{
	if ((typeOf _x == "RHNET_ab_moduleWP_F") && (_x != _previousLocation) && !(_x in _bannedLocations)) then {
		private _wp = _x;
		private _valid = true;
		{
			if !(triggerActivated _x) exitWith {_candidatesLocked pushBack _wp; _valid = false};
		} forEach (_wp call BIS_fnc_moduleTriggers);
		if (_valid) then {_candidates pushBack _wp};
	};
} forEach (_location call BIS_fnc_moduleModules);

if (count (_candidates + _candidatesLocked) < 1) exitWith {objNull};

// 1b. Wait if only conditional waypoints available
while {count _candidates < 1} do {
	{
		private _wp = _x;
		{
			if (triggerActivated _x) exitWith {_candidates pushBack _wp};
			sleep 0.5;
		} forEach (_wp call BIS_fnc_moduleTriggers);
	} forEach _candidatesLocked;
};

// 2a. Find all high priorities
{
	if (_x getVariable ["WpSpecial", 0] == 2) then {
		_candidatesPriority pushBack _x;
	};
} forEach _candidates;

// 3a. Select a new waypoint and return it
if (count _candidatesPriority > 0) then {
	_candidatesAhead = [_group, _candidatesPriority, [_location, true]] call Actionbuilder_fnc_objectsAhead;
	if (count _candidatesAhead > 0) then {
		_selected = _candidatesAhead select floor random count _candidatesAhead;
	} else {
		_selected = _candidatesPriority select floor random count _candidatesPriority;
	};
} else {
	_candidatesAhead = [_group, _candidates, [_location, true]] call Actionbuilder_fnc_objectsAhead;
	if (count _candidatesAhead > 0) then {
		_selected = _candidatesAhead select floor random count _candidatesAhead;
	} else {
		_selected = _candidates select floor random count _candidates;
	};
};

_selected