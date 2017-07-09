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
private _waypoint = _this select 0;
private _valid = false;

// Make sure there are portals or waypoints available ---------------------------------------------
{
	private _type = typeOf _x;
	if ((_type == "RHNET_ab_moduleWP_F") || (_type == "RHNET_ab_modulePORTAL_F")) then {
		_valid = true;
	};
	if ((_type != "RHNET_ab_moduleWP_F") && (_type != "RHNET_ab_modulePORTAL_F")) then {
		["Not supported module %1 synchronized to waypoint %2.", _type, _waypoint] call BIS_fnc_error;
	};
} forEach (_waypoint call BIS_fnc_moduleModules);

if !(_valid) then {
	["Waypoint %1 has no valid synchronizations. Synchronize the waypoint to portals or other waypoints.", _waypoint] call BIS_fnc_error;
};

true