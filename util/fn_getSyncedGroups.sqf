/*
	File: fn_getSyncedGroups.sqf
	Author: Ari Höysniemi

	Description:
	Return an array of synchronized groups

	Parameter(s):
	0: OBJECT - object with units synchronized
	1 (Optional): BOOL - true to remove object after the registeration (default: false)

	Returns:
	ARRAY - List of groups [side,[infantry],[vehicles],side2, ... sideN,[units],[vehicles]]
*/

private["_master","_syncedUnits","_groups","_used","_crew","_i","_grp","_side","_veh"];
_master = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_remove = [_this, 1, false, [false]] call BIS_fnc_param;

// Master can't be empty
if (isNil "_master") exitWith {
	["The master object is null. The master object should be an actual object."] call BIS_fnc_error;
	[]
};

// All synchronized units
_syncedUnits 	= _master call BIS_fnc_moduleUnits;
_groups			= [];
_used			= [];
_crew			= [];
_i				= 0;

// Collect all groups and return
{
	if (!isNil "_x") then {
		_grp = group _x;
		if !(isNull _grp) then {
			_side = side _grp;
			if !(_grp in _used) then {
				if ((_side == WEST) || (_side == EAST) || (_side == RESISTANCE) || (_side == CIVILIAN)) then {
					_used pushBack _grp;
					_groups pushBack _side;
					_groups pushBack [];
					_groups pushBack [];
					{
						_veh = vehicle _x;
						if (_x == _veh) then {
							(_groups select (_i+1)) pushBack [typeOf _x, getPosATL _x, getDir _x];
							if (_remove) then {
								deleteVehicle _x;
							};
						} else {
							if !(_x in _crew) then {
								(_groups select (_i+2)) pushBack [typeOf _veh, getPosATL _veh, getDir _veh];
								_crew pushBack (crew _veh);
								if (_remove) then {
									{
										deleteVehicle _x;
									} forEach (crew _veh);
									deleteVehicle _veh;
								};
							};
						};
					} forEach units _grp;
					_i = _i + 3;
				};
			};
		};
	};
} forEach _syncedUnits;

_groups