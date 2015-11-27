/*

	Author: Raunhofer
	Last Update: d05/m10/y15
	
	Title: ACTIONPOINT MODULE
	Description: Initializes Actionbuilder
	
	Duty: If all conditions are met, spawn a portal function.

*/

// --- Only the server and headless clients are allowed to continue -------------------------------------------------------------------
if (!isServer && hasInterface) exitWith {false};

// --- Initialize the Actionbuilder module --------------------------------------------------------------------------------------------
private ["_ap","_pairArray","_processer","_actionfsm","_threadInit"];
_ap = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// --- Register headless clients and initialize actionbuilder -------------------------------------------------------------------------
if (isNil "RHNET_ab_locations_used" || isNil "RHNET_ab_groups") then {
	RHNET_ab_locations_used	= [];												// Local. Last time used waypoints
	RHNET_ab_groups			= [];												// Local. Spawned groups
	RHNET_ab_buffer			= 0;												// Local. This buffer will act as a delay for spawning etc.
	RHNET_ab_cycle			= [] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_performance.fsm";
	if (isServer) then {														// Must not be overwritten by clients
		RHNET_ab_apid		= 0;												// Actionpoint's id (in case of distributed workload)
		RHNET_ab_ready		= [];												// Registered actionpoints, ready to be performed (in case of distributed workload)
		RHNET_ab_workload	= [];												// In case of headless clients, contains pairs of actionpoints and clients
		RHNET_ab_locations 	= [];												// Registered actionbuilder locations (like portals)
		RHNET_ab_units 		= [];												// Registered units
		RHNET_ab_clients	= ["HeadlessClient_F"] call Actionbuilder_fnc_listClients;
		publicVariable		"RHNET_ab_clients";
	};
};

// --- Wait until the initialization is done -------------------------------------------------------------------------------------------
waitUntil {!isNil "RHNET_ab_ready" && !isNil "RHNET_ab_clients" && !isNil "RHNET_ab_locations"};
waitUntil {(isServer) || (_ap in RHNET_ab_ready)};								// Clients must wait until the ap is ready
waitUntil {(count RHNET_ab_locations > 0)};										// Wait for locations, so that there would be something to do		

// --- Assign workload -----------------------------------------------------------------------------------------------------------------
if (isServer && (count RHNET_ab_clients > 0) && isMultiplayer) then {
	_pairArray = [];
	if (RHNET_ab_apid >= (count RHNET_ab_clients)) then {						// Assign actionpoint to a client
		RHNET_ab_apid 		= 0;
		_pairArray			= [_ap, format ["ab_headlessclient%1", RHNET_ab_apid]];
	} else {
		_pairArray			= [_ap, format ["ab_headlessclient%1", RHNET_ab_apid]];
		RHNET_ab_apid		= RHNET_ab_apid + 1;
	};
	RHNET_ab_workload		set [count RHNET_ab_workload, _pairArray];
	publicVariable			"RHNET_ab_workload";								// Broadcast updated workload
	RHNET_ab_ready 			set [count RHNET_ab_ready, _ap];
	publicVariable			"RHNET_ab_ready";									// Broadcast this actionpoint to be ready
};

// --- Exec actionpoint's main core ----------------------------------------------------------------------------------------------------
if (!isServer && isMultiplayer) then {
	{
		if (_x select 0 == _ap) then {
			if (_x select 1 == format ["%1", player]) then {					// Client and the actionpoint is a match, begin working
				_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_actionpoint.fsm";
				waitUntil {completedFSM _actionfsm};
			};	
		};
	} forEach RHNET_ab_workload;
};

if (isServer && (count RHNET_ab_clients < 1)) then {							// No clients available, let the server do the work
	_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\logic\rhfsm_actionpoint.fsm";
	waitUntil {completedFSM _actionfsm};
};

true