/*
	File: fn_target.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: GROUP/OBJECT/ARRAY - executers
	1: GROUP/OBJECT/ARRAY - targets
	2: STRING (optional) - command TARGET or FIRE

	Returns:
	BOOL - true, if success
*/

private["_executer","_target","_method","_targets","_executers","_unit","_closest","_personalTarget","_distance"];
_executer	= [_this, 0, grpNull, [grpNull, objNull, []]] call BIS_fnc_param;
_target		= [_this, 0, objNull, [grpNull, objNull, []]] call BIS_fnc_param;
_method		= [_this, 1, "TARGET", [""]] call BIS_fnc_param;

if (isNil "_executer" || isNil "_target") exitWith {
	["Required executer or target missing!"] call BIS_fnc_error;
	false
};

switch (typeName _target) do {
	case "OBJECT": {_targets = [_target]};
	case "GROUP": {_targets = units group _target};
	case "ARRAY": {_targets = _target};
};

switch (typeName _executers) do {
	case "OBJECT": {_executers = [_executer]};
	case "GROUP": {_executers = units group _executer};
	case "ARRAY": {_executers = _executer};
};

{
	_unit = _x;
	_closest = 99999;
	_personalTarget = _targets select 0;
	{
		_distance = _x distance _unit;
		if (_distance < _closest) then {
			_personalTarget = _x;
		};
	} forEach _targets;
	
	switch (_method) do {
		case "TARGET": {
			_unit commandTarget _personalTarget;
		};
		case "FIRE": {
			_unit commandFire _personalTarget;
		};
	};
	
} forEach _executers;

true