/*
	File: fn_readGroups.sqf
	Author: Ari Höysniemi

	Description:
	Reads all groups from a list of units.
	Eg. infantry, crewmen, manned vehicles, etc.

	Parameter(s):
	0: ARRAY - units

	Returns:
	ARRAY - a list of objects
*/
private _return = [];
private _registeredGroups = [];

{
	private _grp = group _x;
	private _side = side _x;
	if (
		!isNull _grp &&
		!_grp in _registeredGroups &&
		_side in ["WEST", "EAST", "GUER", "CIVILIAN"]
	) then {
		_registeredGroups pushBack _grp;
		private _newGrp = [_side, []];
		{

		} forEach units _grp;
		_return pushBack _newGrp;
	};
} forEach _this select 0;

_return;