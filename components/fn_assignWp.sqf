/*
	File: fn_assignWp.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: OBJECT - target group
	1: OBJECT - current location
	2: OBJECT - previous location

	Returns:
	BOOL - true, if success
*/

private[];
_group				= [_this, 0, grpNull, [grpNull]] call BIS_fnc_param;
_location 			= [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_previousLocation	= [_this, 2, objNull, [objNull]] call BIS_fnc_param;
_nextLocation		= objNull;
_candidates			= [];	// Open wp possibilities
_candidatesF		= [];	// Locked wp possibilities
_candidatesH		= [];	// High priority wp possibilities
_candidatesA		= [];	// Ahead positioned wp possibilities

if (isNil "_group" || isNil "_location") exitWith {
	["Required parameters missing!"] call BIS_fnc_error;
	false
};

// Find a new waypoint ----------------------------------------------------------------------------

// Find all waypoint possibilities
{
	if ((typeOf _x == "RHNET_ab_moduleWP_f") && (_x != _previousLocation)) then {
		_candidate = _x;
		_valid = true;
		{
			if !(triggerActivated _x) exitWith {_candidatesF pushBack _candidate; _valid = false};
		} forEach (_candidate call BIS_fnc_moduleTriggers);
		if (_valid) then {_candidates pushBack _candidate};
	};
} forEach (_location call BIS_fnc_moduleModules);

// No waypoints available
if (count (_candidates + _candidatesF) < 1) exitWith {false};

// Only conditional waypoints available
while {count _candidates < 1} do {
	{
		_candidate = _x;
		{
			if (triggerActivated _x) exitWith {_candidates pushBack _candidate};
			sleep .05;
		} forEach (_candidate call BIS_fnc_moduleTriggers);
		sleep .05;
	} forEach _candidatesF;
};

// Look for high priority waypoints
{
	if (_x getVariable ["WpSpecial", 0] == 2) then {
		_candidatesH pushBack _x;
	};
} forEach _candidates;

diag_log format ["WAYPOINT CANDIDATES: %1",_candidates];

// Select a new waypoint
if (count _candidatesH > 0) then {
	_candidatesA = [_group, _candidatesH, [_location, true]] call Actionbuilder_fnc_objectsAhead;
	if (count _candidatesA > 0) then {
		_nextLocation = _candidatesA select floor random count _candidatesA;
	} else {
		_nextLocation = _candidatesH select floor random count _candidatesH;
	};
} else {
	_candidatesA = [_group, _candidates, [_location, true]] call Actionbuilder_fnc_objectsAhead;
	diag_log format ["WAYPOINT CANDIDATES AHEAD: %1", _candidatesA];
	if (count _candidatesA > 0) then {
		_nextLocation = _candidatesA select floor random count _candidatesA;
	} else {
		_nextLocation = _candidates select floor random count _candidates;
	};
};

diag_log format ["WAYPOINT SUCCESS! Group %1 Next location: %2, Previous: %3", _group, _nextLocation, _location];

// Assign a new waypoint --------------------------------------------------------------------------
/*
_wpType			= _nextLocation getVariable ["WpType","MOVE"];
_wpBehaviour	= _nextLocation getVariable ["WpBehaviour","UNCHANGED"];
_wpSpeed		= _nextLocation getVariable ["WpSpeed","UNCHANGED"];
_wpFormation	= _nextLocation getVariable ["WpFormation","NO CHANGE"];
_wpMode			= _nextLocation getVariable ["WpMode","NO CHANGE"];
_wpWait			= _nextLocation getVariable ["WpWait",0];
_wpPlacement	= _nextLocation getVariable ["WpPlacement",0];
_wpSpecial		= _nextLocation getVariable ["WpSpecial",0];
_wpStatement	= ["true", format ["[%1,%2,%3] spawn Actionbuilder_fnc_assignWp", _group, _nextLocation, _previousLocation]];
*/

true