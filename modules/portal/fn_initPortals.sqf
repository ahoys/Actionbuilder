/*
	File: fn_initPortals.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Validates portals, registers units

	Parameter(s):
	NOTHING

	Returns:
	NOTHING
*/

private["_groups","_newGroup"];

{
	
	// Register objects
	RHNET_AB_G_PORTAL_OBJECTS pushBack _x;
	RHNET_AB_G_PORTAL_OBJECTS pushBack ([_x, true] call Actionbuilder_fnc_getSynchronizedObjectTypes);
	
	// Register groups
	_groups = [];
	_i = 0;
	{
		_groups pushBack [side _x, [], []];
		{
			if (isNull objectParent _x) then {
				((_groups select _i) select 1) pushBack [typeOf _x, getPosATL _x, getDir _x];
				deleteVehicle _x;
			} else {
				_vehicle = objectParent _x;
				if !((isNull _vehicle) || (_vehicle in ((_groups select _i) select 2))) then {
					((_groups select _i) select 2) pushBack [typeOf _vehicle, getPosATL _vehicle, getDir _vehicle];
					{
						deleteVehicle _x;
					} forEach crew _vehicle;
					deleteVehicle _vehicle;
				};
			};
		} forEach units _x;
		_i = _i + 1;
	} forEach ([_x, false] call Actionbuilder_fnc_getSynchronizedGroups);
	
	RHNET_AB_G_PORTAL_GROUPS pushBack _x;
	RHNET_AB_G_PORTAL_GROUPS pushBack _groups;		// [p1, [[g1],[g2]], p2, [[g3],[g4]]]
	
} forEach RHNET_AB_G_PORTALS;

true