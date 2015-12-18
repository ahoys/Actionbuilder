/*
	File: fn_safeLock.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Calculate whether there are too many units deployed

	Parameter(s):
	0: ARRAY - portals to be considered
	1: NUMBER - the maximum allowed unit count (safelock)

	Returns:
	BOOLEAN - true if success
*/

private["_portals","_max","_count","_obj","_grp"];

_portals	= _this select 0;
_max		= _this select 1;
_count		= count allUnits;

{
	_obj	= RHNET_AB_G_PORTAL_OBJECTS 	select ((RHNET_AB_G_PORTAL_OBJECTS find _x) 	+ 1);
	_grp	= RHNET_AB_G_PORTAL_GROUPS 		select ((RHNET_AB_G_PORTAL_GROUPS find _x) 		+ 1);
	if !(_obj isEqualTo [[]]) then {_count = _count + count _obj};
	{
		if !((_x select 1) isEqualTo [[]]) then {_count = _count + count (_x select 1)};
		if !((_x select 2) isEqualTo [[]]) then {_count = _count + count (_x select 2)};
	} forEach _grp;
} forEach _portals;

diag_log format ["_count: %1, _max: %2", _count, _max];

if (_count < _max) exitWith {false};
true