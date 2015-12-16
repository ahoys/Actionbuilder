/*
	File: fn_selectRandom.sqf
	Author: Ari Höysniemi

	Description:
	Assigns a new waypoint to a group

	Parameter(s):
	0: ARRAY - possibilities
	1: NUMBER - how many to select
	2: BOOL - true to pick only unique selections

	Returns:
	ARRAY - a list of selections
*/

private["_array","_count","_unique","_return","_countArray","_i"];

_array 		= param [0, [], [[]]];
_count 		= param [1, 1, [1]];
_unique		= param [2, false, [false]];
_return		= [];
_countArray	= count _array;

if (_countArray < 1) exitWith {[]};
if (_count < 1) exitWith {[]};
if ((_count > _countArray) && _unique) exitWith {_array};

while (_count > 0) do {
	_count = _count - 1;
	if (_unique) then {
		_i = floor random count _array;
		_return pushBack (_array select _i);
		_array deleteAt _i;
	} else {
		_return pushBack (_array select floor random _countArray);
	};
};

_return