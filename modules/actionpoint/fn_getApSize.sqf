/*
	File: fn_getApSize.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Get size of pools linked to an actionpoint

	Parameter(s):
	0: ARRAY - synchronized portals

	Returns:
	NUMBER - size of the pools (units counted)
*/

private["_portals","_count","_obj","_grp"];

_portals 	= _this select 0;
_count		= 0;

if (_portals isEqualTo []) exitWith {0};

{
	_obj	= RHNET_AB_G_PORTAL_OBJECTS 	select ((RHNET_AB_G_PORTAL_OBJECTS find _x) 	+ 1);
	_grp	= RHNET_AB_G_PORTAL_GROUPS 		select ((RHNET_AB_G_PORTAL_GROUPS find _x) 		+ 1);
	if !(_obj isEqualTo [[]]) then {_count = _count + count _obj};
	{
		if !((_x select 1) isEqualTo [[]]) then {_count = _count + count (_x select 1)};
		if !((_x select 2) isEqualTo [[]]) then {_count = _count + count (_x select 2)};
	} forEach _grp;
} forEach _portals;

_count