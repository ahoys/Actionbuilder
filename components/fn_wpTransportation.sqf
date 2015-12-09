private["_units","_force","_range","_primaryVehicles","_seats"];

_units 				= _this select 0;			// All units to be seated
_force				= _this select 1;			// Whether to force units in
_range				= _this select 2;			// Range of secondary vehicles
_primaryVehicles	= [];						// Group's own vehicles
_seats				= [];

// Look for primary vehicles and already seated units
{
	if (vehicle _x != _x) then {
		if !(vehicle _x in _primaryVehicles) then {
			_primaryVehicles pushBack (vehicle _x);
		};
	};
} forEach _units;

// Prioritise seats
_seats = [_primaryVehicles] call Actionbuilder_fnc_wpPrioritizeSeats;

// Populate primary vehicles
_outside = [_units, _seats] call Actionbuilder_fnc_wpPopulateSeats;

// If units outside, search for secondary vehicles
if (count _outside > 0) then {
	// Look for secondary vehicles
	_secondaryVehicles = nearestObjects [_units select 0, ["Car","Tank","Ship","Air"], _range];
	
	if (count _secondaryVehicles > 0) then {
		// Prioritise seats
		_seats = [_secondaryVehicles] call Actionbuilder_fnc_wpPrioritizeSeats;
		
		// Populate secondary vehicles
		_outside = [_outside, _seats] call Actionbuilder_fnc_wpPopulateSeats;
	};
};

// If still units outside, return false
if (count _outside > 0) exitWith {false};

true