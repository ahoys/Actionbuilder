/*
	File: fn_verifyFunctions.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Makes sure all required functions are available

	Parameter(s):
	NOTHING

	Returns:
	BOOLEAN - true if success
*/

private["_valid"];

if (
	isNil "Actionbuilder_fnc_moduleActionpoint"            ||
	isNil "Actionbuilder_fnc_verifyFunctions"              ||
	isNil "Actionbuilder_fnc_initPortals"                  ||
	isNil "Actionbuilder_fnc_modulePortal"                 ||
	isNil "Actionbuilder_fnc_spawnUnits"                   ||
	isNil "Actionbuilder_fnc_command"                      ||
	isNil "Actionbuilder_fnc_deleteSyncedUnits"            ||
	isNil "Actionbuilder_fnc_getClosestSynced"             ||
	isNil "Actionbuilder_fnc_getSyncedGroups"              ||
	isNil "Actionbuilder_fnc_getSynchronizedObjectTypes"   ||
	isNil "Actionbuilder_fnc_getTypes"                     ||
	isNil "Actionbuilder_fnc_isValidkey"                   ||
	isNil "Actionbuilder_fnc_objectsAhead"                 ||
	isNil "Actionbuilder_fnc_punish"                       ||
	isNil "Actionbuilder_fnc_assignWaypoint"               ||
	isNil "Actionbuilder_fnc_loadVehicles"                 ||
	isNil "Actionbuilder_fnc_moduleWaypoint"               ||
	isNil "Actionbuilder_fnc_populateSeats"                ||
	isNil "Actionbuilder_fnc_prioritizeSeats"              ||
	isNil "Actionbuilder_fnc_selectWaypoint"               ||
	isNil "Actionbuilder_fnc_sendVehiclesAway"             ||
	isNil "Actionbuilder_fnc_unloadVehicles"
) then {
	_valid = false;
	["Missing Actionbuilder functions!"] call BIS_fnc_error;
} else {
	_valid = true;
};

RHNET_AB_L_FUNCTIONVALIDITY = _valid;
_valid