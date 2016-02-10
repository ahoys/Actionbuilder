/*
	File: fn_seatEmptyPositions.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported
	
	Extension for:
	fn_loadVehicles.sqf
	
	Description:
	Assigns seats for the given units

	Parameter(s):
	0: ARRAY - target vehicles
	1: ARRAY - already seated units
	2: ARRAY - to-be-seated units
	3: BOOLEAN - true to seat without animations

	Returns:
	ARRAY - total seated units
*/

private["_vehicles","_toBeSeated","_force","_seated","_unit","_veh","_hasDriver","_hasCommander","_hasGunner","_cargo"];
_vehicles	= _this select 0;
_seated		= _this select 1;
_toBeSeated	= _this select 2;
_force		= _this select 3;

{
	_veh = _x;
	// Search for free positions
	if (_veh emptyPositions "Driver" > 0) then {_hasDriver = false} else {_hasDriver = true};
	if (_veh emptyPositions "Commander" > 0) then {_hasCommander = false} else {_hasCommander = true};
	if (_veh emptyPositions "Gunner" > 0) then {_hasGunner = false} else {_hasGunner = true};
	_cargo = _veh emptyPositions "Cargo";
	if !(_hasDriver && _hasCommander && _hasGunner && _cargo < 1) then {
		{
			call {
				_unit = _x;
				// Driver
				if !(_hasDriver) exitWith {
					_unit assignAsDriver _veh;
					if (_force) then {
						_unit moveInDriver _veh;
					};
					_seated pushBack _unit;
					_hasDriver = true;
				};
				
				// Gunner
				if !(_hasGunner) exitWith {
					_unit assignAsGunner _veh;
					if (_force) then {
						_unit moveInGunner _veh;
					};
					_seated pushBack _unit;
					_hasGunner = true;
				};
				
				// Commander
				if !(_hasCommander) exitWith {
					_unit assignAsCommander _veh;
					if (_force) then {
						_unit moveInCommander _veh;
					};
					_seated pushBack _unit;
					_hasCommander = true;
				};
				
				// Cargo
				if (_cargo > 0) exitWith {
					_unit assignAsCargo _veh;
					if (_force) then {
						_unit moveInCargo _veh;
					};
					_seated pushBack _unit;
					_cargo = _cargo - 1;
				};
			};
		} forEach _toBeSeated;
	};
} forEach _vehicles;

_seated orderGetIn true;

_seated