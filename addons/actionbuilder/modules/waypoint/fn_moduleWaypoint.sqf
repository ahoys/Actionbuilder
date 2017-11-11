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
private _wp = param [0, objNull, [objNull]];

// Make sure there are portals or waypoints available ---------------------------------------------
if (
	[_wp, "RHNET_ab_moduleWP_F"] call Actionbuilder_fnc_getSynchronizedOfType isEqualTo [] &&
	[_wp, "RHNET_ab_modulePORTAL_F"] call Actionbuilder_fnc_getSynchronizedOfType isEqualTo []
) exitWith {
	["Waypoint %1 has no valid synchronizations. Synchronize waypoints to portals or other waypoints.", _wp] call BIS_fnc_error;
	false
};

true