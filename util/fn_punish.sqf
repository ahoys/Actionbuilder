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
_limit 		= [_this, 2, 8, [0]] call BIS_fnc_param;
_i			= 0;

if (isNil "_target") exitWith {
	["Required group or object missing!"] call BIS_fnc_error;
	false
};

if (typeName _target == "GROUP") exitWith {
	{
		if (!isNil "_x") then {
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
						if (diag_fps > 12) then {
							_unit spawn BIS_fnc_neutralizeUnit;
						} else {
							_unit setDamage 1;
						};
						sleep 0.5;
						_i = _i + 1;
					};
				};
				case "REMOVE": { 
					deleteVehicle _unit;
				};
				case "HURT": {
					if (damage _unit < 0.3) then {
						_unit setDamage ([0.4,0.5,0.6,0.7] select floor random 4);
					} else {
						if (damage _unit < 0.99) then {
							_unit setDamage (damage _unit + ((1 - damage _unit) / 2));
						};
					};
				};
				case "HEAL": {
					_unit setDamage 0;
				};
			};
			if (!isNil "ACTIONBUILDER_carbage") then {
				if (!alive _unit) then {ACTIONBUILDER_carbage pushBack _unit};
			};
		};
	} forEach units _target;
	true
};

if (((!alive _target) && (_punish != "REMOVE")) || isNil "_target") exitWith {false};

if (typeName _target == "OBJECT") exitWith {
	switch (_punish) do {
		case "KILL": { 
			_target setDamage 1;
		};
		case "NEUTRALIZE": {
			if (diag_fps > 12) then {
				_target spawn BIS_fnc_neutralizeUnit;
			} else {
				_target setDamage 1;
			};
		};
		case "REMOVE": {
			deleteVehicle _target;
		};
		case "HURT": { 
			if (damage _target < 0.3) then {
				_target setDamage ([0.4,0.5,0.6,0.7] select floor random 4);
			} else {
				if (damage _target < 0.99) then {
					_target setDamage (damage _target + ((1 - damage _target) / 2));
				};
			};
		};
		case "HEAL": { 
			_target setDamage 0;
		};
	};
	if (!isNil "ACTIONBUILDER_carbage") then {
		if (!alive _target) then {ACTIONBUILDER_carbage pushBack _target};
	};
	true
};

["Invalid typeName: %1.", typeName _target] call BIS_fnc_error;
false