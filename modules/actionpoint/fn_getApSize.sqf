/*
	File: fn_getApSize.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Get size of pools linked to an actionpoint.

	Parameter(s):
	0: ARRAY - synchronized portals

	Returns:
	NUMBER - size of the pools (units counted)
*/

private["_portals","_return","_objects","_groups"];
_portals = _this select 0;
_return = 0;

{
	_objects = RHNET_AB_G_PORTAL_OBJECTS select ((RHNET_AB_G_PORTAL_OBJECTS find _x) + 1);
	_groups = RHNET_AB_G_PORTAL_GROUPS select ((RHNET_AB_G_PORTAL_GROUPS find _x) + 1);
	_return = _return + (_objects select 0) + (_groups select 0);
} forEach _portals;

_return