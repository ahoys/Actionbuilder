/*
	File: fn_cleanPortals.sqf
	Author: Ari Höysniemi
	
	Note:
	This is an actionbuilder component, outside calls are not supported

	Description:
	Remove units synced to portals, when everything is ready

	Parameter(s):
	NOTHING

	Returns:
	NOTHING
*/

private["_portals","_found","_search"];

_portals 	= ["RHNET_ab_modulePORTAL_F"] call Actionbuilder_fnc_getTypes;
_found 		= [];
_search 	= true;

while (_search) do {
	{
		if (_x in ACTIONBUILDER_locations) then {
			_found pushBack _x;
		};
	} forEach _portals;
	if (_portals == _found) then {
		{
			[_x, false] spawn Actionbuilder_fnc_deleteSyncedUnits;
		} forEach _portals;
		_search = false;
	};
	sleep .01;
	diag_log "search";
};

true