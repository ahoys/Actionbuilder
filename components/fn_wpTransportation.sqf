private[];

_units 				= units _this select 0;		// All units to be seated
_force				= _this select 1;			// Whether to force units in
_range				= _this select 2;			// Range of secondary vehicles
_unitsC				= count _units;
_primaryVehicles	= [];						// Group's own vehicles
_secondaryVehicles	= [];						// Nearby vehicles
_seated				= [];						// Already seated units
_outside			= [];						// Still outside

// Look for primary vehicles and already seated units
{
	if (vehicle _x != _x) then {
		if !(vehicle _x in _primaryVehicles) then {
			_primaryVehicles pushBack (vehicle _x);
		};
		_seated pushBack _x;
	};
} forEach _units;

// Populate primary vehicles
{
	{
		switch (_x select 0) do {
			case "Driver": {
				if ((isNull driver _x) && ((count _seated) < _unitsC)) then {
					// TODO: SELECT DRIVER
				};
			};
			case "Turret": {
				// Units select gunners
				{
				
				} forEach (_x select 1);
			};
			case "Commander": {
				if ((isNull commander _x) && ((count _seated) < _unitsC)) then {
					// TODO: SELECT COMMANDER
				};
			};
			case "Cargo": {
				// Rest of the units is cargo
				{
				
				} forEach (_x select 1);
			};
			default {
				// Cargo
				{
				
				} forEach (_x select 1);
			};
	} [_x] call BIS_fnc_vehicleRoles;
} forEach _primaryVehicles;

// If units outside, search for secondary vehicles
if ((count _seated) < (count _units)) then {
	// Look for secondary vehicles
	
	// Populate secondary vehicles
};

// If units outside, return false
if ((count _seated) < (count _units)) exitWith {false};

true