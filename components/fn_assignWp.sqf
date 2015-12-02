/*
	File: fn_assignWp.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: OBJECT - target group
	1: NUMBER - current location id
	2: NUMBER - previous location id

	Returns:
	BOOL - true, if success
*/

private[
	"_group",
	"_locationId",
	"_previousLocationId",
	"_nextLocation",
	"_nextLocationId",
	"_location",
	"_previousLocation",
	"_candidate",
	"_candidatesA",
	"_candidatesF",
	"_candidatesH",
	"_valid",
	"_candidates",
	"_wpType",
	"_wpBehaviour",
	"_wpSpeed",
	"_wpFormation",
	"_wpMode",
	"_wpWait",
	"_wpPlacement",
	"_wpSpecial",
	"_wpStateText",
	"_wpStatement",
	"_wpLocation",
	"_wpRadius",
	"_leader",
	"_vehicle",
	"_skip",
	"_otherUnits",
	"_bestDistance",
	"_target",
	"_otherUnits"
];

_group				= [_this, 0, grpNull, [grpNull]] call BIS_fnc_param;
_locationId 		= [_this, 1, -1, [0]] call BIS_fnc_param;
_previousLocationId	= [_this, 2, -1, [0]] call BIS_fnc_param;
_nextLocation		= objNull;
_location			= objNull;
_previousLocation	= objNull;
_candidates			= [];		// Open wp possibilities
_candidatesF		= [];		// Locked wp possibilities
_candidatesH		= [];		// High priority wp possibilities
_candidatesA		= [];		// Ahead positioned wp possibilities

// Group or location can't be empty
if (isNil "_group") exitWith {
	["Required parameters missing or invalid!"] call BIS_fnc_error;
	false
};

// Validate given IDs
if (!([ACTIONBUILDER_locations, _locationId] call Actionbuilder_fnc_isValidKey)) exitWith {
	["Invalid location ID!"] call BIS_fnc_error;
	false
};

if ([ACTIONBUILDER_locations, _previousLocationId] call Actionbuilder_fnc_isValidKey) then {
	_previousLocation = ACTIONBUILDER_locations select _previousLocationId;
};

_location = ACTIONBUILDER_locations select _locationId;

// Find a new waypoint ----------------------------------------------------------------------------

// Find all waypoint possibilities
{
	if ((typeOf _x == "RHNET_ab_moduleWP_f") && (_x != _previousLocation) && !(_x in ACTIONBUILDER_waypoint_used)) then {
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

_nextLocationId = _nextLocation find ACTIONBUILDER_locations;

// Initialize the new waypoint --------------------------------------------------------------------
_wpType			= _nextLocation getVariable ["WpType","MOVE"];
_wpBehaviour	= _nextLocation getVariable ["WpBehaviour","UNCHANGED"];
_wpSpeed		= _nextLocation getVariable ["WpSpeed","UNCHANGED"];
_wpFormation	= _nextLocation getVariable ["WpFormation","NO CHANGE"];
_wpMode			= _nextLocation getVariable ["WpMode","NO CHANGE"];
_wpWait			= _nextLocation getVariable ["WpWait",0];
_wpPlacement	= _nextLocation getVariable ["WpPlacement",0];
_wpSpecial		= _nextLocation getVariable ["WpSpecial",0];
_wpStateText	= format ["[group this, %1, %2] spawn Actionbuilder_fnc_assignWp", _nextLocationId, _locationId];
_wpStatement	= ["true", _wpStateText];
_wpLocation		= [_nextLocation] call Actionbuilder_fnc_getClosestSynced;
_wpRadius		= 8;
_leader			= leader _group;
_vehicle		= vehicle _leader;
_skip			= false;

// Use a waypoint location if there are no valid units synchronized to the waypoint
if (isNull _wpLocation) then {
	_wpLocation = getPosATL _nextLocation;
};

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
	if (!alive _leader) exitWith {false};
	_skip = true;
};

// Special property: placement							// Not tested
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

// Special property: command
// Affects entire group and objects linked to the waypoint
if ((_wpType == "TARGET") || (_wpType == "FIRE")) then {
	_otherUnits = _nextLocation call BIS_fnc_moduleUnits;
	if (count _otherUnits > 0) then {
		_result = [_group, _otherUnits, _wpType] spawn Actionbuilder_fnc_command;
	} else {
		_result = [_group, _nextLocation, _wpType] spawn Actionbuilder_fnc_command;
	};
	if (_result) then {
		// Let the units target for a while.
		_skip = true;
		sleep 5;
	};
};

// Adjust completion distance							// Not tested
if (_vehicle isKindOf "MAN") then {_wpRadius = 2};
if (_vehicle isKindOf "AIR") then {_wpRadius = 30; _wpLocation set [2, (_wpLocation select 2) + 100]};
if (_vehicle isKindOf "CAR") then {_wpRadius = 5};
if (_vehicle isKindOf "TANK") then {_wpRadius = 8};
if (_vehicle isKindOf "SHIP") then {_wpRadius = 20};

// Special property: reusability						// Not tested
// 1: Waypoint can be used only once
if (_wpSpecial == 1) then {
	ACTIONBUILDER_waypoint_used pushBack _nextLocation;
	publicVariable ACTIONBUILDER_waypoint_used;
};

// Skip to the next waypoint if required
if (_skip) exitWith {
	[_group, _nextLocation, _location] spawn Actionbuilder_fnc_assignWp;
	true
};

diag_log format ["%1, %2, %3", _group, _wpLocation, _wpRadius];
diag_log format ["%1, %2, %3, %4, %5, %6",
_wpType,
_wpBehaviour,
_wpSpeed,
_wpFormation,
_wpMode,
_wpStatement
];

// TODO: SVA

// Assign the new waypoint ------------------------------------------------------------------------
_group = _group addWaypoint [_wpLocation, _wpRadius];
_group setWaypointType _wpType;
_group setWaypointBehaviour _wpBehaviour;
_group setWaypointSpeed _wpSpeed;
_group setWaypointFormation _wpFormation;
_group setWaypointCombatMode _wpMode;
_group setWaypointStatements _wpStatement;

// TODO: GETIN, FORCE GETIN

true