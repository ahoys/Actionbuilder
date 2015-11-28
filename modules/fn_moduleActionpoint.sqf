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
	waitUntil {!isNil "ACTIONBUILDER_signal"};
	if (!ACTIONBUILDER_signal) exitWith {false};
};

// Required functions -----------------------------------------------------------------------------
if (isNil "Actionbuilder_fnc_listClients" || isNil "Actionbuilder_fnc_transmit") exitWith {
	["Could not find a required function!"] call BIS_fnc_error;
	false
};

// Initialize the Actionbuilder module ------------------------------------------------------------
private ["_ap"];
_ap = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Initialize all the required variables ----------------------------------------------------------
if (isServer) then {
	if (isNil "ACTIONBUILDER_actionpoints") then {ACTIONBUILDER_actionpoints = []};
	if (isNil "ACTIONBUILDER_buffer") then {ACTIONBUILDER_buffer = 0.1};
	if (isNil "ACTIONBUILDER_performance") then {ACTIONBUILDER_performance = [] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_performance.fsm"};
	if (isNil "ACTIONBUILDER_debug") then {ACTIONBUILDER_debug = []};
	if (_ap getVariable ["Debug",false]) then {ACTIONBUILDER_debug pushBack _ap};
};

// Initialize all the required multiplayer variables ----------------------------------------------
if (isServer && isMultiplayer) then {
	if (isNil "ACTIONBUILDER_clients") then {ACTIONBUILDER_clients = ["HeadlessClient_F"] call Actionbuilder_fnc_listClients};
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
	ACTIONBUILDER_actionpoints pushBack _ap;
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