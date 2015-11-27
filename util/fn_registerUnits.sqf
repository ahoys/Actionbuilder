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
_master				= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_removeUnit			= [_this, 1, true, [true]] call BIS_fnc_param;
_removeMaster		= [_this, 2, false, [false]] call BIS_fnc_param;

if (isNull _master) exitWith {[_master,true,"the master object is missing"] spawn Actionbuilder_fnc_debugHint; []};

_syncedUnits		= _master call BIS_fnc_moduleUnits;
_acceptedGroups		= [];
_acceptedUnits		= [];

if (count _syncedUnits < 1) exitWith {[_master,true,"there are no units synchronized to the portal"] spawn Actionbuilder_fnc_debugHint; []};

// 1. List objects and groups
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

// 2. Add units into the listed groups
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