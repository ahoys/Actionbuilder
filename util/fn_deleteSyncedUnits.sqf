/*
	File: fn_deleteSyncedUnits.sqf
	Author: Ari Höysniemi

	Description:
	Removes synchronized units from the world

	Parameter(s):
	0: OBJECT - object with synchronized units
	1: BOOLEAN - true to remove the object too

	Returns:
	Nothing
*/

if (!isServer) exitWith {false};

private["_master","_removeMaster"];
_master			= param [0, objNull, [objNull]];
_removeMaster	= param [1, false, [false]];
_synchronized	= _master call BIS_fnc_moduleUnits;

{
	if (isNull group _x) then {
		// Empty object
		deleteVehicle _x;
	} else {
		// Group
		if (!isNil "_x") then {
			{
				_vehicle = vehicle _x;
				if (_vehicle isKindOf "Man") then {
					deleteVehicle _x;
				} else {
					{
						_vehicle deleteVehicleCrew _x;
					} forEach crew _vehicle;
					deleteVehicle _vehicle;
				};
			} forEach units (group _x);
		};
	};
} forEach _synchronized;

if (_removeMaster) then {deleteVehicle _master};

true