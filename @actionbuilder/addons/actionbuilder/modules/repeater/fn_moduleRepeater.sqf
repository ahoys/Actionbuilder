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

// Activation method selection.
private _ActivationMethod = _repeater getVariable ["ActivationMethod", "VARIABLE"];

// Boolean method.
private _BooleanVariable = _repeater getVariable ["BooleanVariable", ""];
private _ToggleVariable = _repeater getVariable ["ToggleVariable", true];

// Value method.
private _ValueCondition = _repeater getVariable ["ValueCondition", "LESSUNITS"];
private _Value = _repeater getVariable ["Value", 0];

// Options.
private _RepeatInterval = _repeater getVariable ["RepeatInterval", 1];
private _MaximumRepeats = _repeater getVariable ["MaximumRepeats", 0];
private _MonitorFPS = _repeater getVariable ["MonitorFPS", true];

// Make sure a variable is given if the selected activation method is boolean variable.
if (_ActivationMethod == "VARIABLE" && _BooleanVariable == "") exitWith {
	["Boolean variable cannot be empty! Check %1.", _repeater] call BIS_fnc_error;
	false
};

// Make sure the variable exists if the selected activation method is boolean variable.
if (_ActivationMethod == "VARIABLE" && isNil _BooleanVariable) then {
	missionNamespace setVariable [_BooleanVariable, false];
};

// Too short repeating interval.
if (_RepeatInterval < 1) exitWith {
	["Repeat interval cannot be shorter than a one second! Check %1.", _repeater] call BIS_fnc_error;
	false
};

// Start monitoring.
private _c = 0;
while {_MaximumRepeats == -1 || _c < _MaximumRepeats} do {
	private _execute = false;
	if (_ActivationMethod == "VARIABLE") then {
		// Activation method boolean variable.
		private _value = missionNamespace getVariable _BooleanVariable;
		if (typeName _value == "BOOL") then {
			if (_value) then {
				// Value of the boolean variable is TRUE.
				// Set to execute and toggle the variable if requested.
				_execute = true;
				if (_ToggleVariable) then {
					missionNamespace setVariable [_BooleanVariable, false];
				};
			};
		};
	};
	if (_ActivationMethod == "VALUE") then {
		// Activation method value.
		switch (_ValueCondition) do {
			case "PLAYERS": {
				if (count (playableUnits + switchableUnits) > _Value) then {
					_execute = true;
				};
			};
			case "UNITS": {
				if (count allUnits < _Value) then {
					_execute = true;
				};
			};
			case "WEST": {
				if ({(side _x) == west} count allUnits < _Value) then {
					_execute = true;
				};
			};
			case "EAST": {
				if ({(side _x) == east} count allUnits < _Value) then {
					_execute = true;
				};
			};
			case "INDEPENDENT": {
				if ({(side _x) == independent} count allUnits < _Value) then {
					_execute = true;
				};
			};
			case "CIVILIAN": {
				if ({(side _x) == civilian} count allUnits < _Value) then {
					_execute = true;
				};
			};
			default {};
		};
	};
	if (_execute) then {
		if (_MonitorFPS) then {
			// FPS must be over 20 for the repeater to work.
			waitUntil {diag_fps > 20};
		};
		{
			[
				_x,
				[_x, false] call Actionbuilder_fnc_modulePortals
			] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";
		} forEach _actionpoints;
		_c = _c + 1;
	};
	sleep _RepeatInterval;
};

true
