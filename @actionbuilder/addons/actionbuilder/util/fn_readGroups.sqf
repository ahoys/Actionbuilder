/*
	File: fn_readGroups.sqf
	Author: Ari Höysniemi

	Description:
	Reads all groups from a list of units.
	Eg. infantry, crewmen, manned vehicles, etc.

	Parameter(s):
	0: ARRAY - units

	Returns:
	ARRAY - [total count of units, [list of groups]]
*/
private _units = _this select 0;
private _groups = [];
private _totalUnits = 0;
private _registeredGroups = [];

if (_units isEqualTo []) exitWith {[0, []]};

{
	private _grp = group _x;
	private _side = side _x;
	// 1) Make sure the group exists,
	// 2) is not already registered,
	// 3) from a valid side (not LOGIC).
	if (
		!(isNull _grp) &&
		!(_grp in _registeredGroups) &&
		_side in [WEST, EAST, INDEPENDENT, CIVILIAN]
	) then {
		_registeredGroups pushBack _grp;
		private _registeredVehicles = [];
		private _newGrp = [_side, [], []]; // [side, [vehicles], [infantry]].
		{
			private _veh = objectParent _x;
			if (isNull _veh) then {
				// On foot.
				(_newGrp select 2) pushBack [
					typeOf _x,
					getPosATL _x,
					getDir _x
				];
				// Count all the units.
				_totalUnits = _totalUnits + 1;
			} else {
				// Manned vehicle.
				if !(_veh in _registeredVehicles) then {
					_registeredVehicles pushBack _veh;
					(_newGrp select 1) pushBack [
						typeOf _veh,
						getPosATL _veh,
						getDir _veh
					];
					// Count all the units.
					_totalUnits = _totalUnits + (count crew _veh);
				};
			};
		} forEach units _grp;
		_groups pushBack _newGrp;
	};
} forEach _units;

[_totalUnits, _groups];