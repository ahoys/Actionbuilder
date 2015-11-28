/*
	File: fn_registerUnits.sqf
	Author: Ari Höysniemi

	Description:
	Return an array of synchronized units in a categorized fashion

	Parameter(s):
	0: OBJECT - object with units synchronized
	1 (Optional): BOOL - true to remove synchronized unit after the registeration (default: false)
	2 (Optional): BOOL - true to remove object after the registeration (default: false)

	Returns:
	ARRAY - List of objects, groups and units. Ex. [["obj1","obj2"..."objN"],[["side","man1"..."manN"],["side","man1"..."manN"]]]
*/

private["_master","_removeUnit","_removeMaster","_syncedUnits","_acceptedObjects","_acceptedGroups","_vehicle","_acceptedUnits"];
_master				= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_removeUnit			= [_this, 1, true, [true]] call BIS_fnc_param;
_removeMaster		= [_this, 2, false, [false]] call BIS_fnc_param;

if (isNull _master) exitWith {["The master object is null. The master object should be an actual object."] call BIS_fnc_error; []};

_syncedUnits		= _master call BIS_fnc_moduleUnits;
_acceptedObjects	= [];
_acceptedGroups		= [];

if (count _syncedUnits < 1) exitWith {["%1 has no units synchronized.", _master] call BIS_fnc_error; []};

// Loop through all synchronized units and categorize them either into objects or groups
{
	if (isNull group _x) then {
		// Caregory: object - ["obj1","obj2"..."objN"]
		_acceptedObjects pushBack (typeOf _x);
		if (_removeUnit) then {deleteVehicle _x};
	} else {
		// Category: group - ["side","man1"..."manN"],["grp2","side","leader","man1"..."manN"]
		if (!isNull _x) then {
			if ((_acceptedGroups find [group _x]) < 0) then {
				// Register group and define its side and leader
				_acceptedGroups pushBack [side _x];
				{
					// Add units for the group
					_vehicle = vehicle _x;
					if ((_vehicle isKindOf "Man") && (_x == _vehicle)) then {
						(_acceptedGroups select (count _acceptedGroups - 1)) pushBack (typeOf _x);
						if (_removeUnit) then {deleteVehicle _x};
					};
					if ((_vehicle isKindOf "LandVehicle") || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship")) then {
						(_acceptedGroups select (count _acceptedGroups - 1)) pushBack (typeOf _vehicle);
						if (_removeUnit) then {
							{
								deleteVehicle _x;
							} forEach crew _vehicle;
							deleteVehicle _vehicle;
						};
					};
				} forEach units (group _x);
			};
		};
	};
} forEach _syncedUnits;

if (_removeMaster) then {deleteVehicle _master};

_acceptedUnits = [_acceptedObjects,_acceptedGroups];
_acceptedUnits