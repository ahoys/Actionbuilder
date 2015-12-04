/*
	File: fn_selectWp.sqf
	Author: Ari Höysniemi
	
	Extension for:
	fn_assignWp.sqf
	
	Other calls are not supported.
*/
private["_group","_location","_previousLocation","_usedWaypoints","_candidates","_candidatesLocked","_candidatesPriority","_candidatesAhead","_selected","_deniedKey","_denied"];

_group				= _this select 0;
_location			= _this select 1;
_previousLocation	= _this select 2;
_usedWaypoints		= [];
_candidates			= [];
_candidatesLocked	= [];
_candidatesPriority	= [];
_candidatesAhead	= [];
_selected			= objNull;
_deniedKey			= ACTIONBUILDER_locations_denied find _group;

if (_deniedKey >= 0) then {
	_denied = ACTIONBUILDER_locations_denied select (_deniedKey + 1);
} else {
	_denied = [];
};

// 1a. Find all possibilities
{
	if ((typeOf _x == "RHNET_ab_moduleWP_f") && (_x != _previousLocation) && !(_x in _denied)) then {
		_wp = _x;
		_valid = true;
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
		_wp = _x;
		{
			if (triggerActivated _x) exitWith {_candidates pushBack _wp};
			sleep ACTIONBUILDER_buffer;
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