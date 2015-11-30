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
diag_log "ACTIONBUILDER WAYPOINT ----------------------------------";
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
	if (count _candidatesA > 0) then {
		_nextLocation = _candidatesA select floor random count _candidatesA;
	} else {
		_nextLocation = _candidates select floor random count _candidates;
	};
};

// Assign a new waypoint --------------------------------------------------------------------------

_wpType			= _nextLocation getVariable ["WpType","MOVE"];
_wpBehaviour	= _nextLocation getVariable ["WpBehaviour","UNCHANGED"];
_wpSpeed		= _nextLocation getVariable ["WpSpeed","UNCHANGED"];
_wpFormation	= _nextLocation getVariable ["WpFormation","NO CHANGE"];
_wpMode			= _nextLocation getVariable ["WpMode","NO CHANGE"];
_wpWait			= _nextLocation getVariable ["WpWait",0];
_wpPlacement	= _nextLocation getVariable ["WpPlacement",0];
_wpSpecial		= _nextLocation getVariable ["WpSpecial",0];
_wpStatement	= ["true", format ["[%1,%2,%3] spawn Actionbuilder_fnc_assignWp", _group, _nextLocation, _location]];
_wpLocation		= getPosATL _nextLocation;
_wpCompletion	= 8;
_leader			= leader _group;
_vehicle		= vehicle _leader;

// Special property: wait								// Does not work	
if (typeName _wpWait == "SCALAR") then {
	sleep _wpWait;
};

// Special property: punish
// Affects entire group and objects linked to the waypoint
if ((_wpType == "KILL") || (_wpType == "NEUTRALIZE") || (_wpType == "REMOVE") || (_wpType == "HURT") || (_wpType == "HEAL")) then {
	[_group, _wpType] call Actionbuilder_fnc_punish;
	_otherUnits = _nextLocation call BIS_fnc_moduleUnits;
	{
		[_x, _wpType] spawn Actionbuilder_fnc_punish;
	} forEach _otherUnits;
};

if (!alive _leader) exitWith {true};
diag_log format ["Yhä jatkuu %1 jälkeen!", _wpType];

// Special property: placement
// 1: Look for players
if (_wpPlacement == 1) then {
	_bestDistance = -1;
	_target = objNull;
	{
		if !(vehicle _x isKindOf "Air") then {
			if (((_x distance _nextLocation) < _bestDistance) || (_bestDistance < 0)) then {
				_target = _x;
			};
		};
	} forEach (switchableUnits + playableUnits);
	_wpLocation = getPosATL _target;
};

// Adjust completion distance
if (_vehicle isKindOf "MAN") then {_wpCompletion = 2};
if (_vehicle isKindOf "AIR") then {_wpCompletion = 30; _wpLocation set [2, (_wpLocation select 2) + 100]};
if (_vehicle isKindOf "CAR") then {_wpCompletion = 5};
if (_vehicle isKindOf "TANK") then {_wpCompletion = 8};
if (_vehicle isKindOf "SHIP") then {_wpCompletion = 20};



/*
// Special property: type
// KILL: kill all units in the group
if (_wpType == "REMOVE") exitWith {
	{
		if (_x isKindOf "MAN") then {
			deleteVehicle _x;
		} else {
			{
				deleteVehicle _x;
			} forEach crew _x;
			deleteVehicle vehicle _x;
		};
	} forEach units _group;
	true
};

// Special property: type
// KILL: kill all units in the group
if (_wpType == "KILL") exitWith {
	{
		if (_x isKindOf "MAN") then {
			_x setDamage 1;
		} else {
			{
				_x setDamage 1;
			} forEach crew _x;
			(vehicle _x) setDamage 1;
		};
	} forEach units _group;
	true
};

// Special property: type
// NEUTRALIZE: kill all units in the group
if (_wpType == "NEUTRALIZE") exitWith {
	{
		if (_x isKindOf "MAN") then {
			_x spawn BIS_fnc_neutralizeUnit;
		} else {
			{
				_x setDamage 1;
			} forEach crew _x;
			_x spawn BIS_fnc_neutralizeUnit;
		};
	} forEach units _group;
	true
};
*/
// Special property: reusability
// 1: Waypoint can be used only once
if (_wpSpecial == 1) then {
	deleteVehicle _nextLocation;
};

true