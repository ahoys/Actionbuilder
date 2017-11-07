class RHNET_ab_moduleWP_F: Module_F {
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_moduleWP_F";
	scope = public;
	displayName = "Waypoint";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconWP_ca.paa";
	function = "Actionbuilder_fnc_moduleWaypoint";
	isGlobal = 0;
	isTriggerActivated = 0;
	functionPriority = 3;
	isDisposable = 0;

	class Attributes: AttributesBase {
		class WpType: Combo {
			property = "RHNET_ab_moduleWP_F_WpType";
			displayName = "Type";
			tooltip = "How the units react to this waypoint.";
			typeName = "STRING";
			class Values {
				class WP_MOVE {
					name = "MOVE";
					value = "MOVE";
					default = 1;
				};
				class WP_SAD {
					name = "SEEK AND DESTROY";
					value = "SAD";
				};
				class WP_UTURN {
					name = "U-TURN";
					value = "UTURN";
				};
				class WP_GUARD {
					name = "GUARD";
					value = "GUARD";
				};
				class WP_DISMISSED {
					name = "DISMISSED";
					value = "DISMISS";
				};
				class WP_LOADTRANSPORT {
					name = "LOAD TRANSPORT (instant)";
					value = "GETIN";
				};
				class WP_UNLOADTRANSPORT {
					name = "UNLOAD TRANSPORT (instant)";
					value = "UNLOAD";
				};
				class WP_LEAVEVEHICLES {
					name = "ABANDON VEHICLES (instant)";
					value = "GETOUT";
				};
				class WP_FORCETRANSPORT {
					name = "FORCE TRANSPORT (instant)";
					value = "FORCE";
				};
				class WP_SVTBR {
					name = "SEND VEHICLES TO BE REMOVED (instant)";
					value = "SVA";
				};
				class WP_COMMANDTARGET {
					name = "COMMAND TARGET (instant)";
					value = "TARGET";
				};
				class WP_COMMANDFIRE {
					name = "COMMAND FIRE (instant)";
					value = "FIRE";
				};
				class WP_NEUTRALIZEGROUP {
					name = "NEUTRALIZE GROUP (instant)";
					value = "NEUTRALIZE";
				};
				class WP_KILLGROUP {
					name = "KILL GROUP (instant)";
					value = "KILL";
				};
				class WP_REMOVEGROUP {
					name = "REMOVE GROUP (instant)";
					value = "REMOVE";
				};
			};
		};

		class WpBehaviour: Combo {
			property = "RHNET_ab_moduleWP_F_WpBehaviour";
			displayName = "Behaviour";
			tooltip = "How the units behave during this waypoint.";
			typeName = "STRING";
			class Values {
				class WP_UNCHANGED {
					name = "UNCHANGED";
					value = "UNCHANGED";
					default = 1;
				};
				class WP_CARELESS {
					name = "CARELESS";
					value = "CARELESS";
				};
				class WP_SAFE {
					name = "SAFE";
					value = "SAFE";
				};
				class WP_AWARE {
					name = "AWARE";
					value = "AWARE";
				};
				class WP_COMBAT {
					name = "COMBAT";
					value = "COMBAT";
				};
				class WP_STEALTH {
					name = "STEALTH";
					value = "STEALTH";
				};
			};
		};

		class WpSpeed: Combo {
			property = "RHNET_ab_moduleWP_F_WpSpeed";
			displayName = "Speed";
			tooltip = "How fast the units move during this waypoint.";
			typeName = "STRING";
			class Values {
				class WP_UNCHANGED {
					name = "UNCHANGED";
					value = "UNCHANGED";
					default = 1;
				};
				class WP_LIMITED {
					name = "LIMITED";
					value = "LIMITED";
				};
				class WP_NORMAL {
					name = "NORMAL";
					value = "NORMAL";
				};
				class WP_FULL {
					name = "FULL";
					value = "FULL";
				};
			};
		};

		class WpFormation: Combo {
			property = "RHNET_ab_moduleWP_F_WpFormation";
			displayName = "Formation";
			tooltip = "What formation is used in groups during this waypoint.";
			typeName = "STRING";
			class Values {
				class WP_NOCHANGE {
					name = "NO CHANGE";
					value = "NO CHANGE";
					default = 1;
				};
				class WP_COLUMN {
					name = "COLUMN";
					value = "COLUMN";
				};
				class WP_WEDGE {
					name = "WEDGE";
					value = "WEDGE";
				};
				class WP_LINE {
					name = "LINE";
					value = "LINE";
				};
			};
		};

		class WpMode: Combo {
			property = "RHNET_ab_moduleWP_F_WpMode";
			displayName = "Combat Mode";
			tooltip = "Combat behaviour of the units during this waypoint.";
			typeName = "STRING";
			class Values {
				class WP_NOCHANGE {
					name = "NO CHANGE";
					value = "NO CHANGE";
					default = 1;
				};
				class WP_BLUE {
					name = "NEVER FIRE";
					value = "BLUE";
				};
				class WP_GREEN {
					name = "HOLD FIRE, defend only";
					value = "GREEN";
				};
				class WP_WHITE {
					name = "HOLD FIRE, engage at will";
					value = "WHITE";
				};
				class WP_YELLOW {
					name = "FIRE AT WILL";
					value = "YELLOW";
				};
				class WP_RED {
					name = "FIRE AT WILL, engage at will";
					value = "RED";
				};
			};
		};

		class WpWait: Edit {
			property = "RHNET_ab_moduleWP_F_WpWait";
			displayName = "Wait";
			tooltip = "For how many seconds does it take for this waypoint to activate.";
			typeName = "NUMBER";
			defaultValue = 0;
			control = "EditShort";
		};

		class WpPlacement: Combo {
			property = "RHNET_ab_moduleWP_F_WpPlacement";
			displayName = "Placement";
			tooltip = "Location of the actual waypoint.";
			typeName = "NUMBER";
			class Values {
				class WP_EDITORPLACEMENT {
					name = "Editor placement";
					value = 0;
					default = 1;
				};
				class WP_CLOSESTPLAYER {
					name = "Closest player";
					value = 1;
				};
			};
		};

		class WpSpecial: Combo {
			property = "RHNET_ab_moduleWP_F_WpSpecial";
			displayName = "Special";
			tooltip = "Special attributes available.";
			typeName = "NUMBER";
			class Values {
				class WP_NONE {
					name = "None";
					value = 0;
					default = 1;
				};
				class WP_CANNOTREUSE {
					name = "Cannot be reused by the group";
					value = 1;
				};
				class WP_HIGHPRIORITY {
					name = "High priority";
					value = 2;
				};
			};
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription {
		description = "Waypoints order the spawned units to execute actions.";
		sync[] = {"RHNET_ab_modulePORTAL_F"};

		position = 1;
		duplicate = 1;

		class RHNET_ab_modulePORTAL_F {
			description = "A portal controls the unit spawning.";
			position = 1;
			direction = 1;
			duplicate = 1;
		};
	};
};