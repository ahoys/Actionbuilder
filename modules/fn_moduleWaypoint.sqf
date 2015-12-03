/*
	File: fn_moduleWaypoint.sqf
	Author: Ari Höysniemi

	Description:
	Initializes and registers a new waypoint.
	The most important task is to make sure the waypoint is placed correctly.

	Parameter(s):
	0: OBJECT - waypoint module

	Returns:
	BOOL - true if successful registeration
*/

// No clients allowed -----------------------------------------------------------------------------
if (!isServer) exitWith {false};

private["_waypoint","_modules","_linked","_return","_type"];
_waypoint	= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_modules	= _waypoint call BIS_fnc_moduleModules;
_linked		= [];
_return		= true;

waitUntil {!isNil "ACTIONBUILDER_locations" && !isNil "ACTIONBUILDER_portal_objects" && !isNil "ACTIONBUILDER_portal_groups"};

// Waypoint should not be grouped to other units --------------------------------------------------
if ((formationLeader _waypoint) != _waypoint) exitWith {
	["Waypoint %1 is grouped to %2. Waypoints should NEVER be grouped to anything as their positions may change!", _waypoint, formationLeader _waypoint] call BIS_fnc_error;
	false
};

// Make sure there are portals or other waypoints available ---------------------------------------
{
	_type = typeOf _x;
	if ((_type == "RHNET_ab_moduleWP_F") || (_type == "RHNET_ab_modulePORTAL_F")) then {
		_linked pushBack _x;
	};
	if (!(_type == "RHNET_ab_moduleWP_F") && !(_type == "RHNET_ab_modulePORTAL_F")) exitWith {
		["Not supported module %1 synchronized into waypoint %2.", typeOf _x, _waypoint] call BIS_fnc_error;
		_return = false;
	};
} forEach _modules;

// Register the waypoint --------------------------------------------------------------------------
if (((count _linked) < 1) && (_return)) exitWith {
	["Waypoint %1 has no synchronizations. Synchronize the waypoint to portals or other waypoints.", _waypoint] call BIS_fnc_error;
	false
};

ACTIONBUILDER_locations pushBack _waypoint;

_return