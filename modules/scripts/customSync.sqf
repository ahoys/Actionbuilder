private [
	"_portal",
	"_arrayInitial",
	"_arrayInf",
	"_arrayVeh",
	"_arrayEVeh",
	"_arrayAll",
	"_portalSide",
	"_arrayBuild",
	"_group",
	"_leader",
	"_veh"
];

// INITIAL INPUT ------------------------------------------------------------------------------------------
_portal = _this select 0;

// ONLY PORTAL MODULES ALLOWED ----------------------------------------------------------------------------
if (typeOf _portal != "RHNET_ab_modulePORTAL_F") exitWith {
	diag_log format ["Actionbuilder: portal (%1) is not supported, in mission (%2)", _portal, missionName];
	false
};

// RHNET_AB_UNITS MUST BE INITIALIZED ---------------------------------------------------------------------
waitUntil { !isNil "RHNET_ab_units" };

// INITIALIZE REQUIRED ARRAYS -----------------------------------------------------------------------------
_arrayInitial	= _portal call BIS_fnc_moduleUnits;						// Synchronized units
_arrayInf		= [];													// Infantry units
_arrayVeh		= [];													// All manned vehicles
_arrayEVeh		= [];													// All empty vehicles or objects
_arrayAll		= [];													// All selected units
_arrayBuild		= [];													// Output

// AT LEAST ONE UNIT MUST BE SYNCED -----------------------------------------------------------------------
if ((count _arrayInitial) <= 0) exitWith {
	diag_log format ["Actionbuilder: portal (%1) has no synchronized units, in mission (%2)", _portal, missionName];
	false
};

// SELECT UNITS FOR THE PORTAL ----------------------------------------------------------------------------
{
	
	// SIDE
	if (isNil "_portalSide") then {
		_portalSide = side _x;											// Select side for the group
		if ((_portalSide != WEST) && (_portalSide != EAST) && (_portalSide != RESISTANCE) && (_portalSide != CIVILIAN)) then {
			_portalSide = CIVILIAN;										// Side must be at least civilian
		};
	};
	
	// NEW GROUP
	_group = group _x;													// Select portal's group
	if (!(isNull _group) && !(_group in _arrayAll)) then {
		_arrayAll set [(count _arrayAll), _group];						// Loop every group only once

		// NEW UNIT
		{
				_veh = vehicle _x;										// Unit's vehicle

				// MAN
				if (!(_x in _arrayAll) && (_x isKindOf "MAN") && (_x == _veh)) then {
					if (isNil "_leader") then {
						_leader = leader _x;							// Select group leader
						_arrayInf set [0,(typeOf _leader)];				// Append infantry list with a leader
					};
					if (_x != _leader) then {
						_arrayInf set [(count _arrayInf),(typeOf _x)];	// Append infantry list with a soldier
					};
					deleteVehicle _x;
				};
				
				// MANNED VEHICLE
				if ((_veh isKindOf "LandVehicle") || (_veh isKindOf "Air") || (_veh isKindOf "Ship")) then {
					_arrayVeh set [(count _arrayVeh), (typeOf _veh)];	// Append manned vehicles list
					{
						_arrayAll set [(count _arrayAll), _x];
						deleteVehicle _x;
					} forEach crew _veh;
					deleteVehicle _veh;
				};

		} forEach units _group;											// Cycle all group members of the synced units
		
	};
	
	// EMPTY VEHICLE OR OBJECT
	if ((isNull _group) && !(_x in _arrayAll) && !(_x isKindOf "Man")) then {
		_arrayAll set [(count _arrayAll), _x];							// Mark this unit as checked
		_arrayEVeh set [(count _arrayEVeh), (typeOf (vehicle _x))];		// Append empty vehicles list
		deleteVehicle _x;
	};
	
} forEach _arrayInitial;												// Cycle all units synced to the portal

// BUILD A FINALIZED LIST OF THE SELECTED UNITS -----------------------------------------------------------
if ((isNil "_portal") || (isNil "_portalSide") || (isNil "_arrayInf") || (isNil "_arrayVeh") || (isNil "_arrayEVeh")) exitWith {diag_log "Actionbuilder: customSync failed to finalize its task."; false};
_arrayBuild set [0,_portal];											// Portal
_arrayBuild set [1,_portalSide];										// Side of the portal
_arrayBuild set [2,_arrayInf];											// Infantry units
_arrayBuild set [3,_arrayVeh];											// Manned vehicles
_arrayBuild set [4,_arrayEVeh];											// Empty vehicles and objects

RHNET_ab_units set [(count RHNET_ab_units),_arrayBuild];				// Append the main unit list with our new array
publicVariable "RHNET_ab_units";

true