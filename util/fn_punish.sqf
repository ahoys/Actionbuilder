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

private["_target","_punish","_limit","_pos"];
_target 	= param [0, grpNull, [[], grpNull, objNull]];
_punish 	= param [1, "KILL", [""]];
_limit 		= param [2, 8, [0]];

if (isNil "_target") exitWith {
	["Required group or object missing!"] call BIS_fnc_error;
	false
};

// Convert into an array
call {
	if (_target isEqualType objNull) exitWith {_target = [_target]};
	if (_target isEqualType grpNull) exitWith {_target = units _target};
};

// Functionality
if (_target isEqualType []) exitWith {
	call {
		if (_punish == "KILL") exitWith {{_x setDamage 1} forEach _target};
		if (_punish == "REMOVE") exitWith {{deleteVehicle _x} forEach _target};
		if (_punish == "HEAL") exitWith {{_x setDamage 0} forEach _target};
		if (_punish == "NEUTRALIZE") exitWith {
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
			} forEach _target;
		};
		if (_punish == "HURT") exitWith {
			{
				if (damage _x < 0.3) then {
					_x setDamage ([0.4,0.5,0.6,0.7] select floor random 4);
				} else {
					if (damage _x < 0.99) then {
						_x setDamage (damage _x + ((1 - damage _x) / 2));
					};
				};
			} forEach _target;
		};
	};
	true
};

["Invalid typeName: %1.", typeName _target] call BIS_fnc_error;
false