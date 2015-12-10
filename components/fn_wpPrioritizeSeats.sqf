/*
	File: fn_wpPrioritizeSeats.sqf
	Author: Ari Höysniemi

	Description:
	Return vehicle seats in a prioritized order

	Parameter(s):
	0: OBJECT/ARRAY - target vehicle(s) to be seat prioritized

	Returns:
	ARRAY - prioritized seats, the most important seats first, vehicle at time. Example: [[veh1, "Driver"].[veh1, "Gunner"].[veh2, "Driver"]]
	Possible seats are: Driver, Gunner, Commander, Cargo
*/

private["_target","_prioritized","_vehicles","_vehicle","_noGunner"];
_target = [_this, 0, objNull, [objNull, []]] call BIS_fnc_param;
_prioritized = [];

switch (typeName _target) do {
	case "OBJECT": {_vehicles = [_target]};
	case "ARRAY": {_vehicles = _target};
};

{
	_vehicle = _x;
	_noGunner = true;
	{
		switch (_x select 0) do {
			case "Driver": {
				_seats pushBack [_vehicle, "Driver"];
			};
			case "Turret": {
				if (_noGunner) then {
					_noGunner = false;
					_seats pushBack [_vehicle, "Gunner"];
				} else {
					_seats pushBack [_vehicle, "Commander"];
				};
			};
			case "Cargo": {
				_seats pushBack [_vehicle, "Cargo"];
			};
		};
	} forEach ([_x] call BIS_fnc_vehicleRoles);
} forEach _vehicles;

_prioritized