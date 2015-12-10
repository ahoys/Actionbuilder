/*
	File: fn_populateSeats.sqf
	Author: Ari Höysniemi

	Description:
	Populate given seats if possible

	Parameter(s):
	0: ARRAY - target unit(s)
	1: ARRAY - list of seats available
	2: BOOL - true to force populate
	Returns:
	ARRAY - units left outside
*/

private["_target","_prioritized","_vehicles","_vehicle","_noGunner"];
_units		= _this select 0;
_seats		= _this select 1;
_force		= _this select 2;
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
					if (_force) then {
						_unit moveInDriver _veh;
					} else {
						_unit assignAsDriver _veh;
						[_unit] orderGetIn true;
					};
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit}; // Ei ota huomioon get in kävelijöitä
				};
				case "Gunner": {
					if (_force) then {
						_unit moveInGunner _veh;
					} else {
						_unit assignAsGunner _veh;
						[_unit] orderGetIn true;
					};
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit};
				};
				case "Commander": {
					if (_force) then {
						_unit moveInCommander _veh;
					} else {
						_unit assignAsCommander _veh;
						[_unit] orderGetIn true;
					};
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit};
				};
				case "Cargo": {
					if (_force) then {
						_unit moveInCargo _veh;
					} else {
						_unit assignAsCargo _veh;
						[_unit] orderGetIn true;
					};
					if (vehicle _unit != _unit) exitWith {_seated pushBack _unit};
				};
			};
		};
	} forEach _seats;
} forEach _units;

_outside = _units - _seated;
_outside