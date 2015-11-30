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
_target 	= [_this, 0, grpNull, [grpNull, objNull]] call BIS_fnc_param;
_punish 	= [_this, 1, "KILL", [""]] call BIS_fnc_param;
_limit 		= [_this, 1, 8, [0]] call BIS_fnc_param;
_i			= 0;

if (isNil "_target") exitWith {
	["Required group or object missing!"] call BIS_fnc_error;
	false
};

if (typeName _target == "GROUP") exitWith {
	{
		_unit = _x;
		_vehicle = vehicle _unit;
		if (_vehicle != _unit) then {
			{
				deleteVehicle _x;
			} forEach crew _vehicle;
			_unit = _vehicle;
		};
		switch (_punish) do {
			case "KILL": { 
				_unit setDamage 1;
			};
			case "NEUTRALIZE": {
				if ((alive _unit) && (_i < _limit)) then {
					_unit spawn BIS_fnc_neutralizeUnit;
					_i = _i + 1;
				};
			};
			case "REMOVE": { 
				deleteVehicle _unit;
			};
			case "HURT": {
				if (damage _unit < 0.3) then {
					_unit setDamage [0.4,0.5,0.6,0.7] select floor random;
				} else {
					_unit setDamage (damage _unit + ((1 - damage _unit) / 2));
				};
			};
			case "HEAL": {
				_unit setDamage 0;
			};
		};
	} forEach units _target;
	true
};

if (!alive _target) exitWith {false};

if (typeName _target == "OBJECT") exitWith {
	switch (_punish) do {
		case "KILL": { 
			_target setDamage 1;
		};
		case "NEUTRALIZE": {
			_target spawn BIS_fnc_neutralizeUnit;
		};
		case "REMOVE": {
			deleteVehicle _target;
		};
		case "HURT": { 
			if (damage _target < 0.3) then {
				setDamage [0.4,0.5,0.6,0.7] select floor random;
			} else {
				_target setDamage (damage _target + ((1 - damage _target) / 2));
			};
		};
		case "HEAL": { 
			_target setDamage 0;
		};
	};
	true
};

["Invalid typeName: %1.", typeName _target] call BIS_fnc_error;
false