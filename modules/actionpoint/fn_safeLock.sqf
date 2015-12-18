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
diag_log format ["TEST %1", count allUnits];
{
	_obj	= RHNET_AB_G_PORTAL_OBJECTS 	select ((RHNET_AB_G_PORTAL_OBJECTS find _x) 	+ 1);
	_grp	= RHNET_AB_G_PORTAL_GROUPS 		select ((RHNET_AB_G_PORTAL_GROUPS find _x) 		+ 1);
	_count = _count + count _obj;
	{
		_count = _count + count (_x select 1);
		_count = _count + count (_x select 2);
		diag_log format ["ARRAY 1: %1", _x select 1];
		diag_log format ["ARRAY 2: %1", _x select 2];
	} forEach _grp;
} forEach _portals;

diag_log format ["safeLock registered: %1", _count];

if (_count >= _max) exitWith {false};
true