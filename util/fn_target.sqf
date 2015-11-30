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
diag_log "ACTIONBUILDER --------------------------";
private["_executer","_target","_method","_result","_targets","_executers","_unit","_closest","_personalTarget","_distance"];
_executer	= [_this, 0, grpNull, [grpNull, objNull, []]] call BIS_fnc_param;
_target		= [_this, 1, objNull, [grpNull, objNull, []]] call BIS_fnc_param;
_method		= [_this, 2, "TARGET", [""]] call BIS_fnc_param;
_result		= false;

if (isNil "_executer" || isNil "_target") exitWith {
	["Required executer or target missing!"] call BIS_fnc_error;
	false
};
diag_log format ["AB: e: %1, t: %2, m: %3", _executer, _target, _method];
switch (typeName _target) do {
	case "OBJECT": {_targets = [_target]};
	case "GROUP": {_targets = units _target};
	case "ARRAY": {_targets = _target};
};
diag_log format ["AB: targets: %1", _targets];
switch (typeName _executer) do {
	case "OBJECT": {_executers = [_executer]};
	case "GROUP": {_executers = units _executer};
	case "ARRAY": {_executers = _executer};
};
diag_log format ["AB: executers: %1", _executers];
{
	_unit = _x;
	_closest = 99999;
	_personalTarget = _targets select 0;
	{
		if (!isNil "_x") then {
			_distance = _unit distance _x;
			if (_distance < _closest) then {
				_personalTarget = _x;
			};
		};
	} forEach _targets;
	if (isNil "_personalTarget") exitWith {
		["Invalid target input, the target does not exist!"] call BIS_fnc_error;
		false
	};
	diag_log format ["AB: personalTarget: %1", _personalTarget];
	switch (_method) do {
		case "TARGET": {
			_unit commandTarget _personalTarget;
			_result = true;
		};
		case "FIRE": {
			_unit commandFire _personalTarget;
			_result = true;
		};
	};
} forEach _executers;

_result