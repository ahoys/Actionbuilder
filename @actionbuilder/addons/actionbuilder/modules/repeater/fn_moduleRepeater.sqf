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
if (!isServer) exitWith {false};

private _repeater = param [0, objnull, [objnull]];
private _actionpoints = [_repeater] call Actionbuilder_fnc_moduleActionpoints;

// There must be some actionpoints synchronized for the repeater to function.
if (_actionpoints isEqualTo []) exitWith {false};

if (isNil "RHNET_AB_L_REPEATERS") then {
	// Register the initial repeater.
	RHNET_AB_L_REPEATERS = [_repeater];
	RHNET_AB_L_REPEATER_QUEUE = [_repeater, []];
	[] spawn Actionbuilder_fnc_repeater;
} else {
	// Register a new repeater.
	RHNET_AB_L_REPEATER_QUEUE pushBack _repeater;
	RHNET_AB_L_REPEATER_QUEUE pushBack [];
	RHNET_AB_L_REPEATERS pushBack _repeater;
};

true
