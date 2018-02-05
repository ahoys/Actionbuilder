/*
	File: fn_repeater.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported.

	Description:
	The main repeater loop.

	Returns:
	NOTHING
*/
if (!isServer) exitWith {false};

// A list of repeaters must exist.
waitUntil {
	!isNil "RHNET_AB_L_REPEATERS"
	&& !isNil "RHNET_AB_L_AP_SPAWNED"
	&& !isNil "RHNET_AB_L_AP_EXECUTED"
};

// Ability to pause the repeater core.
RHNET_AB_L_REPEATER_RUN = true;

// Internal records.
private _INTERVALS_RECORD = [];
private _REPEATS_RECORD = [];
{
	_INTERVALS_RECORD pushBack _x;
	_INTERVALS_RECORD pushBack time;
	_REPEATS_RECORD pushBack _x;
	_REPEATS_RECORD pushBack 0;
} forEach RHNET_AB_L_REPEATERS;

/**
* _clearBuffers
* Attempts to clear SPAWNED & GROUPS buffers of dead units and groups.
*/
private _clearBuffers = {
	// Clear units.
	if (isNil "RHNET_AB_L_AP_SPAWNED") exitWith {false};
	private _s = 0;
	{
		if (typeName _x == "ARRAY") then {
			private _alive = [];
			{
				if (!isNull _x) then {
					if (alive _x) then {
						_alive pushBack _x;
					};
				};
			} forEach _x;
			RHNET_AB_L_AP_SPAWNED set [_s, _alive];
		};
		_s = _s + 1;
	} forEach RHNET_AB_L_AP_SPAWNED;
	// Clear groups.
	if (isNil "RHNET_AB_L_GROUPS") exitWith {false};
	private _g = 0;
	{
		if (!isNull _x) then {
			if (({alive _x} count units _x) == 0) then {
				RHNET_AB_L_GROUPS deleteAt _g;
				deleteGroup _x;
			};
		};
		_g = _g + 1;
	} forEach RHNET_AB_L_GROUPS;
	true
};

/**
* _isConditionFulfilledFnc
* Validates the given condition.
*
* Returns true if the condition is fulfilled.
*/
private _isConditionFulfilledFnc = {
	private _repeater = param [0, objNull, [objNull]];
	private _condition = param [1, "", [""]];
	private _value = param [2, 1, [1]];
	private _result = false;
	switch (_condition) do {
		case "SPAWNEDUNITS": {
			private _alive = 0;
			{
				private _apIndex = RHNET_AB_L_AP_SPAWNED find _x;
				if (_apIndex != -1) then {
					{
						if (!isNull _x) then {
							if (alive _x) then {
								_alive = _alive + 1;
							};
						};
					} forEach (RHNET_AB_L_AP_SPAWNED select (_apIndex + 1));
				};
			} forEach ([_repeater] call Actionbuilder_fnc_moduleActionpoints);
			if (_alive < _value) then {
				_result = true;
			};
		};
		case "UNITS": {
			if (({_x isKindOf "AllVehicles" && alive _x} count allUnits) < _value) then {
				_result = true;
			};
		};
		case "WEST": {
			if (({side _x == west} count allUnits) < _value) then {
				_result = true;
			};
		};
		case "EAST": {
			if (({side _x == east} count allUnits) < _value) then {
				_result = true;
			};
		};
		case "INDEPENDENT": {
			if (({side _x == independent} count allUnits) < _value) then {
				_result = true;
			};
		};
		case "CIVILIAN": {
			if (({side _x == civilian && alive _x} count allUnits) < _value) then {
				_result = true;
			};
		};
		case "PLAYERS": {
			if ({alive _x && isPlayer _x} count (switchableUnits + playableUnits) > _value) then {
				_result = true;
			};
		};
	};
	_result;
};

/**
* _isValidIntervalFnc
* Calculates delay between the previous run and this
* moment.
*
* Returns true if enough time has passed (boolean).
*/
private _isValidIntervalFnc = {
	private _repeater = param [0, objNull, [objNull]];
	private _record = param [1, [], [[]]];
	private _previousRun = _record select ((_record find _repeater) + 1);
	if ((time - _previousRun) >= (_repeater getVariable ["RepeatInterval", 1])) exitWith {true};
	false
};

