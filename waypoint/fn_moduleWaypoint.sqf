/*
	File: fn_moduleWaypoint.sqf
	Author: Ari Höysniemi

	Description:
	Makes sure everything is set up correctly in the mission editor

	Parameter(s):
	0: OBJECT - waypoint module

	Returns:
	BOOL - true if valid check
*/

// No clients allowed -----------------------------------------------------------------------------
if (!isServer) exitWith {false};

private["_waypoint","_valid","_type"];
_waypoint	= _this select 0;
_valid		= false;

// Waypoint should not be grouped to other units --------------------------------------------------
if ((formationLeader _waypoint) != _waypoint) then {
	["Waypoint %1 is grouped to %2. Waypoints should NEVER be grouped to anything as their positions may change!", _waypoint, formationLeader _waypoint] call BIS_fnc_error;
};

// Make sure there are portals or waypoints available ---------------------------------------------
{
	_type = typeOf _x;
	if ((_type == "RHNET_ab_moduleWP_F") || (_type == "RHNET_ab_modulePORTAL_F")) then {
		_valid = true;
	} else {
		["Not supported module %1 synchronized to waypoint %2.", _type, _waypoint] call BIS_fnc_error;
	};
} forEach (_waypoint call BIS_fnc_moduleModules);

if !(_valid) then {
	["Waypoint %1 has no synchronizations. Synchronize the waypoint to portals or other waypoints.", _waypoint] call BIS_fnc_error;
};

true