/*
	File: fn_initPortals.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Register synchronized groups and objects, remove all after the registration

	Parameter(s):
	NOTHING

	Returns:
	NOTHING
*/

private["_objects","_groups","_parents","_i","_vehicle"];

// Register units
{
	
	_objects 	= [];
	_groups		= [];
	_parents	= [];
	_i			= 0;
	
	{
		if (_x isKindOf "Man") then {
			_groups pushBack [side _x, [], []];
			{
				if (isNull objectParent _x) then {
					// Infantry
					((_groups select _i) select 1) pushBack [typeOf _x, getPosATL _x, getDir _x];
				} else {
					// Crewman
					_vehicle = objectParent _x;
					if !(_vehicle in _parents) then {
						_parents pushBack _vehicle;
						((_groups select _i) select 2) pushBack [typeOf _vehicle, getPosATL _vehicle, getDir _vehicle];
					};
				};
			} forEach units group _x;
			_i = _i + 1;
		} else {
			if (side _x == CIVILIAN) then {
				// Object
				_objects pushBack [typeOf _x, getPosATL _x, getDir _x];
			};
		};
	} forEach synchronizedObjects _x;
	
	RHNET_AB_G_PORTAL_OBJECTS pushBack _x;
	RHNET_AB_G_PORTAL_OBJECTS pushBack _objects;
	
	RHNET_AB_G_PORTAL_GROUPS pushBack _x;
	RHNET_AB_G_PORTAL_GROUPS pushBack _groups;
	
} forEach RHNET_AB_G_PORTALS;

// Remove units
{
	{
		call {
			if (_x isKindOf "LOGIC") exitWith {};
			if (isNull group _x) exitWith {deleteVehicle _x};
			{
				if (isNull objectParent _x) then {
					deleteVehicle _x;
				} else {
					_vehicle = objectParent _x;
					{
						deleteVehicle _x;
					} forEach crew _vehicle;
					deleteVehicle _vehicle;
				};
			} forEach units group _x;
		};
	} forEach synchronizedObjects _x;
} forEach RHNET_AB_G_PORTALS;

true