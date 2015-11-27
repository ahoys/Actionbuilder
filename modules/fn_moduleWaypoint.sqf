/*

	Author: Raunhofer
	Last Update: d05/m10/y15
	
	Title: WAYPOINT MODULE
	Description: Initializes the waypoint module for Actionbuilder

*/

// --- Check for headless clients -----------------------------------------------------------------------------------------------------
if (!isServer) exitWith {false};

// --- Initialize the waypoint function
if (isNil "RHNET_ab_waypointFnc") then {
	RHNET_ab_waypointFnc = compileFinal preprocessFileLineNumbers "RHNET\rhnet_actionbuilder\modules\components\rh_Waypoint.sqf";
	publicVariable "RHNET_ab_waypointFnc";
};

// --- This waypoint module
private ["_module"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// --- Wait until the main initialization is done
waitUntil {(!isNil "RHNET_ab_locations") && (!isNil "RHNET_ab_locations_used")};

// --- Register this waypoint
RHNET_ab_locations set [(count RHNET_ab_locations),_module];
publicVariable "RHNET_ab_locations";

true