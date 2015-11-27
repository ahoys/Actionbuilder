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
	ARRAY - List of objects, groups and units. Ex. ["obj1","obj2",["grp1","leader","man1"..."man n","veh1"..."veh n"],["grp2"...]]
*/

private["_master","_removeUnit","_removeMaster","_syncedUnits","_acceptedGroups","_acceptedUnits","_i","_vehicle"];
_master				= _this select 0;
_removeUnit			= _this select 1;
_removeMaster		= _this select 2;

_syncedUnits		= _master call BIS_fnc_moduleUnits;
_acceptedGroups		= [];
_acceptedUnits		= [];

if (count _syncedUnits < 1) exitWith {[_master,true,"there are no units synchronized to the portal"] spawn Actionbuilder_fnc_debugHint; _acceptedUnits};
if (isNull _removeUnit) then {_removeUnit = false};
if (isNull _removeMaster) then {_removeMaster = false};

// ADD OBJECTS AND LIST GROUPS
{
	if (isNull group _x) then {
		_acceptedUnits pushBack _x;
		if (_removeUnit) then {deleteVehicle _x};
	} else {
		if !(group _x in _acceptedGroups) then {
			_acceptedGroups pushBack group _x;
		};
	};
} forEach _syncedUnits;

// ADD UNITS INTO GROUPS
{
	_i = count _acceptedUnits;
	_acceptedUnits set [_i, [_x]];												// ["obj1","obj2",["grp1"]]
	(_acceptedUnits select _i) set [1, leader _x];								// ["obj1","obj2",["grp1","man1"]]
	{
		_vehicle = vehicle _x;
		if ((_vehicle isKindOf "Man") && (_x == _vehicle) && (leader _x != _x)) then {
			(_acceptedUnits select _i) pushBack _x;								// ["obj1","obj2",["grp1","man1","man2", ... "mann"]]
		};
		if ((_vehicle isKindOf "LandVehicle") || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship")) then {
			(_acceptedUnits select _i) pushBack (typeOf _x);					// ["obj1","obj2",["grp1","man1","man2", ... "mann","veh1", ... "vehn"]]
			{
				if (_removeUnit) then {deleteVehicle _x};
			} forEach crew _vehicle;
		};
		if (_removeUnit) then {deleteVehicle _x};								// remove from world
	} forEach units _x;
} forEach _acceptedGroups;
if (_removeMaster) then {deleteVehicle _master};

_acceptedUnits