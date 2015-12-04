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
	"_wpDistance",
	"_vehicle",
	"_skip",
	"_otherUnits",
	"_bestDistance",
	"_target",
	"_otherUnits",
	"_key"
];
_group				= [_this, 0, grpNull, [grpNull]] call BIS_fnc_param;
_portalId			= [_this, 1, -1, [0]] call BIS_fnc_param;
_locationId 		= [_this, 2, -1, [0]] call BIS_fnc_param;
_previousLocationId	= [_this, 3, -1, [0]] call BIS_fnc_param;
_portal				= ACTIONBUILDER_locations select _portalId;
_nextLocation		= objNull;
_location			= objNull;
_previousLocation	= objNull;

// Group or location can't be empty
if (isNil "_group") exitWith {
	["Required parameters missing or invalid!"] call BIS_fnc_error;
	false
};

// Validate given IDs
if (!([ACTIONBUILDER_locations, _portalId] call Actionbuilder_fnc_isValidKey)) exitWith {
	["Invalid portal ID!"] call BIS_fnc_error;
	false
};

if (!([ACTIONBUILDER_locations, _locationId] call Actionbuilder_fnc_isValidKey)) exitWith {
	["Invalid location ID!"] call BIS_fnc_error;
	false
};

if ([ACTIONBUILDER_locations, _previousLocationId] call Actionbuilder_fnc_isValidKey) then {
	_previousLocation = ACTIONBUILDER_locations select _previousLocationId;
};

_location = ACTIONBUILDER_locations select _locationId;

// ----------------------------------------------------------------------------
// NEXT OBJECTIVE: SELECT A NEW WAYPOINT

_nextLocation 	= [_group, _location, _previousLocation] call Actionbuilder_fnc_selectWp;
if (isNull _nextLocation) exitWith {false};
_nextLocationId	= ACTIONBUILDER_locations find _nextLocation;

// ----------------------------------------------------------------------------
// NEXT OBJECTIVE: DEFINE THE SELECTED WAYPOINT

// Collect the required variables
_wpType			= _nextLocation getVariable ["WpType","MOVE"];
_wpBehaviour	= _nextLocation getVariable ["WpBehaviour","UNCHANGED"];
_wpSpeed		= _nextLocation getVariable ["WpSpeed","UNCHANGED"];
_wpFormation	= _nextLocation getVariable ["WpFormation","NO CHANGE"];
_wpMode			= _nextLocation getVariable ["WpMode","NO CHANGE"];
_wpWait			= _nextLocation getVariable ["WpWait",0];
_wpPlacement	= _nextLocation getVariable ["WpPlacement",0];
_wpSpecial		= _nextLocation getVariable ["WpSpecial",0];
_wpStateText	= format ["[group this, %1, %2, %3] spawn Actionbuilder_fnc_assignWp", _portalId, _nextLocationId, _locationId];
_wpStatement	= ["true", _wpStateText];
_wpLocation		= [_nextLocation] call Actionbuilder_fnc_getClosestSynced;
_wpRadius		= 8;
_leader			= leader _group;
_vehicle		= vehicle _leader;
_skip			= false;

// Use the waypoint's location if there are no valid units synchronized to the waypoint
if (isNull _wpLocation) then {
	_wpLocation = getPosATL _nextLocation;
};

_wpDistance		= _leader distance _wpLocation;

// Special property: wait								// Does not work	
if (typeName _wpWait == "NUMBER") then {
	sleep _wpWait;
};

// Special property: u-turn
// Go back to the previous waypoint
if (_wpType == "UTURN") exitWith {
	if (typeOf _location != "RHNET_ab_modulePORTAL_f") exitWith {
		[_group, _portalId, _locationId, _nextLocationId] spawn Actionbuilder_fnc_assignWp;
		false
	};
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
// 0: original positioning, 1: look for players
if (_wpPlacement == 1) then {
	_bestDistance = -1;
	_target = objNull;
	{
		if !((vehicle _x isKindOf "Air") || (vehicle _x isKindOf "Ship")) then {
			if (((_x distance _nextLocation) < _bestDistance) || (_bestDistance < 0)) then {
				_target = _x;
			};
		};
	} forEach (switchableUnits + playableUnits);
	_wpLocation = getPosATL _target;
};

// Special property: command
// Affects the entire group and objects linked to the waypoint
if ((_wpType == "TARGET") || (_wpType == "FIRE")) then {
	_otherUnits = _nextLocation call BIS_fnc_moduleUnits;
	if (count _otherUnits > 0) then {
		_result = [_group, _otherUnits, _wpType] spawn Actionbuilder_fnc_command;
	} else {
		_result = [_group, _nextLocation, _wpType] spawn Actionbuilder_fnc_command;
	};
	if (_result) then {
		_skip = true;
		sleep 5;
	};
};

// Special property: reusability						// Not tested
// 1: Waypoint can be used only once / group
if (_wpSpecial == 1) then {
	_key = ACTIONBUILDER_locations_denied find _group;
	if (_key < 0) then {
		ACTIONBUILDER_locations_denied pushBack _group;
		ACTIONBUILDER_locations_denied pushBack [_nextLocation];
	} else {
		(ACTIONBUILDER_locations_denied select (_key + 1)) pushBack _nextLocation;
	};
	publicVariable "ACTIONBUILDER_locations_denied";	// Might affect HC
};

// Completion distance
if (_vehicle isKindOf "MAN") then {_wpRadius = 2};
if (_vehicle isKindOf "AIR") then {_wpRadius = 30; _wpLocation set [2, (_wpLocation select 2) + 100]};
if (_vehicle isKindOf "CAR") then {_wpRadius = 5};
if (_vehicle isKindOf "TANK") then {_wpRadius = 8};
if (_vehicle isKindOf "SHIP") then {_wpRadius = 20};

// Already next to the waypoint
if (
		(_wpDistance < (_wpRadius + 4)) && 
		(_wpType == "MOVE") && 
		((_wpBehaviour == "UNCHANGED") || (_wpFormation == "UNCHANGED") || (_wpMode == "UNCHANGED"))
	) then {
	_skip = true;
	sleep (ACTIONBUILDER_buffer + 0.5);
};

// Special property: send vehicles away
if (_wpType == "SVA") then {							// Not tested
	[_group, _portal] call Actionbuilder_fnc_sva;
};

// Skip to the next waypoint if required
if (_skip) exitWith {
	[_group, _portalId, _nextLocationId, _locationId] spawn Actionbuilder_fnc_assignWp;
	true
};

// ----------------------------------------------------------------------------
// NEXT OBJECTIVE: ASSIGN THE WAYPOINT TO THE GROUP

// Assign the new waypoint
_group = _group addWaypoint [_wpLocation, _wpRadius];
_group setWaypointType _wpType;
_group setWaypointBehaviour _wpBehaviour;
_group setWaypointSpeed _wpSpeed;
_group setWaypointFormation _wpFormation;
_group setWaypointCombatMode _wpMode;
_group setWaypointStatements _wpStatement;

// TODO: GETIN, FORCE GETIN

true