class RHNET_ab_moduleWP_F : Module_F
{
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

	class Arguments {
		class WpType {
			displayName = "Type";
			description = "What kind of waypoint is this";
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
				};/*
				class WP_LOADTRANSPORT {
					name = "LOAD TRANSPORT";
					value = "GETIN";
				};
				class WP_UNLOADTRANSPORT {
					name = "UNLOAD TRANSPORT";
					value = "UNLOAD";
				};
				class WP_LEAVEVEHICLES {
					name = "ABANDON VEHICLES";
					value = "GETOUT";
				};
				class WP_FORCETRANSPORT {
					name = "FORCE TRANSPORT";
					value = "FORCE";
				};*/
				class WP_SVTBR {
					name = "SEND VEHICLES TO BE REMOVED";
					value = "SVA";
				};
				class WP_COMMANDTARGET {
					name = "COMMAND TARGET";
					value = "TARGET";
				};
				class WP_COMMANDFIRE {
					name = "COMMAND FIRE";
					value = "FIRE";
				};
				class WP_NEUTRALIZEGROUP {
					name = "NEUTRALIZE GROUP";
					value = "NEUTRALIZE";
				};
				class WP_KILLGROUP {
					name = "KILL GROUP";
					value = "KILL";
				};
				class WP_REMOVEGROUP {
					name = "REMOVE GROUP";
					value = "REMOVE";
				};
			};
		};

		class WpBehaviour {
			displayName = "Behaviour";
			description = "Behaviour of AI units on this waypoint";
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

		class WpSpeed {
			displayName = "Speed";
			description = "Speed of AI units on this waypoint";
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

		class WpFormation {
			displayName = "Formation";
			description = "Formation of AI units on this waypoint";
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

		class WpMode {
			displayName = "Combat Mode";
			description = "Combat behaviour of AI units on this waypoint";
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

		class WpWait {
			displayName = "Wait";
			description = "For how many seconds do the units wait before this waypoint activates";
			typeName = "SCALAR";
			defaultValue = 0;
		};

		class WpPlacement {
			displayName = "Placement";
			description = "Location placement of this waypoint";
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
		
		class WpSpecial {
			displayName = "Special";
			description = "Special attributes";
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
	};

	class ModuleDescription : ModuleDescription {
		description = "Use Action Waypoints to get spawned units moving.";
		sync[] = {"RHNET_ab_modulePORTAL_F"};

		position = 1;
		duplicate = 1;

		class RHNET_ab_modulePORTAL_F {
			description = "Action Portal acts as a spawning point for infantry.";
			position = 1;
			direction = 1;
			duplicate = 1;
		};
	};
};