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

// Headless clients must wait for everything to get ready -----------------------------------------
if (!isServer) then {
	waitUntil {!isNil "ACTIONBUILDER_portal_objects" && !isNil "ACTIONBUILDER_portal_groups" && !isNil "ACTIONBUILDER_workload"};
};

// Required functions -----------------------------------------------------------------------------
if (isNil "Actionbuilder_fnc_portalSpawn" || 
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
	isNil "Actionbuilder_fnc_isValidkey") exitWith {
		["Missing Actionbuilder functions!"] call BIS_fnc_error;
		false
};

// Initialize the Actionbuilder module ------------------------------------------------------------
private ["_ap","_modules","_portals","_units"];
_ap 			= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_modules 		= _ap call BIS_fnc_moduleModules;
_portals		= [];

// Make sure there are portals available ----------------------------------------------------------
{
	if ((typeOf _x) == "RHNET_ab_modulePORTAL_F") then {
		_portals pushBack _x;
	} else {
		["Not supported module %1 synchronized into actionpoint %2.", typeOf _x, _ap] call BIS_fnc_error;
	};
} forEach _modules;

if (count _portals < 1) exitWith {["Actionpoint %1 has no portals synchronized.", _ap] call BIS_fnc_error; false};

// Initialize all the required variables ----------------------------------------------------------
if (isServer) then {
	if (isNil "ACTIONBUILDER_actionpoints") then {ACTIONBUILDER_actionpoints = []};
	if (isNil "ACTIONBUILDER_buffer") then {ACTIONBUILDER_buffer = 0.1};
	if (isNil "ACTIONBUILDER_performance") then {ACTIONBUILDER_performance = [] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_performance.fsm"};
	if (isNil "ACTIONBUILDER_locations") then {ACTIONBUILDER_locations = []};
	if (isNil "ACTIONBUILDER_portal_objects") then {ACTIONBUILDER_portal_objects = []};
	if (isNil "ACTIONBUILDER_portal_groups") then {ACTIONBUILDER_portal_groups = []};
	if (isNil "ACTIONBUILDER_carbage") then {ACTIONBUILDER_carbage = []};
	if (isNil "ACTIONBUILDER_locations_denied") then {ACTIONBUILDER_locations_denied = []};
	if (isNil "ACTIONBUILDER_groupProgression") then {ACTIONBUILDER_groupProgression = []}; // [group,origin,current,last,next];
	_actionpointsC	= count (["RHNET_ab_moduleAP_F"] call Actionbuilder_fnc_getTypes);
	_portalC 		= count (["RHNET_ab_modulePORTAL_F"] call Actionbuilder_fnc_getTypes); // MONTA AP:TA LUKEE JA JUOKSEE RAAH
	_waypointC 		= count (["RHNET_ab_moduleWP_F"] call Actionbuilder_fnc_getTypes);
	waitUntil {count ACTIONBUILDER_locations >= (_actionpointsC + _portalC + _waypointC)};
};

// Initialize all the required multiplayer variables ----------------------------------------------
if (isServer && isMultiplayer) then {
	if (isNil "ACTIONBUILDER_clients") then {ACTIONBUILDER_clients = ["HeadlessClient_F", true, 1] call Actionbuilder_fnc_getTypes};
	if (isNil "ACTIONBUILDER_workload") then {ACTIONBUILDER_workload = []};
	if (isNil "ACTIONBUILDER_transmit") then {ACTIONBUILDER_transmit = [] spawn Actionbuilder_fnc_transmit};
	if (count ACTIONBUILDER_clients > 0) then {
		if (isNil "ACTIONBUILDER_ap_id") then {ACTIONBUILDER_ap_id = 0};
		if (ACTIONBUILDER_ap_id >= (count ACTIONBUILDER_clients)) then {ACTIONBUILDER_ap_id = 0};
		ACTIONBUILDER_workload pushBack [_ap,(ACTIONBUILDER_clients select ACTIONBUILDER_ap_id)];
		ACTIONBUILDER_ap_id = ACTIONBUILDER_ap_id + 1;
	};
};

// Register actionpoint and execute the main loop -------------------------------------------------
if (isServer) then {
	if (isMultiplayer) then {
		if (count ACTIONBUILDER_workload > 0) exitWith {true};
	};
	//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_actionpoint.fsm";
	//waitUntil {completedFSM _actionfsm};
} else {
	{
		if (_x select 0 == _ap) then {
			if (_x select 1 == format ["%1", player]) then {
				//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_actionpoint.fsm";
				//waitUntil {completedFSM _actionfsm};
			};
		};
	} forEach ACTIONBUILDER_workload;
};

true