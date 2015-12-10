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

private ["_ap","_modules","_portals","_worker"];
_ap = _this select 0;

// Headless clients must wait for everything to get ready -----------------------------------------
if (!isServer) then {
	waitUntil {
		!isNil "RHNET_AB_G_PORTALS" &&
		!isNil "RHNET_AB_G_WAYPOINTS" &&
		!isNil "RHNET_AB_G_PORTAL_OBJECTS" && 
		!isNil "RHNET_AB_G_PORTAL_GROUPS" && 
		!isNil "RHNET_AB_G_WORKLOAD"
	};
};

// Required functions -----------------------------------------------------------------------------
if (isNil "RHNET_AB_L_FUNCTIONVALIDITY") then {
	if !([] call Actionbuilder_fnc_verifyFunctions) exitWith {false};
};

// Initialize the Actionbuilder module ------------------------------------------------------------
if (isServer) then {
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
	if (isNil "RHNET_AB_G_PORTALS") then {
		RHNET_AB_G_PORTALS			= ["RHNET_ab_modulePORTAL_F"] call Actionbuilder_fnc_getTypes;
		RHNET_AB_G_WAYPOINTS		= ["RHNET_ab_moduleWP_F"] call Actionbuilder_fnc_getTypes;
		RHNET_AB_L_WAYPOINTS_DENIED	= [];
		RHNET_AB_G_PORTAL_OBJECTS 	= [];
		RHNET_AB_G_PORTAL_GROUPS 	= [];
		RHNET_AB_L_BUFFER 			= 0.1;
		RHNET_AB_L_PERFORMANCE 		= [] execFSM "RHNET\rhnet_actionbuilder\modules\actionpoint\rhfsm_performance.fsm";
		RHNET_AB_L_INITPORTALS		= [] call Actionbuilder_fnc_initPortals;
		if (isMultiplayer) then {
			RHNET_AB_G_WORKLOAD 	= [];
			RHNET_AB_L_CLIENTS 		= ["HeadlessClient_F", true, 1] call Actionbuilder_fnc_getTypes;
			RHNET_AB_L_ID 			= 0;
			if (count RHNET_AB_L_CLIENTS > 0) then {
				publicVariable "RHNET_AB_G_PORTALS";
				publicVariable "RHNET_AB_G_WAYPOINTS";
				publicVariable "RHNET_AB_G_PORTAL_OBJECTS";
				publicVariable "RHNET_AB_G_PORTAL_GROUPS";
				publicVariable "RHNET_AB_G_WORKLOAD";
			};
		};
	};
};

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

// Register actionpoint and execute the main loop -------------------------------------------------
if (isMultiplayer) then {
	if (isServer && (count RHNET_AB_L_CLIENTS < 1)) then {
		//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\actionpoint\rhfsm_actionpoint.fsm";
		//waitUntil {completedFSM _actionfsm};
	} else {
		_worker = RHNET_AB_G_WORKLOAD select ((RHNET_AB_G_WORKLOAD find _ap) + 1);
		if (_worker == format ["%1", player]) then {
			//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\actionpoint\rhfsm_actionpoint.fsm";
			//waitUntil {completedFSM _actionfsm};
		};
	};
} else {
	//_actionfsm = [_ap] execFSM "RHNET\rhnet_actionbuilder\actionpoint\rhfsm_actionpoint.fsm";
	//waitUntil {completedFSM _actionfsm};
};

true