/**
* _getRepeatsFnc
* Makes sure the repeating limit of a repeater has
* not exceeded.
*
* If it has, the repeater will be removed from the loop.
*
* Returns the current repeat count (number).
*/
private _getRepeatsFnc = {
	private _repeater = param [0, objNull, [objNull]];
	private _record = param [1, [], [[]]];
	private _repeats = (_record select ((_record find _repeater) + 1)) + 1;
	private _maximumRepeats = _repeater getVariable ["MaximumRepeats", 0];
	if (_maximumRepeats > 0) then {
		if (_repeats >= _maximumRepeats) then {
			RHNET_AB_L_REPEATERS deleteAt (RHNET_AB_L_REPEATERS find _repeater);
		};
	};
	_repeats
};

/**
* _activateActionpoints
* Activates all actionpoints synchronized to a repeater.
*/
private _activateActionpoints = {
	private _repeater = param [0, objNull, [objNull]];
	{
		// AP must be activated at least once.
		if (RHNET_AB_L_AP_EXECUTED find _x != -1) then {
			[
				_x,
				[_x] call Actionbuilder_fnc_modulePortals,
				_repeater
			] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";
		};
	} forEach ([_repeater] call Actionbuilder_fnc_moduleActionpoints);
	true
};

/**
* _doTriggerVariable
* Execution based on a variable.
*
* Returns true if actionpoints were activated.
*/
private _doTriggerVariable = {
	private _repeater = param [0, objNull, [objNull]];
	private _booleanVariable = _repeater getVariable ["BooleanVariable", ""];
	private _value = missionNamespace getVariable _booleanVariable;
	if (isNil "_value") exitWith {false};
	if (typeName _value != "BOOL") exitWith {false};
	if (!_value) exitWith {false};
	if (_repeater getVariable ["ToggleVariable", true]) then {
		// Toggle value to false.
		missionNamespace setVariable [_booleanVariable, false];
	};
	[_repeater] call _activateActionpoints;
};

/**
* _doTriggerValue
* Execution based on a value.
*
* Returns true if actionpoints were activated.
*/
private _doTriggerValue = {
	private _repeater = param [0, objNull, [objNull]];
	if (
		[
			_repeater,
			_repeater getVariable ["ValueCondition", "SPAWNEDUNITS"],
			_repeater getVariable ["Value", 1]
		] call _isConditionFulfilledFnc
	) exitWith {
		[_repeater] call _activateActionpoints;
	};
	false
};

/**
* _isReady
* Makes sure the repeater has finished its previous action.
*
* Returns true if the repeater is ready.
*/
private _isReady = {
	private _repeater = param [0, objNull, [objNull]];
	private _qIndex = (RHNET_AB_L_REPEATER_QUEUE find _repeater) + 1;
	if ((RHNET_AB_L_REPEATER_QUEUE select _qIndex) isEqualTo []) exitWith {
		true
	};
	false
};

// The main loop.
while {true} do {
	waitUntil {RHNET_AB_L_REPEATER_RUN};
	{
		waitUntil {diag_fps >= 20};
		private _repeater = _x;
		if (!isNull _repeater) then {
			// REPEATING INTERVAL -----------------------------------------------------------------------
			if ([_repeater, _INTERVALS_RECORD] call _isValidIntervalFnc) then {
				// CLEAR BUFFERS --------------------------------------------------------------------------
				[] call _clearBuffers;
				// ACTIVATION -----------------------------------------------------------------------------
				if ([_repeater] call _isReady) then {
					private _activated = false;
					// Reserve this repeater.
					RHNET_AB_L_REPEATER_QUEUE set [
						(RHNET_AB_L_REPEATER_QUEUE find _repeater) + 1,
						true
					];
					if (_repeater getVariable ["ActivationMethod", "VARIABLE"] == "VARIABLE") then {
						// Activation method: variable.
						_activated = [_repeater] call _doTriggerVariable;
					} else {
						// Activation method: value.
						_activated = [_repeater] call _doTriggerValue;
					};
					// UPDATE RECORDS -----------------------------------------------------------------------
					if (_activated) then {
						_REPEATS_RECORD set [
							(_REPEATS_RECORD find _repeater) + 1,
							[_repeater, _REPEATS_RECORD] call _getRepeatsFnc
						];
						_INTERVALS_RECORD set [
							(_INTERVALS_RECORD find _repeater) + 1,
							time
						];
					} else {
						// Remove the reservation.
						RHNET_AB_L_REPEATER_QUEUE set [
							(RHNET_AB_L_REPEATER_QUEUE find _repeater) + 1,
							[]
						];
					};
				};
			};
		};
	} forEach RHNET_AB_L_REPEATERS;
	sleep 0.1;
};

true
