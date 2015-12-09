/*
	File: fn_wpPopulateSeats.sqf
	Author: Ari Höysniemi

	Description:
	Populate given seats if possible

	Parameter(s):
	0: OBJECT/ARRAY - unit(s)
	1: ARRAY - list of prioritized seats

	Returns:
	ARRAY - units left outside
*/

private["_target","_prioritized","_vehicles","_vehicle","_noGunner"];
_units		= [_this, 0, objNull, [objNull, []]] call BIS_fnc_param;
_seats		= [_this, 1, [], [[]]] call BIS_fnc_param;
_outside	= [];
_seated		= [];

switch (typeName _units) do {
	case "OBJECT": {_units = [_units]};
};

{
	_unit = _x;
	{
		if (vehicle _unit != _unit) then {
			_seated pushBack _unit
		} else {
			_veh = _x select 0;
			switch (_x select 1) do {
				case "Driver": {
					_unit moveInDriver _veh;
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit};
				};
				case "Gunner": {
					_unit moveInGunner _veh;
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit};
				};
				case "Commander": {
					_unit moveInCommander _veh;
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit};
				};
				case "Cargo": {
					_unit moveInCargo _veh;
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit};
				};
			};
		};
	} forEach _seats;
} forEach _units;

_outside = _units - _seated;
_outside