/*
	File: fn_moduleActionpoint.sqf
	Author: Ari Höysniemi

	Description:
	Initializes a new actionpoint

	Parameter(s):
	0: OBJECT - actionpoint module

	Returns:
	Nothing
*/

// Only the server and headless clients are allowed to continue -----------------------------------
if (!isServer && hasInterface) exitWith {false};

private ["_ap","_valid","_modules","_portals","_units","_worker"];
_ap 	= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_valid 	= true;

// Headless clients must wait for everything to get ready -----------------------------------------
if (!isServer) then {
	waitUntil {
		!isNil "ACTIONBUILDER_locations" &&
		!isNil "ACTIONBUILDER_portal_objects" && 
		!isNil "ACTIONBUILDER_portal_groups" && 
		!isNil "ACTIONBUILDER_workload"
	};
};

// Required functions -----------------------------------------------------------------------------
if (
	isNil "Actionbuilder_fnc_initPortals" ||
	isNil "Actionbuilder_fnc_portalSpawn" || 
	isNil "Actionbuilder_fnc_transmit" || 
	isNil "Actionbuilder_fnc_assignWp" ||
	isNil "Actionbuilder_fnc_selectWp" ||
	isNil "Actionbuilder_fnc_sva" ||
	isNil "Actionbuilder_fnc_getTypes" ||
	isNil "Actionbuilder_fnc_objectsAhead" ||
	isNil "Actionbuilder_fnc_getSyncedObjects" ||
	isNil "Actionbuilder_fnc_getSyncedGroups" ||
	isNil "Actionbuilder_fnc_deleteSyncedUnits" ||
	isNil "Actionbuilder_fnc_getClosestSynced" ||
	isNil "Actionbuilder_fnc_punish" ||
	isNil "Actionbuilder_fnc_command" ||
	isNil "Actionbuilder_fnc_isValidkey"
	) then {
		["Missing Actionbuilder functions!"] call BIS_fnc_error;
		_valid = false;
};

// Initialize the Actionbuilder module ------------------------------------------------------------
if (isServer && _valid) then {
	_modules 	= _ap call BIS_fnc_moduleModules;
	_portals	= [];
	
	// Make sure there are portals available ----------------------------------------------------------
	{
		if (typeOf _x == "RHNET_ab_modulePORTAL_F") then {
			_portals pushBack _x;
		} else {
			["Not supported module %1 synchronized to actionpoint %2.", typeOf _x, _ap] call BIS_fnc_error;
		};
	} forEach _modules;
	
	// Initialize all the required variables ----------------------------------------------------------
	if (isNil "ACTIONBUILDER_locations") then {
		ACTIONBUILDER_locations 		= [];
		ACTIONBUILDER_locations_denied	= [];
		ACTIONBUILDER_portal_objects 	= [];
		ACTIONBUILDER_portal_groups 	= [];
		ACTIONBUILDER_groupProgression 	= [];
		ACTIONBUILDER_buffer 			= 0.1;
		ACTIONBUILDER_performance 		= [] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_performance.fsm";
		ACTIONBUILDER_portals			= [] call Actionbuilder_fnc_initPortals;
		if (isMultiplayer) then {
			ACTIONBUILDER_workload 		= [];
			ACTIONBUILDER_transmit 		= [] spawn Actionbuilder_fnc_transmit;
			ACTIONBUILDER_clients 		= ["HeadlessClient_F", true, 1] call Actionbuilder_fnc_getTypes;
			ACTIONBUILDER_id 			= 0;
		};
	};
};

// Decide workload between headless clients -------------------------------------------------------
if (isServer && isMultiplayer && _valid) then {
	if (count ACTIONBUILDER_clients > 0) then {
		if (ACTIONBUILDER_id >= (count ACTIONBUILDER_clients)) then {
			ACTIONBUILDER_id = 0
		};
		ACTIONBUILDER_workload pushBack _ap;
		ACTIONBUILDER_workload pushBack (ACTIONBUILDER_clients select ACTIONBUILDER_id);
		ACTIONBUILDER_id = ACTIONBUILDER_id + 1;
	};
};

// Register actionpoint and execute the main loop -------------------------------------------------
if (isServer && _valid) then {
	if (isMultiplayer) then {
		if (count ACTIONBUILDER_workload < 1) then {
			//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_actionpoint.fsm";
			//waitUntil {completedFSM _actionfsm};
		};
	};
} else {
	_worker = ACTIONBUILDER_workload select ((ACTIONBUILDER_workload find _ap) + 1);
	if (_worker == format ["%1", player]) then {
		//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_actionpoint.fsm";
		//waitUntil {completedFSM _actionfsm};
	};
};

_valid