/*
	File: fn_populateSeats.sqf
	Author: Ari Höysniemi

	Description:
	Populate given seats

	Parameter(s):
	0: ARRAY - units to be seated [u1, u2, u3]
	1: ARRAY - list of available seats [[car1, "Driver"],[car2,"Cargo"]]
	2: BOOL - true to force populate
	
	Returns:
	ARRAY - units seated
*/

private["_units","_seats","_force","_seated","_c","_i"];
_units		= _this select 0;
_seats		= _this select 1;
_force		= _this select 2;
_seated		= [];
_c			= count _seats;
_i			= 0;

{
	if (_c <= _i) exitWith {};
	call {
		if (_x select 1 == "Driver") exitWith {
			if (isNull driver (_x select 0)) then {
				if (_force) then {(_units select _i) moveInDriver (_x select 0)} else {(_units select _i) assignAsDriver (_x select 0)};
			};
		};
		if (_x select 1 == "Gunner") exitWith {
			if (_force) then {(_units select _i) moveInGunner (_x select 0)} else {(_units select _i) assignAsGunner (_x select 0)};
		};
		if (_x select 1 == "Commander") exitWith {
			if (_force) then {(_units select _i) moveInCommander (_x select 0)} else {(_units select _i) assignAsCommander (_x select 0)};
		};
		if (_x select 1 == "Cargo") exitWith {
			if (_force) then {(_units select _i) moveInCargo (_x select 0)} else {(_units select _i) assignAsCargo (_x select 0)};
		};
	};
	_seated pushBack (_units select _i);
	_i = _i + 1;
} forEach _seats;

if !(_force) then {_seated orderGetIn true};

_seated