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

// Repeater can execute only after the Actionpoint's activation.
// RHNET_AB_G_AP_EXECUTED lists all the executed APs.
// RHNET_AB_G_AP_SPAWNED lists all the spawned units.
waitUntil {!isNil "RHNET_AB_G_AP_EXECUTED" && !isNil "RHNET_AB_G_AP_SPAWNED"};

// Start AP monitoring.
private _executedAPs = [];
private _i = 0;
// Not all the actionpoints will be activated at the same time.
while {count _executedAPs != count _actionpoints} do {
	private _ap = _actionpoints select _i;
	if ((_executedAPs find _ap) == -1) then {
		// The selected AP has not been executed yet.
		if ((RHNET_AB_G_AP_SPAWNED find _ap) != -1) then {
			// The selected AP has been activated at least once.
			[
				_repeater,
				_ap,
				(RHNET_AB_G_AP_SPAWNED find _ap) + 1
			] execFSM "RHNET\rhnet_actionbuilder\modules\repeater\rhfsm_repeater.fsm";
			_executedAPs pushBack _ap;
		};
	};
	if ((_i + 1) >= count _actionpoints) then {
		// Reset index.
		_i = 0;
	} else {
		// Increment index.
		_i = _i + 1;
	};
	sleep 0.1;
};

true
