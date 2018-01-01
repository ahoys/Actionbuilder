/*
	File: fn_moduleRepeater.sqf
	Author: Ari Höysniemi

	Description:
	Initializes and runs a repeater

	Parameter(s):
	0: OBJECT - repeater module

	Returns:
	Nothing
*/
private _repeater = param [0, objnull, [objnull]];
private _actionpoints = [_repeater, true] call Actionbuilder_fnc_moduleActionpoints;

// The actionpoint should have portals as slaves --------------------------------------------------
if (_actionpoints isEqualTo []) exitWith {
	["Repeater %1 is useless. Synchronize repeaters to actionpoints.", _repeater] call BIS_fnc_error;
	false
};

// Repeater can execute only after the Actionpoint has triggered.
// RHNET_AB_G_AP_EXECUTED lists all the executed APs.
waitUntil {!isNil "RHNET_AB_G_AP_EXECUTED"};

// Start AP monitoring.
{
	[_repeater, _x] execFSM "RHNET\rhnet_actionbuilder\modules\repeater\rhfsm_repeater.fsm";
} forEach _actionpoints;

true
