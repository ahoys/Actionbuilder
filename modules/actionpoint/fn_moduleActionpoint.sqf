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

private["_ap","_portals","_worker"];
_ap 		= _this select 0;
_portals	= [_ap, true] call Actionbuilder_fnc_modulePortals;

if (_portals isEqualTo []) exitWith {
	["Actionpoint %1 has no function. Synchronize portals to actionpoints.", _ap] call BIS_fnc_error;
	false
};

// Headless clients must wait for everything to get ready -----------------------------------------
/*
if (!isServer) exitWith {
	if (isNil "RHNET_AB_L_INIT") then {
		RHNET_AB_L_INIT = true;
		if (isNil "Actionbuilder_fnc_remote") exitWith {["Missing remote functionality!"] call BIS_fnc_error; false};
		"RHNET_AB_G_RECEIVER" addPublicVariableEventHandler {
			[(_this select 1), (_this select 2)] spawn Actionbuilder_fnc_remote;
		};
	};
	true
};
*/

// Initialize Actionbuilder -----------------------------------------------------------------------
if (isServer) then {
	if (isNil "RHNET_AB_G_PORTALS") then {
		RHNET_AB_G_PORTALS			= entities "RHNET_ab_modulePORTAL_F";
		RHNET_AB_G_WAYPOINTS		= entities "RHNET_ab_moduleWP_F";
		RHNET_AB_L_WAYPOINTS_DENIED	= [];
		RHNET_AB_G_PORTAL_OBJECTS 	= [];
		RHNET_AB_G_PORTAL_GROUPS 	= [];
		RHNET_AB_G_AP_SIZE			= [];
		RHNET_AB_L_DEBUG			= false;
		RHNET_AB_L_BUFFER 			= 0.02;
		RHNET_AB_L_PERFORMANCE 		= [] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_performance.fsm";
		RHNET_AB_L_INITPORTALS		= [] call Actionbuilder_fnc_initPortals;
		/*
		if (isMultiplayer) then {
			RHNET_AB_G_WORKLOAD 	= [];
			RHNET_AB_L_CLIENTS 		= ["HeadlessClient_F", true, 1] call Actionbuilder_fnc_getEqualTypes;
			RHNET_AB_L_ID 			= 0;
			if (count RHNET_AB_L_CLIENTS > 0) then {
				publicVariable "RHNET_AB_G_PORTALS";
				publicVariable "RHNET_AB_G_WAYPOINTS";
				publicVariable "RHNET_AB_G_PORTAL_OBJECTS";
				publicVariable "RHNET_AB_G_PORTAL_GROUPS";
				publicVariable "RHNET_AB_G_WORKLOAD";
			};
		};
		*/
	};
};

RHNET_AB_G_AP_SIZE pushBack _ap;
RHNET_AB_G_AP_SIZE pushBack ([_portals] call Actionbuilder_fnc_getApSize);

/*
// Decide workload between headless clients -------------------------------------------------------
if (isServer && isMultiplayer) then {
	if (count RHNET_AB_L_CLIENTS > 0) then {
		if (RHNET_AB_L_ID >= (count RHNET_AB_L_CLIENTS)) then {
			RHNET_AB_L_ID = 0
		};
		RHNET_AB_G_WORKLOAD pushBack _ap;
		RHNET_AB_G_WORKLOAD pushBack (RHNET_AB_L_CLIENTS select RHNET_AB_L_ID);
		RHNET_AB_L_ID = RHNET_AB_L_ID + 1;
	};
};
*/

_actionfsm = [_ap, _portals] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";
//waitUntil {completedFSM _actionfsm};

/*
// Register actionpoint and execute the main loop -------------------------------------------------
if (isMultiplayer) then {
	if (isServer && (count RHNET_AB_L_CLIENTS < 1)) then {
		//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";
		//waitUntil {completedFSM _actionfsm};
	} else {
		_worker = RHNET_AB_G_WORKLOAD select ((RHNET_AB_G_WORKLOAD find _ap) + 1);
		if (_worker == format ["%1", player]) then {
			//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";
			//waitUntil {completedFSM _actionfsm};
		};
	};
} else {
	diag_log "ACTIONBUILDER ---------------------------------------------------------------";
	diag_log format ["AP: %1 started", _ap];
	_actionfsm = [_ap, _portals] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_actionpoint.fsm";
	waitUntil {completedFSM _actionfsm};
};
*/
true