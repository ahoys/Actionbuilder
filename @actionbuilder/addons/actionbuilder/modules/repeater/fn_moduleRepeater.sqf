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
	["Repeater %1 is useless. Synchronize actionpoints to repeaters.", _repeater] call BIS_fnc_error;
	false
};

[_repeater, _actionpoints] execFSM "RHNET\rhnet_actionbuilder\modules\repeater\rhfsm_repeater.fsm";

true
