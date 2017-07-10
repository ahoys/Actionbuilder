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
private _ap = _this param [0,objnull,[objnull]];
private _clients = _this param [1,[],[[]]];
private _portals = [_ap, true] call Actionbuilder_fnc_modulePortals;

// The actionpoint should have portals as slaves --------------------------------------------------
if (_portals isEqualTo []) exitWith {
	["Actionpoint %1 is useless. Synchronize portals to actionpoints.", _ap] call BIS_fnc_error;
	false
};

// Portals must be valid for Actionpoint to have a purpose ----------------------------------------
if (isNil "RHNET_AB_G_PORTALS" || isNil "RHNET_AB_G_PORTAL_OBJECTS" || isNil "RHNET_AB_G_PORTAL_GROUPS") exitWith {false};

// Initialize master variables if required --------------------------------------------------------
if (isNil "RHNET_AB_G_AP_SIZE") then {
	RHNET_AB_G_AP_SIZE			= [];
	RHNET_AB_L_DEBUG			= false;
	RHNET_AB_L_BUFFER 			= 0.02;
	"RHNET_AB_G_REQUEST" addPublicVariableEventHandler {
		_clients publicVariableClient "RHNET_AB_G_PORTALS";
		_clients publicVariableClient "RHNET_AB_G_PORTAL_OBJECTS";
		_clients publicVariableClient "RHNET_AB_G_PORTAL_GROUPS";
	};
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