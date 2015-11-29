/*
	File: fn_punish.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: GROUP/OBJECT - target of damage
	1: STRING - type of damage, can be either KILL, NEUTRALIZE or REMOVE

	Returns:
	BOOL - true, if success
*/

private[];
_target 	= [_this, 0, grpNull, [grpNull, objNull]] call BIS_fnc_param;
_punish 	= [_this, 1, "KILL", [""]] call BIS_fnc_param;

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
				_unit spawn BIS_fnc_neutralizeUnit;
			};
			case "REMOVE": { 
				deleteVehicle _unit;
			};
		};
	} forEach units _target;
	true
};

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
	};
	true
};

["Invalid typeName detected."] call BIS_fnc_error;
false