/*

	Author: Raunhofer
	Last Update: d05/m10/y15
	
	Title: PORTAL MODULE
	Description: Initializes the portal module for Actionbuilder
	
	Duty: Hides and saves all connected custom units. Registers the portal.

*/

// --- Check for headless clients -----------------------------------------------------------------------------------------------------
if (!isServer) exitWith {false};

// --- Initialize the portal function
if (isNil "RHNET_ab_portalFnc") then {
	RHNET_ab_portalFnc = compileFinal preprocessFileLineNumbers "RHNET\rhnet_actionbuilder\modules\components\rh_Portal.sqf";
	RHNET_ab_customSync = compileFinal preprocessFileLineNumbers "RHNET\rhnet_actionbuilder\modules\scripts\customSync.sqf";
	publicVariable "RHNET_ab_portalFnc";
};

// --- Wait until the initialization is done
waitUntil {(!isNil "RHNET_ab_locations") && (!isNil "RHNET_ab_locations_used") && (!isNil "RHNET_ab_customSync") && (!isNil "RHNET_ab_portalFnc")};

// --- This portal module
private ["_portal","_customSync"];
_portal = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// --- Hide connected units
_customSync = [_portal] call RHNET_ab_customSync;

// --- Register this portal
RHNET_ab_locations set [(count RHNET_ab_locations),_portal];
publicVariable "RHNET_ab_locations";

true