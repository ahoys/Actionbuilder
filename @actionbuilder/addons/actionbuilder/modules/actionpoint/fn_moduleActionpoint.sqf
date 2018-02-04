/*
	File: fn_moduleActionpoint.sqf
	Author: Ari Höysniemi

	Description:
	Initializes a new Actionpoint

	Parameter(s):
	0: OBJECT - actionpoint module

	Returns:
	Nothing
*/
private _ap = param [0, objnull, [objnull]];
private _portals = [_ap] call Actionbuilder_fnc_modulePortals;
private _repeaters = [_ap] call Actionbuilder_fnc_moduleRepeaters;

// The actionpoint should have portals as slaves --------------------------------------------------
if (_portals isEqualTo []) exitWith {
	["Actionpoint %1 is useless. Synchronize portals to actionpoints.", _ap] call BIS_fnc_error;
	false
};

// Portals must be valid for Actionpoint to have a purpose ----------------------------------------
if (isNil "RHNET_AB_G_PORTALS" || isNil "RHNET_AB_G_PORTAL_OBJECTS" || isNil "RHNET_AB_G_PORTAL_GROUPS") exitWith {false};

// Initialize debugging if required ---------------------------------------------------------------
if (isNil "RHNET_AB_L_DEBUG") then {
	// Switching this value true (in-game) will enable the debugging.
	RHNET_AB_L_DEBUG = false;
};

// Initialize master variables if required --------------------------------------------------------
if (isNil "RHNET_AB_G_AP_SIZE") then {
	RHNET_AB_G_AP_SIZE = [];
	RHNET_AB_L_AP_EXECUTED = [];
	RHNET_AB_L_AP_SPAWNED = [];
	"RHNET_AB_G_REQUEST" addPublicVariableEventHandler {
		// 1 is the id of the owner.
		_this select 1 publicVariableClient "RHNET_AB_G_PORTALS";
		_this select 1 publicVariableClient "RHNET_AB_G_PORTAL_OBJECTS";
		_this select 1 publicVariableClient "RHNET_AB_G_PORTAL_GROUPS";
	};
};

// Initialize spawned-array for this AP.
// This is used to monitor the spawned units.
if ((RHNET_AB_L_AP_SPAWNED find _ap) == -1) then {
	RHNET_AB_L_AP_SPAWNED pushBack _ap;
	RHNET_AB_L_AP_SPAWNED pushBack [];
};

// Count actionpoint's payload size (how many units).
// This will be used to decide whether the AP can activate.
private _s = 0;
{
	_s = ((RHNET_AB_G_PORTAL_OBJECTS select ((RHNET_AB_G_PORTAL_OBJECTS find _x) + 1)) select 0) 
	+ ((RHNET_AB_G_PORTAL_GROUPS select ((RHNET_AB_G_PORTAL_GROUPS find _x) + 1)) select 0);
} forEach _portals;
RHNET_AB_G_AP_SIZE pushBack _ap;
RHNET_AB_G_AP_SIZE pushBack _s;

// Execute ----------------------------------------------------------------------------------------
[_ap, _portals] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";

true
