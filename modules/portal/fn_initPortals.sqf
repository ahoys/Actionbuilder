/*
	File: fn_initPortals.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Register synchronized groups and objects

	Parameter(s):
	NOTHING

	Returns:
	NOTHING
*/

private["_objects","_groups","_i","_vehicle"];

{
	
	_objects 	= [];
	_groups		= [];
	_i			= 0;
	
	{
		if !(isNull _x) then {
			if (_x isKindOf "Man") then {
				_groups pushBack [side _x, [], []];
				{
					if (isNull objectParent _x) then {
						// Man
						((_groups select _i) select 1) pushBack [typeOf _x, getPosATL _x, getDir _x];
						deleteVehicle _x;
					} else {
						// Vehicle leader
						_vehicle = objectParent _x;
						((_groups select _i) select 2) pushBack [typeOf _vehicle, getPosATL _vehicle, getDir _vehicle];
						{
							deleteVehicle _x;
						} forEach crew _vehicle;
						deleteVehicle _vehicle;
					};
				} forEach units group _x;
				_i = _i + 1;
			} else {
				if (side _x == CIVILIAN) then {
					// Object
					_objects pushBack [typeOf _x, getPosATL _x, getDir _x];
					deleteVehicle _x;
				};
			};
		};
	} forEach synchronizedObjects _x;
	
	RHNET_AB_G_PORTAL_OBJECTS pushBack _x;
	RHNET_AB_G_PORTAL_OBJECTS pushBack _objects;
	
	RHNET_AB_G_PORTAL_GROUPS pushBack _x;
	RHNET_AB_G_PORTAL_GROUPS pushBack _groups;
	
} forEach RHNET_AB_G_PORTALS;

true