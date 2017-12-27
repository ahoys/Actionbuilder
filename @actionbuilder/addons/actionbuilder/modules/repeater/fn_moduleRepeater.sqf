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

// Repeater settings.
private _activationType = _repeater getVariable ["ActivationType", "BOOLEAN"];
private _customVariable = _repeater getVariable ["CustomVariable", ""];
private _customValue = _repeater getVariable ["CustomValue", -1];
private _requiresVariable = ["BOOLEAN"];
private _requiresValue = ["MINUNITCOUNT", "MAXPLAYERCOUNT"];

if (
	(_requiresVariable find _activationType != -1)
	&& (_customVariable == "")
) exitWith {
	["Invalid variable given for Repeater %1.", _repeater] call BIS_fnc_error;
	false
};

if (
	(_requiresValue find _activationType != -1)
	&& (_customValue == -1)
) exitWith {
	["Invalid value given for Repeater %1.", _repeater] call BIS_fnc_error;
	false
};

// Start monitoring.
while {true} do {
	private _execute = false;
	if (_activationType == "BOOLEAN") then {
		// Make sure the variable is initialized.
		if (isNil _customVariable) then {
			missionNamespace setVariable [_customVariable, false];
		};
		// Read the variable value.
		private _value = missionNamespace getVariable _customVariable;
		// Value must be boolean.
		if (typeName _value == "BOOL") then {
			if (_value) then {
				// Value of the variable is true.
				// Set to execute and toggle the variable.
				_execute = true;
				missionNamespace setVariable [_customVariable, false];
			};
		};
	};
	if (_activationType == "MINUNITCOUNT") then {
		if (count allUnits < _customValue) then {
			// There are less units than the value.
			_execute = true;
		};
	};
	if (_activationType == "MAXPLAYERCOUNT") then {
		if (count (playableUnits + switchableUnits) > _customValue) then {
			// There are more alive players than the value.
			_execute = true;
		};
	};
	if (_execute) then {
		// FPS must be over 20 for the repeater to work.
		waitUntil {diag_fps > 20};
		{
			[
				_x,
				[_x, false] call Actionbuilder_fnc_modulePortals
			] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";
		} forEach _actionpoints;
	};
	sleep 1;
};

true
