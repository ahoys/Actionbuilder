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
	0: GROUP - target group
	1: OBJECT - current location
	2: OBJECT - previous location
	3: ARRAY - banned locations

	Returns:
	OBJECT - the selected portal if any
*/
private _group = param [0, grpNull, [grpNull]];
private _location = param [1, objNull, [objNull]];
private _previousLocation = param [2, objNull, [objNull]];
private _bannedLocations = param [3, [], [[]]];
private _candidates = [];
private _candidatesLocked = [];
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
private _highPriorityCandidates = [];
{
	if (_x getVariable ["WpSpecial", 0] == 2) then {
		_highPriorityCandidates pushBack _x;
	};
} forEach _candidates;

// 3a. Find all normal & low priorities
private _normalPriorityCandidates = [];
private _lowPriorityCandidates = [];
private _i = 0;
{
	if (_x getVariable ["WpSpecial", 0] == 3) then {
		_lowPriorityCandidates pushBack _x;
	} else {
		_normalPriorityCandidates pushBack _x;
	};
	_i = _i + 1;
} forEach _candidates;

// 3a. Select a new waypoint and return it
if !(_highPriorityCandidates isEqualTo []) then {
	// High priority targets.
	private _candidatesAhead = [_group, _highPriorityCandidates, [_location, true]] call Actionbuilder_fnc_objectsAhead;
	if !(_candidatesAhead isEqualTo []) then {
		_selected = _candidatesAhead select floor random count _candidatesAhead;
	} else {
		_selected = _highPriorityCandidates select floor random count _highPriorityCandidates;
	};
} else {
	if !(_normalPriorityCandidates isEqualTo []) then {
		// Normal priority targets.
		private _candidatesAhead = [_group, _normalPriorityCandidates, [_location, true]] call Actionbuilder_fnc_objectsAhead;
		if !(_candidatesAhead isEqualTo []) then {
			_selected = _candidatesAhead select floor random count _candidatesAhead;
		} else {
			_selected = _normalPriorityCandidates select floor random count _normalPriorityCandidates;
		};
	} else {
		// Low priority targets.
		private _candidatesAhead = [_group, _lowPriorityCandidates, [_location, true]] call Actionbuilder_fnc_objectsAhead;
		if !(_candidatesAhead isEqualTo []) then {
			_selected = _candidatesAhead select floor random count _candidatesAhead;
		} else {
			_selected = _lowPriorityCandidates select floor random count _lowPriorityCandidates;
		};
	};
};

_selected