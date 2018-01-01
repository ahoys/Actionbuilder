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
		class WaypointDescription: Edit {
			property = "RHNET_ab_moduleAP_F_WaypointDescription";
			description = "Waypoints are orders that the spawned units execute. You can restrict Waypoints with triggers.";
			displayName = "";
			tooltip = "";
			control = "SubCategoryNoHeader1";
			data = "AttributeSystemSubcategory"
		};

		class WpType: Combo {
			property = "RHNET_ab_moduleWP_F_WpType";
			displayName = "Type";
			tooltip = "How the units react to this waypoint. Actions are instantaneous.";
			typeName = "STRING";
			defaultValue = """MOVE""";
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
				class WP_GUARD {
					name = "GUARD";
					value = "GUARD";
				};
				class WP_DISMISSED {
					name = "DISMISSED";
					value = "DISMISS";
				};
				class WP_UTURN {
					name = "ACTION: U-TURN";
					value = "UTURN";
				};
				class WP_SVTBR {
					name = "ACTION: SEND VEHICLES TO BE REMOVED";
					value = "SVA";
				};
				class WP_LOADTRANSPORT {
					name = "ACTION: LOAD TRANSPORT";
					value = "GETIN";
				};
				class WP_UNLOADTRANSPORT {
					name = "ACTION: UNLOAD TRANSPORT";
					value = "UNLOAD";
				};
				class WP_LEAVEVEHICLES {
					name = "ACTION: ABANDON VEHICLES";
					value = "GETOUT";
				};
				class WP_FORCETRANSPORT {
					name = "ACTION: FORCE TRANSPORT";
					value = "FORCE";
				};
				class WP_COMMANDTARGET {
					name = "ACTION: COMMAND TARGET";
					value = "TARGET";
				};
				class WP_COMMANDFIRE {
					name = "ACTION: COMMAND FIRE";
					value = "FIRE";
				};
				class WP_POPULATE_BUILDINGS {
					name = "ACTION: POPULATE BUILDINGS";
					value = "POPULATEBUILDINGS";
				};
				class WP_FORCE_POPULATE_BUILDINGS {
					name = "ACTION: FORCE POPULATE BUILDINGS";
					value = "FORCEPOPULATEBUILDINGS";
				};
				class WP_NEUTRALIZEGROUP {
					name = "ACTION: NEUTRALIZE GROUP";
					value = "NEUTRALIZE";
				};
				class WP_KILLGROUP {
					name = "ACTION: KILL GROUP";
					value = "KILL";
				};
				class WP_REMOVEGROUP {
					name = "ACTION: REMOVE GROUP";
					value = "REMOVE";
				};
			};
		};

		class WpBehaviour: Combo {
			property = "RHNET_ab_moduleWP_F_WpBehaviour";
			displayName = "Behaviour";
			tooltip = "How the units behave during this waypoint.";
			typeName = "STRING";
			defaultValue = """UNCHANGED""";
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
			defaultValue = """UNCHANGED""";
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
			defaultValue = """NO CHANGE""";
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
			defaultValue = """NO CHANGE""";
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
			defaultValue = "0";
			control = "EditShort";
		};

		class WpPlacement: Combo {
			property = "RHNET_ab_moduleWP_F_WpPlacement";
			displayName = "Placement";
			tooltip = "Location of the actual waypoint.";
			typeName = "NUMBER";
			defaultValue = "0";
			class Values {
				class WP_EDITORPLACEMENT {
					name = "Module position";
					value = 0;
					default = 1;
				};
				class WP_CLOSESTPLAYER {
					name = "Closest player position";
					value = 1;
				};
			};
		};

		class WpSpecial: Combo {
			property = "RHNET_ab_moduleWP_F_WpSpecial";
			displayName = "Special";
			tooltip = "Special attributes available.";
			typeName = "NUMBER";
			defaultValue = "0";
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
					name = "High priority (primary choice)";
					value = 2;
				};
				class WP_LOWPRIORITY {
					name = "Low priority (avoided)";
					value = 3;
				};
				class WP_ALLOWPOSTSWITCHING {
					name = "Disable post switching";
					value = 4;
				};
			};
		};
	};
};
