/*
	File: fn_punish.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: GROUP/OBJECT - target of damage
	1: STRING - type of damage, can be either KILL, NEUTRALIZE, REMOVE, HURT or HEAL
	2: NUMBER (optional) - limit the amount of performance-heavy actions (default: 8)

	Returns:
	BOOL - true, if success
*/

private["_target","_punish","_limit","_i"];
_target 	= param [0, grpNull, [[], grpNull, objNull]];
_punish 	= param [1, "KILL", [""]];
_limit 		= param [2, 8, [0]];
_i			= 0;

if (isNil "_target") exitWith {
	["Required group or object missing!"] call BIS_fnc_error;
	false
};

if (_target isEqualType grpNull || _target isEqualType []) exitWith {
	if (_target isEqualType grpNull) then {_target = units _target};	// Joku bugi, ei tapa kuin leaderin
	{
		if (!isNil "_x") then {
			_unit = _x;
			if !(isNull objectParent _unit) then {
				{
					deleteVehicle _x;
				} forEach crew objectParent _unit;
				_unit = objectParent _x;
			};
			call {
				if (_punish == "KILL") exitWith {_unit setDamage 1};
				if (_punish == "NEUTRALIZE") exitWith {
					if ((alive _unit) && (_i < _limit)) then {
						if (diag_fps > 12) then {
							_unit spawn BIS_fnc_neutralizeUnit;
						} else {
							_unit setDamage 1;
						};
						sleep 0.5;
						_i = _i + 1;
					};
				};
				if (_punish == "REMOVE") exitWith {deleteVehicle _unit};
				if (_punish == "HURT") exitWith {
					if (damage _unit < 0.3) then {
						_unit setDamage ([0.4,0.5,0.6,0.7] select floor random 4);
					} else {
						if (damage _unit < 0.99) then {
							_unit setDamage (damage _unit + ((1 - damage _unit) / 2));
						};
					};
				};
				if (_punish == "HEAL") exitWith {_unit setDamage 0};
			};
		};
	} forEach _target;
	true
};

if (((!alive _target) && (_punish != "REMOVE")) || isNil "_target") exitWith {false};

if (_target isEqualType objNull) exitWith {
	call {
		if (_punish == "KILL") exitWith {_target setDamage 1};
		if (_punish == "NEUTRALIZE") exitWith {
			if (diag_fps > 12) then {
				_target spawn BIS_fnc_neutralizeUnit;
			} else {
				_target setDamage 1;
			};
		};
		if (_punish == "REMOVE") exitWith {deleteVehicle _target};
		if (_punish == "HURT") exitWith {
			if (damage _target < 0.3) then {
				_target setDamage ([0.4,0.5,0.6,0.7] select floor random 4);
			} else {
				if (damage _target < 0.99) then {
					_target setDamage (damage _target + ((1 - damage _target) / 2));
				};
			};
		};
		if (_punish == "HEAL") exitWith {_target setDamage 0};
	};
	true
};

["Invalid typeName: %1.", typeName _target] call BIS_fnc_error;
false