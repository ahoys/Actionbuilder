private _result = [];
{
	if (_x isKindOf (_this select 1)) then {
		_result pushBack _x;
	};
} forEach synchronizedObjects (_this select 0);

_result