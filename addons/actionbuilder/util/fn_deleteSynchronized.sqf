/*
	File: fn_deleteSynchronized.sqf
	Author: Ari Höysniemi

	Description:
	Remove synchronizated groups, units and other objects

	Parameter(s):
	0: ARRAY - a list of objects with synchronizations
	1 (Optional): ARRAY - a list of object types to be excluded

	Returns:
	Nothing
*/

private _masters = param [0, [], [[]]];
private _excludes = param [1, [], [[]]];

{
	{
		if !(typeOf _x in _excludes) then {
			if (isNull group _x) then {
				deleteVehicle _x;
			} else {
				{
					if (isNull objectParent _x) then {
						deleteVehicle _x;
					} else {
						private _vehicle = objectParent _x;
						{
							deleteVehicle _x;
						} forEach crew _vehicle;
						deleteVehicle _vehicle;
					};
				} forEach units group _x;
			};
		};
	} forEach synchronizedObjects _x;
} forEach _masters;

true