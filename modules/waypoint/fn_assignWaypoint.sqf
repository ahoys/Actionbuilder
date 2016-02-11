/*
	File: fn_assignWaypoint.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: OBJECT - target group

	Returns:
	BOOL - true, if success
*/

if (!isServer && hasInterface) exitWith {};
diag_log format ["AB - wp assignment at time: %1", time];

private[
	"_group",
	"_nextLocation",
	"_key",
	"_query",
	"_id",
	"_portal",
	"_location",
	"_previousLocation",
	"_bannedLocations",
	"_wpType",
	"_wpBehaviour",
	"_wpSpeed",
	"_wpFormation",
	"_wpMode",
	"_wpWait",
	"_wpPlacement",
	"_wpSpecial",
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
	"_wp"
];

// ----------------------------------------------------------------------------
// FIRST OBJECTIVE: COLLECT REQUIRED DATA ABOUT THE REQUEST

_group					= _this select 0;
_nextLocation			= objNull;

// Group can't be empty
if (isNil "_group") exitWith {
	["Required group parameter is missing or invalid!"] call BIS_fnc_error;
	false
};

// Group query
_key					= (RHNET_AB_L_GROUPPROGRESS find _group) + 1;
if (_key < 0) 			exitWith {["Group %1 could not be found from the register.", _group] call BIS_fnc_error; false};
_query					= RHNET_AB_L_GROUPPROGRESS select _key;
_id						= _query select 0;
_portal					= _query select 1;
if (_id == 0) then {
	_location			= _portal;
	_previousLocation 	= objNull;
	_bannedLocations	= [];
} else {
	_location			= _query select 2;
	_previousLocation 	= _query select 3;
	_bannedLocations	= _query select 4;
};

// ----------------------------------------------------------------------------
// NEXT OBJECTIVE: SELECT A NEW WAYPOINT

_nextLocation = [_location, _previousLocation, _bannedLocations] call Actionbuilder_fnc_selectWaypoint;
if (isNull _nextLocation) exitWith {false};

// ----------------------------------------------------------------------------
// NEXT OBJECTIVE: DEFINE THE SELECTED WAYPOINT

// Collect the required variables
_wpType			= _nextLocation getVariable ["WpType","MOVE"];
_wpBehaviour	= _nextLocation getVariable ["WpBehaviour","UNCHANGED"];
_wpSpeed		= _nextLocation getVariable ["WpSpeed","UNCHANGED"];
_wpFormation	= _nextLocation getVariable ["WpFormation","NO CHANGE"];
_wpMode			= _nextLocation getVariable ["WpMode","NO CHANGE"];
_wpWait			= parseNumber (_nextLocation getVariable ["WpWait",0]);
_wpPlacement	= _nextLocation getVariable ["WpPlacement",0];
_wpSpecial		= _nextLocation getVariable ["WpSpecial",0];
_wpStatement	= ["true", "[group this] spawn Actionbuilder_fnc_assignWaypoint"];
_wpLocation		= _nextLocation call Actionbuilder_fnc_getSynchronizedClosest;
_wpRadius		= 8;
_leader			= leader _group;
_vehicle		= objectParent _leader;
_skip			= false;

// Use the waypoint's location if there are no valid units synchronized to the waypoint
if (isNull _wpLocation) then {
	_wpLocation = getPosATL _nextLocation;
};

_wpDistance = _leader distance _wpLocation;

// Special property: wait
if (_wpWait isEqualType 0) then {
	sleep _wpWait;
};

// Special property: u-turn
// Go back to the previous waypoint
if (_wpType == "UTURN") exitWith {
	if (typeOf _location != "RHNET_ab_modulePORTAL_f") exitWith {
		(RHNET_AB_L_GROUPPROGRESS select _key) set [0, _id + 1];
		(RHNET_AB_L_GROUPPROGRESS select _key) set [2, _location];
		(RHNET_AB_L_GROUPPROGRESS select _key) set [3, _nextLocation];
		[_group] spawn Actionbuilder_fnc_assignWaypoint;
		false
	};
};

// Update register
(RHNET_AB_L_GROUPPROGRESS select _key) set [0, _id + 1];
(RHNET_AB_L_GROUPPROGRESS select _key) set [2, _nextLocation];
(RHNET_AB_L_GROUPPROGRESS select _key) set [3, _location];

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

// Special property: placement
// 0: original positioning, 1: look for players
if (_wpPlacement == 1) then {
	_bestDistance = -1;
	_target = objNull;
	{
		if !((objectParent _x isKindOf "Air") || (objectParent _x isKindOf "Ship")) then {
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

// Special property: reusability
// 1: Waypoint can be used only once / group
if (_wpSpecial == 1) then {
	((RHNET_AB_L_GROUPPROGRESS select _key) select 4) pushBack _nextLocation;
};

// Completion distance
call {
	if (isNull _vehicle) exitWith {_wpRadius = 2};
	if (_vehicle isKindOf "AIR") exitWith {_wpRadius = 30; _wpLocation set [2, (_wpLocation select 2) + 100]};
	if (_vehicle isKindOf "CAR") exitWith {_wpRadius = 5};
	if (_vehicle isKindOf "TANK") exitWith {_wpRadius = 8};
	if (_vehicle isKindOf "SHIP") exitWith {_wpRadius = 20};
};

// Already next to the waypoint
if (
		(_wpDistance < (_wpRadius + 4)) && 
		(_wpType == "MOVE") && 
		((_wpBehaviour == "UNCHANGED") || (_wpFormation == "UNCHANGED") || (_wpMode == "UNCHANGED"))
	) then {
	_skip = true;
	sleep (0.5);
};

// Special property: send vehicles away
if (_wpType == "SVA") then {
	[_group, _portal] call Actionbuilder_fnc_sendVehiclesAway;
};

// Skip to the next waypoint if required
if (_skip) exitWith {
	[_group] spawn Actionbuilder_fnc_assignWaypoint;
	true
};

// ----------------------------------------------------------------------------
// NEXT OBJECTIVE: ASSIGN THE WAYPOINT TO THE GROUP

call {
	if (_wpType == "GETIN") exitWith {[_group, false, 50] call Actionbuilder_fnc_loadVehicles; _wpLocation = position _leader};
	if (_wpType == "UNLOAD") exitWith {[_group, false] call Actionbuilder_fnc_unloadVehicles; _wpLocation = position _leader};
	if (_wpType == "FORCE") exitWith {[_group, true, 50] call Actionbuilder_fnc_loadVehicles; _wpLocation = position _leader};
	if (_wpType == "GETOUT") exitWith {[_group, true] call Actionbuilder_fnc_unloadVehicles; _wpLocation = position _leader};
};

// Translate special cases
if (
	(_wpType != "MOVE") &&
	(_wpType != "SAD") &&
	(_wpType != "GUARD") &&
	(_wpType != "DISMISSED")
) then {
	_wpType = "MOVE";
};

// Assign the new waypoint
_wp = _group addWaypoint [_wpLocation, _wpRadius];
_wp setWaypointType _wpType;
_wp setWaypointBehaviour _wpBehaviour;
_wp setWaypointSpeed _wpSpeed;
_wp setWaypointFormation _wpFormation;
_wp setWaypointCombatMode _wpMode;
_wp setWaypointStatements _wpStatement;

true