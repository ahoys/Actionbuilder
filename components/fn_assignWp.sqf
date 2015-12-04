/*
	File: fn_assignWp.sqf
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
	"_target"
];

// ----------------------------------------------------------------------------
// FIRST OBJECTIVE: COLLECT REQUIRED DATA ABOUT THE REQUEST

_group					= [_this, 0, grpNull, [grpNull]] call BIS_fnc_param;
_nextLocation			= objNull;

// Group can't be empty
if (isNil "_group") exitWith {
	["Required group parameter is missing or invalid!"] call BIS_fnc_error;
	false
};

// Group query
_key					= ACTIONBUILDER_groupProgress find _group;
if (_key < 0) 			exitWith {["Group %1 could not be found from the register.", _group] call BIS_fnc_error; false};
_query					= ACTIONBUILDER_groupProgress select (_key + 1);
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

_nextLocation = [_location, _previousLocation, _bannedLocations] call Actionbuilder_fnc_selectWp;
if (isNull _nextLocation) exitWith {false};

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
_wpStatement	= ["true", "[group this] spawn Actionbuilder_fnc_assignWp"];
_wpLocation		= [_nextLocation] call Actionbuilder_fnc_getClosestSynced;
_wpRadius		= 8;
_leader			= leader _group;
_vehicle		= vehicle _leader;
_skip			= false;

// Use the waypoint's location if there are no valid units synchronized to the waypoint
if (isNull _wpLocation) then {
	_wpLocation = getPosATL _nextLocation;
};

_wpDistance = _leader distance _wpLocation;

// Special property: wait								// Does not work	
if (_wpWait isEqualType 0) then {
	sleep _wpWait;
};

// Special property: u-turn
// Go back to the previous waypoint
if (_wpType == "UTURN") exitWith {
	if (typeOf _location != "RHNET_ab_modulePORTAL_f") exitWith {
		((ACTIONBUILDER_groupProgress select (_key + 1)) select 2) pushBack _location;
		((ACTIONBUILDER_groupProgress select (_key + 1)) select 3) pushBack _nextLocation;
		[_group] spawn Actionbuilder_fnc_assignWp;
		false
	};
};

// Update register
((ACTIONBUILDER_groupProgress select (_key + 1)) select 2) pushBack _nextLocation;
((ACTIONBUILDER_groupProgress select (_key + 1)) select 3) pushBack _location;

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
	((ACTIONBUILDER_groupProgress select (_key + 1)) select 4) pushBack _nextLocation;
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
	[_group, _portal] call Actionbuilder_fnc_wpSva;
};

// Skip to the next waypoint if required
if (_skip) exitWith {
	[_group] spawn Actionbuilder_fnc_assignWp;
	true
};

// ----------------------------------------------------------------------------
// NEXT OBJECTIVE: ASSIGN THE WAYPOINT TO THE GROUP

// Translate special cases
if (
	(_wpType != "MOVE") &&
	(_wpType != "SAD") &&
	(_wpType != "GUARD") &&
	(_wpType != "DISMISSED")
) then {
	_wpType == "MOVE";
};

// Assign the new waypoint
_group = _group addWaypoint [_wpLocation, _wpRadius];
_group setWaypointBehaviour _wpBehaviour;
_group setWaypointSpeed _wpSpeed;
_group setWaypointFormation _wpFormation;
_group setWaypointCombatMode _wpMode;
_group setWaypointStatements _wpStatement;

// Special property: transportation
if ((_wpType == "GETIN") || (_wpType == "UNLOAD") || (_wpType == "FORCE")) then {
	_group setWaypointType "MOVE";
	[_group, _wpType] call Actionbuilder_fnc_wpTransportation;
} else {
	_group setWaypointType _wpType;
};

if (_wpType == "FORCE") then {
	// See BIS_fnc_vehicleRoles
	// BIS_fnc_spawnVehicle
	_vehicles = [];
	{
		if (_x vehicle != _x) then {
			{
				_cargoKey = _x find "Cargo";
			} forEach ([_x] call BIS_fnc_vehicleRoles);
			_cargoCount = count ((_x select _cargoKey) select 1); // Entä jos kyydis istuu jo joku?
			_vehicles pushBack _x;
			_vehicles pushBack _cargoCount;
		};
	} forEach units _group;
	{
		_x assignAsCargo ();
		_x moveInCargo ();
	} forEach units _group;
};

true