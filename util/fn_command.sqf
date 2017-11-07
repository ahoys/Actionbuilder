/*
	File: fn_command.sqf
	Author: Ari Höysniemi

	Description:
	Command units to execute a command action against targets

	Parameter(s):
	0: GROUP/OBJECT/ARRAY - executers
	1: GROUP/OBJECT/ARRAY - targets
	2: STRING (optional) - command TARGET, FIRE or WATCH

	Returns:
	BOOL - true, if success
*/

private _executer = param [0, grpNull, [grpNull, objNull, []]];
private _target = param [1, grpNull, [grpNull, objNull, []]];
private _method = param [2, "TARGET", [""]];
private _result = false;

// Executer or subject can't be empty
if (isNil "_executer" || isNil "_target") exitWith {
	["Required executer or target missing!"] call BIS_fnc_error;
	false
};

// Convert executers into an array
private _executers = [];
call {
	if (typeName _executer == "OBJECT") exitWith {_executers = [_executer]};
	if (typeName _executer == "GROUP") exitWith {_executers = units _executer};
	if (typeName _executer == "ARRAY") exitWith {_executers = _executer};
};

// Convert targets into an array
private _targets = [];
call {
	if (typeName _target == "OBJECT") exitWith {_targets = [_target]};
	if (typeName _target == "GROUP") exitWith {_targets = units _target};
	if (typeName _target == "ARRAY") exitWith {_targets = _target};
};

// All executers can have their own targets
{

	private _unit = _x;
	private _distance = -1;
	private _personalTarget = objNull;
	
	// Select the closest target
	{
		if (!isNil "_x") then {
			if ((((_unit distance _x) < _distance) || (_distance < 0)) && (alive _x) && (_unit != _x) && (isNull objectParent _x)) then {
				_personalTarget = _x;
				_distance = (_unit distance _x);
			};
		};
	} forEach _targets;
	
	// If no men, target vehicles
	if (isNull _personalTarget) then {
		{
			if (!isNil "_x") then {
				if ((((_unit distance objectParent _x) < _distance) || (_distance < 0)) && (alive objectParent _x) && (_unit != _x) && !(isNull objectParent _x)) then {
					_personalTarget = objectParent _x;
					_distance = (_unit distance objectParent _x);
				};
			};
		} forEach _targets;
	};
	
	// Make sure the target exists
	if (isNull _personalTarget) exitWith {false};
	
	// Select command to be performed
	call {
		if (_method == "TARGET") exitWith {
			_unit commandTarget _personalTarget;
			_result = true;
		};
		if (_method == "FIRE") exitWith {
			_unit commandFire _personalTarget;
			_result = true;
		};
		if (_method == "WATCH") exitWith {
			_unit commandWatch _personalTarget;
			_result = true;
		};
	};
	
} forEach _executers;

_result