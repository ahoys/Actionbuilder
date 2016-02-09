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
	0: ARRAY - to-be-seated units
	1: ARRAY - target vehicles
	2: BOOLEAN - true to seat without animations
	3: NUMBER - index number from where to start with the _units array

	Returns:
	NUMBER - current index
*/

private["_units","_vehicles","_force","_grpSize","_i","_veh","_gunners","_cargo"];
_units		= _this select 0;
_vehicles	= _this select 1;
_force		= _this select 2;
_i			= _this select 3;
_grpSize	= count _units;

{
	if (_i >= _grpSize) exitWith {};
	
	_veh = _x;
	
	// If the vehicle does not have a driver
	if (_veh emptyPositions "Driver" > 0) then {
		if (_grpSize > 1 && _i == 0) then {
			(_units select 1) assignAsDriver _veh;
			if (_force) then {(_units select 1) moveInDriver _veh};
			_i = _i + 1;
		} else {
			(_units select _i) assignAsDriver _veh;
			if (_force) then {(_units select _i) moveInDriver _veh};
			_i = _i + 1;
		};	
	};
	
	// If the vehicle does not have a commander
	if (_veh emptyPositions "Commander" > 0 && _i < _grpSize) then {
		if (_grpSize > 1 && _i == 1) then {
			(_units select 0) assignAsCommander _veh;
			if (_force) then {(_units select 0) moveInCommander _veh};
			_i = _i + 1;
		} else {
			(_units select _i) assignAsCommander _veh;
			if (_force) then {(_units select _i) moveInCommander _veh};
			_i = _i + 1;
		};
	};
	
	_gunners = _veh emptyPositions "Gunner";
	_cargo = _veh emptyPositions "Cargo";
	
	while {_gunners > 0 && _i < _grpSize} do {
		if (_force) then {(_units select _i) moveInGunner _veh} else {(_units select _i) assignAsGunner _veh};
		_gunners = _gunners - 1;
		_i = _i + 1;
	};
	
	while {_cargo > 0 && _i < _grpSize} do {
		if (_force) then {(_units select _i) moveInCargo _veh} else {(_units select _i) assignAsCargo _veh};
		_cargo = _cargo - 1;
		_i = _i + 1;
	};
	
} forEach _vehicles;

_i