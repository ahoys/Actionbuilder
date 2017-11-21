/*
	File: fn_punish.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: ARRAY/GROUP/OBJECT - target of damage
	1: STRING - type of damage, can be either KILL, NEUTRALIZE, REMOVE, HURT or HEAL
	2: NUMBER (optional) - limit the amount of performance-heavy actions (default: 8)

	Returns:
	BOOL - true, if success
*/
private _target = param [0, grpNull, [[], grpNull, objNull]];
private _punish = param [1, "KILL", [""]];
private _limit = param [2, 8, [0]];

if (isNil "_target") exitWith {
	["Required group or object missing!"] call BIS_fnc_error;
	false
};

// Convert into an array
call {
	if (_target isEqualType objNull) exitWith {_target = [_target]};
	if (_target isEqualType grpNull) exitWith {_target = units _target};
};

// Search all vehicles.
private _vehicles = [];
{
	private _veh = objectParent _x;
	if (!(isNull _veh) && !(_veh in _vehicles)) then {
		_vehicles pushBack _veh;
	};
} forEach _target;

// Kill everyone. Destroy vehicles.
if (_punish == "KILL") exitWith {
	{
		_x setDamage 1;
	} forEach _target;
	{
		_x setDamage 1;
	} forEach _vehicles;
};

// Remove everyone, including vehicles.
if (_punish == "REMOVE") exitWith {
	{
		deleteVehicle _x;
	} forEach _target;
	{
		deleteVehicle _x;
	} forEach _vehicles;
};

// Heal all, including vehicles.
if (_punish == "HEAL") exitWith {
	{
		_x setDamage 0;
	} forEach _target;
	{
		_x setDamage 0;
	} forEach _vehicles;
};

// Neutralize all (with explosions), including vehicles.
if (_punish == "NEUTRALIZE") exitWith {
	private _pos = [];
	{
		if (_pos isEqualTo []) then {
			_pos = getPosWorld _x;
			_x spawn BIS_fnc_neutralizeUnit;
		} else {
			if (alive _x && (_x distance _pos <= 30)) then {
				_x setDamage 1;
			};
			if (alive _x && (_x distance _pos > 30)) then {
				_x spawn BIS_fnc_neutralizeUnit;
			};
		};
	} forEach _target;
	{
		if (isNil "_pos") then {
			_pos = getPosWorld _x;
			_x spawn BIS_fnc_neutralizeUnit;
		} else {
			if (alive _x && (_x distance _pos <= 30)) then {
				_x setDamage 1;
			};
			if (alive _x && (_x distance _pos > 30)) then {
				_x spawn BIS_fnc_neutralizeUnit;
			};
		};
	} forEach _vehicles;
};

// Hurt everyone a bit, including the vehicles.
if (_punish == "HURT") exitWith {
	{
		if (damage _x < 0.3) then {
			_x setDamage ([0.4,0.5,0.6] select floor random 4);
		};
	} forEach _target;
	{
		if (damage _x < 0.3) then {
			_x setDamage ([0.4,0.5,0.6] select floor random 4);
		};
	} forEach _vehicles;
};

true