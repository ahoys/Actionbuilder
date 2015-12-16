/*
	File: fn_getPoolCount.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Returns count of units inside the given pools

	Parameter(s):
	0: ARRAY - a list of portals to check

	Returns:
	NUMBER - number of units inside a pool
*/

private["_portals"];

_portals 	= _this select 0;
_count		= 0;

{
	_keyObj = RHNET_AB_G_PORTAL_OBJECTS find _x;
	_keyGrp = RHNET_AB_G_PORTAL_GROUPS find _x;
	
} forEach _portals;

_count