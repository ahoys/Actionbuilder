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
private["_toBeSeated","_vehicle","_force","_hasDriver","_hasCargo"];
_toBeSeated	= _this select 0;
_vehicle	= _this select 1;
_force		= _this select 2;
_hasDriver	= false;
_hasCargo	= _vehicle emptyPositions "Cargo";

if (_vehicle emptyPositions "Driver" isEqualTo 0) then {_hasDriver = true};

{
	call {
		if !(_hasDriver) exitWith {
			_x assignAsDriver _vehicle;
			if (_force || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship")) then {_x moveInDriver _vehicle};
			_hasDriver = true;
		};
		if !(_hasCargo isEqualTo 0) exitWith {
			_x assignAsCargo _vehicle;
			if (_force || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship")) then {_x moveInCargo _vehicle};
			_hasCargo = _hasCargo - 1;
		};
	};
} forEach _toBeSeated;

true