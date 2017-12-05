/*
	File: fn_selectRandomPortal.sqf
	Author: Ari Höysniemi

	Description:
	Selects a random portal from a list.

	Parameter(s):
	0: ARRAY - possibilities
	1: NUMBER - how many to select

	Returns:
	ARRAY - a list of selections
*/
private _list = param [0, [], [[]]];
private _pick = param [1, 1, [1]];
private _selecectable = [];
private _selected = [];

// Look for portals that can be selected.
// Portals that do not have players near them.
{
	private _listItem = _x;
	if (_x isKindOf "RHNET_ab_modulePORTAL_F") then {
		private _varSafeZone = _x getVariable ["p_MinDist", 400];
		private _select = true;
		{
			scopeName "selectRandomPortal0";
			if (_x distance _listItem < _varSafeZone) then {
				_select = false;
				breakOut "selectRandomPortal0";
			};
		} forEach playableUnits + switchableUnits;
		if (_select) then {
			_selecectable pushBack _listItem;
		};
	};
} forEach _list;

// Select random from the available portals.
private _c = 0;
while {_c < _pick} do {
	_c = _c + 1;
	if !(_selecectable isEqualTo []) then {
		private _i = floor random count _selecectable;
		_selected pushBack (_selecectable select _i);
		_selecectable deleteAt _i;
	};
};

_selected
