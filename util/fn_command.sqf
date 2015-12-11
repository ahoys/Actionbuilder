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

private["_executer","_target","_method","_result","_targets","_executers","_unit","_closest","_personalTarget","_distance"];
_executer	= param [0, grpNull, [grpNull, objNull, []]];
_target		= param [1, grpNull, [grpNull, objNull, []]];
_method		= param [2, "TARGET", [""]];
_result		= false;

// Executer or subject can't be empty
if (isNil "_executer" || isNil "_target") exitWith {
	["Required executer or target missing!"] call BIS_fnc_error;
	false
};

// Convert executers into an array
switch (typeName _executer) do {
	case "OBJECT": {_executers = [_executer]};
	case "GROUP": {_executers = units _executer};
	case "ARRAY": {_executers = _executer};
};

// Convert targets into an array
switch (typeName _target) do {
	case "OBJECT": {_targets = [_target]};
	case "GROUP": {_targets = units _target};
	case "ARRAY": {_targets = _target};
};

// All executers can have their own targets
{

	_unit = _x;
	_distance = -1;
	
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
	if (isNil "_personalTarget") then {
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
	if (isNil "_personalTarget") exitWith {false};
	
	// Select command to be performed
	switch (_method) do {
		case "TARGET": {
			_unit commandTarget _personalTarget;
			_result = true;
		};
		case "FIRE": {
			_unit commandFire _personalTarget;
			_result = true;
		};
		case "WATCH": {
			_unit commandWatch _personalTarget;
			_result = true;
		};
	};
	
} forEach _executers;

_result