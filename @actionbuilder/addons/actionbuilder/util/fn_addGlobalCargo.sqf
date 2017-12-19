/*
	File: fn_addGlobalCargo.sqf
	Author: Ari Höysniemi

	Description:
	Adds given cargo to a target vehicle.

	Parameter(s):
	0: OBJECT - target vehicle.
	1: ARRAY - cargo with the following syntax:
		[
			[[items], [counts]],
			[[weapons], [counts]],
			[[mags], [counts]],
			[[backpacks], [counts]]
		]
	
	See e.g. getItemCargo for the 1st index.

	Returns:
	NOTHING
*/
private _target = param [0, objNull, [objNull]];
private _cargo = param [1, [], []];

private _type = 0;
{
	private _i = 0;
	private _c = (_x select 1);
	{
		if (_type < 3) then {
			_target addItemCargoGlobal [_x, _c select _i];
		} else {
			_target addBackpackCargoGlobal [_x, _c select _i];
		};
		_i = _i + 1;
	} forEach (_x select 0);
	_type = _type + 1;
} forEach _cargo;

true
