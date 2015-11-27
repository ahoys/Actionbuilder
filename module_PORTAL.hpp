class RHNET_ab_modulePORTAL_F : Module_F
{
	author = "Raunhofer";
	_generalMacro = "RHNET_ab_modulePORTAL_F";
	scope = public;
	displayName = "Portal";
	category = "RHNET_Actionbuilder";
	icon = "\RHNET\rhnet_actionbuilder\data\iconPORTAL_ca.paa";
	function = "Actionbuilder_fnc_modulePortal";
	isGlobal = 0;
	isTriggerActivated = 0;
	functionPriority = 1;

	class Arguments {
		class p_MinDist {
			displayName = "Safezone";
			description = "Stop spawning, if there are playable units too close the portal";
			typeName = "NUMBER";
			class Values {
				class p_sz0 {
					name = "Disabled";
					value = 0;
				};
				class p_sz1 {
					name = "25m";
					value = 25;
				};
				class p_sz2 {
					name = "50m";
					value = 50;
				};
				class p_sz3 {
					name = "100m";
					value = 100;
				};
				class p_sz4 {
					name = "200m";
					value = 200;
				};
				class p_sz5 {
					name = "300m";
					value = 300;
				};
				class p_sz6 {
					name = "400m";
					value = 400;
					default = 1;
				};
				class p_sz7 {
					name = "500m";
					value = 500;
				};
				class p_sz8 {
					name = "600m";
					value = 600;
				};
				class p_sz9 {
					name = "700m";
					value = 700;
				};
				class p_sz10 {
					name = "800m";
					value = 800;
				};
				class p_sz11 {
					name = "900m";
					value = 900;
				};
				class p_sz12 {
					name = "1000m";
					value = 1000;
				};
				class p_sz13 {
					name = "2000m";
					value = 2000;
				};
				class p_sz14 {
					name = "3000m";
					value = 3000;
				};
				class p_sz15 {
					name = "4000m";
					value = 4000;
				};
				class p_sz16 {
					name = "5000m";
					value = 5000;
				};
				class p_sz17 {
					name = "8000m";
					value = 8000;
				};
				class p_sz18 {
					name = "10000m";
					value = 10000;
				};
			};
		};
		
		class p_Special {
			displayName = "Special";
			description = "What special properties does the unit have";
			typeName = "STRING";
			class Values {
				class v_special0 {
					name = "None";
					value = "NONE";
					default = 1;
				};
				class v_special1 {
					name = "Flying";
					value = "FLY";
				};
			};
		};

		class p_UnitInit {
			displayName = "Initialize Units";
			description = "Special commands and scripts for unit initialization (optional)";
			typeName = "STRING";
			defaultValue = "";
		};
	};

	class ModuleDescription : ModuleDescription {
		description = "Action Portal acts as a spawning point.";
		sync[] = {"RHNET_ab_moduleAP_F","RHNET_ab_moduleWP_F"};

		position = 1;
		direction = 1;
		duplicate = 1;

		class RHNET_ab_moduleWP_F {
			description = "If synced to multiple Action Waypoints, one will be randomly selected.";
			position = 1;
			duplicate = 1;
		};
	};
};