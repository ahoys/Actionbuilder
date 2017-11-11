/*
	File: fn_getSiblingPortals.sqf
	Author: Ari Höysniemi

	Description:
	Returns sibling portals, meaning portals that can be reached through
	units synchronized to this portal. In other words, some units are shared
	with multiple portals and this utility returns those other portals synchronized
	to the unit.

	Parameter(s):
	0: OBJECT - portal module
	1: ARRAY - list of synchronized objects

	Returns:
	BOOL - true, if success
*/

private _portal = param [0, objNull, [objNull]];
private _synced = param [1, synchronizedObjects _portal, [[]]];
private _siblings = [];

if (_synced isEqualTo []) exitWith {_siblings};

// Find all the registered units.
private _units = [];
private _registeredGroups = [];
{
	private _grp = group _x;
	private _side = side _x;
	if (
		!(isNull _grp) &&
		!(_grp in _registeredGroups) &&
		_side in [WEST, EAST, INDEPENDENT, CIVILIAN]
	) then {
		// A new group found.
		_registeredGroups pushback _grp;
		_units = _units + units group _x;
	} else {
		if (isNull _grp && _side == CIVILIAN) then {
			// A new object.
			_units pushback _x;
		};
	};
} forEach _synced;

// Find other portals.
{
	{
		if (typeof _x == "RHNET_ab_modulePORTAL_F" && !(_x in _siblings)) then {
			_siblings pushback _x;
		};
	} forEach synchronizedObjects _x 
} forEach _units;

_siblings