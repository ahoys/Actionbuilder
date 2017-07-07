/*
	File: fn_readGroups.sqf
	Author: Ari Höysniemi

	Description:
	Reads all groups from a list of units.
	Eg. infantry, crewmen, manned vehicles, etc.

	Parameter(s):
	0: ARRAY - units

	Returns:
	ARRAY - a list of groups
*/
private["_return","_registeredGroups","_grp","_side","_registeredVehicles","_newGrp","_veh"];
_return = [];
_registeredGroups = [];

{
	_grp = group _x;
	_side = side _x;
	// 1) Make sure the group exists,
	// 2) is not already registered,
	// 3) from a valid side (not LOGIC).
	if (
		!(isNull _grp) &&
		!(_grp in _registeredGroups) &&
		_side in [WEST, EAST, GUER, CIVILIAN]
	) then {
		_registeredGroups pushBack _grp;
		_registeredVehicles = [];
		_newGrp = [_side, []]; // [side, [units]]
		{
			_veh = objectParent _x;
			if (isNull _veh) then {
				// On foot.
				(_newGrp select 1) pushBack [
					false,
					[
						typeOf _x,
						getPosATL _x,
						getDir _x,
						damage _x,
						skill _x,
						rank _x
					]
				];
			} else {
				// Manned vehicle.
				if !(_veh in _registeredVehicles) then {
					_registeredVehicles pushBack _veh;
					(_newGrp select 1) pushBack [
						true,
						[
							typeOf _veh,
							getPosATL _veh,
							getDir _veh,
							damage _veh,
							fuel _veh,
							locked _veh
						]
					];
				};
			};
		} forEach units _grp;
		_return pushBack _newGrp;
	};
} forEach (_this select 0);

diag_log format ["AB fn_readGroups: %1", _return];
_return;