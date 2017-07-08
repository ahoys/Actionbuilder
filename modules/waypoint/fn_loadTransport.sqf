/*
	File: fn_loadTransport.sqf
	Author: Ari Höysniemi

	Description:
	Orders a group's afoot units to get in to the group's
	cargo vehicles.

	Parameter(s):
	0: ARRAY - units

	Returns:
	ARRAY - [total count of units, [list of groups]]
*/
private _afoot = [];
private _vehicles = [];
// First find out who needs a seat and
// what vehicles are there to be used.
{
	private _veh = objectParent _x;
	if (isNull _veh) then {
		// Requires a seat.
		_afoot pushBack _x;
	} else {
		// Has a seat, but may also have a vehicle
		// for others to use.
		if !(_veh in _vehicles) then {
			private _c = _veh emptyPositions "cargo";
			if (_c > 0) then {
				_vehicles pushBack [_c, _veh];
			};
		};
	};
} forEach units (_this select 0);

diag_log format ["AB fn_loadTransport 0: %1, %2", _afoot, _vehicles];

if (_afoot isEqualTo []) exitWith {true}; // Everyone already in.
if (_vehicles isEqualTo []) exitWith {false}; // No vehicles to use.

// Next attempt to find an order in which the vehicles
// are filled. Prioritize vehicles with much cargo space to the top.
private _priorizedVehicles = [];
{
	private _veh = _x;
	if (_priorizedVehicles isEqualTo []) then {
		_priorizedVehicles pushBack _veh;
	} else {
		// Re-prioritize the list.
		private _t = [];
		private _last = true;
		{
			if ((_veh select 0) >= (_x select 0)) then {
				// Has more seats.
				_t pushBack _veh;
				_t pushBack _x;
				_last = false;
			} else {
				// Has less seats.
				_t pushBack _x;
			};
		} forEach _priorizedVehicles;
		if (_last) then {
			// This vehicle is the smallest available.
			_t pushBack _veh;
		};
		_priorizedVehicles = _t;
	};
} forEach _vehicles;

diag_log format ["AB fn_loadTransport 1: %1", _priorizedVehicles];

// Assign seats to afoot units.
{
	private _u = _x;
	private _i = 0;
	scopeName "main";
	{
		if ((_x select 0) > 0) then {
			// A cargo vehicle found, assign the unit and reduce
			// the available seats.
			_u assignAsCargo (_x select 1);
			if (_this select 1) then {
				// Force get in.
				_u moveInCargo (_x select 1);
			};
			_priorizedVehicles set [_i, [(_x select 0) - 1, _x select 1]];
			breakTo "main";
		};
		_i = _i + 1;
	} forEach _priorizedVehicles;
} forEach _afoot;

// Make the final get in order.
// Not required if the group has already been force moved in.
if !(_this select 1) then {
	_afoot orderGetIn true;
};

true