class RHNET_ab_moduleWP_F : Module_F
{
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_moduleWP_F";
	scope = public;
	displayName = "Waypoint";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconWP_ca.paa";
	//function = "RHNET_ab_modules_fnc_moduleWaypoint";
	function = "Actionbuilder_fnc_moduleWaypoint";
	isGlobal = 0;
	isTriggerActivated = 0;
	functionPriority = 3;

	class Arguments {
		class WpType {
			displayName = "Type";
			description = "What kind of waypoint is this";
			typeName = "STRING";
			class Values {
				class wp_typeMOVE {
					name = "MOVE";
					value = "MOVE";
					default = 1;
				};
				class wp_typeSAD {
					name = "SEEK AND DESTROY";
					value = "SAD";
				};
				class wp_typeUTURN {
					name = "U-TURN";
					value = "UTURN";
				};
				class wp_typeGUARD {
					name = "GUARD";
					value = "GUARD";
				};
				class wp_typeDISMISSED {
					name = "DISMISSED";
					value = "DISMISS";
				};
				class wp_typeLT {
					name = "LOAD TRANSPORT";
					value = "GETIN";
				};
				class wp_typeUT {
					name = "UNLOAD TRANSPORT";
					value = "UNLOAD";
				};
				class wp_typeFT {
					name = "FORCE TRANSPORT";
					value = "FORCE";
				};
				class wp_typeSVA {
					name = "SEND VEHICLES TO BE REMOVED";
					value = "SVA";
				};
				class wp_typeCT {
					name = "COMMAND TARGET";
					value = "TARGET";
				};
				class wp_typeCF {
					name = "COMMAND FIRE";
					value = "FIRE";
				};
				class wp_typeNG {
					name = "NEUTRALIZE GROUP";
					value = "NEUTRALIZE";
				};
				class wp_typeKG {
					name = "KILL GROUP";
					value = "KILL";
				};
				class wp_typeRG {
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
				class wp_beh0 {
					name = "UNCHANGED";
					value = "UNCHANGED";
					default = 1;
				};
				class wp_beh1 {
					name = "CARELESS";
					value = "CARELESS";
				};
				class wp_beh2 {
					name = "SAFE";
					value = "SAFE";
				};
				class wp_beh3 {
					name = "AWARE";
					value = "AWARE";
				};
				class wp_beh4 {
					name = "COMBAT";
					value = "COMBAT";
				};
				class wp_beh5 {
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
				class wp_speed0 {
					name = "UNCHANGED";
					value = "UNCHANGED";
					default = 1;
				};
				class wp_speed1 {
					name = "LIMITED";
					value = "LIMITED";
				};
				class wp_speed2 {
					name = "NORMAL";
					value = "NORMAL";
				};
				class wp_speed3 {
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
				class wp_form0 {
					name = "NO CHANGE";
					value = "NO CHANGE";
					default = 1;
				};
				class wp_form1 {
					name = "COLUMN";
					value = "COLUMN";
				};
				class wp_form2 {
					name = "WEDGE";
					value = "WEDGE";
				};
				class wp_form3 {
					name = "LINE";
					value = "LINE";
				};
			};
		};

		class WpMode {
			displayName = "Combat Mode";
			description = "Combat behaviour of AI units on this waypoint";
			class Values {
				class wp_mode0 {
					name = "NO CHANGE";
					value = "NO CHANGE";
					default = 1;
				};
				class wp_mode1 {
					name = "NEVER FIRE";
					value = "BLUE";
				};
				class wp_mode2 {
					name = "HOLD FIRE, defend only";
					value = "GREEN";
				};
				class wp_mode3 {
					name = "HOLD FIRE, engage at will";
					value = "WHITE";
				};
				class wp_mode4 {
					name = "FIRE AT WILL";
					value = "YELLOW";
				};
				class wp_mode5 {
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
				class wp_place0 {
					name = "Editor placement";
					value = 0;
					default = 1;
				};
				class wp_place1 {
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
				class wp_spec0 {
					name = "None";
					value = 0;
					default = 1;
				};
				class wp_spec1 {
					name = "Cannot be reused";
					value = 1;
				};
				class wp_spec2 {
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