class RHNET_ab_modulePORTAL_F: Module_F {
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
	isDisposable = 0;

	class Arguments {
		class p_Positioning {
			displayName = "Unit Positioning";
			description = "To what location will the units spawn to.";
			typeName = "STRING";
			class Values {
				class PORTAL_ORIGINALPOSITION {
					name = "Original";
					value = "NONE";
					default = 1;
				};
				class PORTAL_PORTALPOSITION {
					name = "Portal";
					value = "PORTAL";
				};
			};
		};
		
		class p_MinDist {
			displayName = "Safe Zone";
			description = "Spawning will not be allowed if there are playable units too close to the portal.";
			typeName = "NUMBER";
			class Values {
				class PORTAL_SAFE0 {
					name = "Disabled";
					value = 0;
				};
				class PORTAL_SAFE25 {
					name = "25m";
					value = 25;
				};
				class PORTAL_SAFE50 {
					name = "50m";
					value = 50;
				};
				class PORTAL_SAFE100 {
					name = "100m";
					value = 100;
				};
				class PORTAL_SAFE200 {
					name = "200m";
					value = 200;
				};
				class PORTAL_SAFE300 {
					name = "300m";
					value = 300;
				};
				class PORTAL_SAFE400 {
					name = "400m";
					value = 400;
					default = 1;
				};
				class PORTAL_SAFE500 {
					name = "500m";
					value = 500;
				};
				class PORTAL_SAFE600 {
					name = "600m";
					value = 600;
				};
				class PORTAL_SAFE700 {
					name = "700m";
					value = 700;
				};
				class PORTAL_SAFE800 {
					name = "800m";
					value = 800;
				};
				class PORTAL_SAFE900 {
					name = "900m";
					value = 900;
				};
				class PORTAL_SAFE1000 {
					name = "1000m";
					value = 1000;
				};
				class PORTAL_SAFE2000 {
					name = "2000m";
					value = 2000;
				};
				class PORTAL_SAFE3000 {
					name = "3000m";
					value = 3000;
				};
				class PORTAL_SAFE4000 {
					name = "4000m";
					value = 4000;
				};
				class PORTAL_SAFE5000 {
					name = "5000m";
					value = 5000;
				};
				class PORTAL_SAFE8000 {
					name = "8000m";
					value = 8000;
				};
				class PORTAL_SAFE10000 {
					name = "10000m";
					value = 10000;
				};
			};
		};
		
		class p_Special {
			displayName = "Special";
			description = "What special attributes do the spawned units follow.";
			typeName = "STRING";
			class Values {
				class NONE {
					name = "None";
					value = "NONE";
					default = 1;
				};
				class FLY {
					name = "Spawn flying";
					value = "FLY";
				};
				class CAN_COLLIDE {
					name = "Spawn to exact positions";
					value = "CAN_COLLIDE";
				};
				class CARGO {
					name = "Spawn to vehicle cargo";
					value = "CARGO";
				}
			};
		};
	};

	class ModuleDescription : ModuleDescription {
		description = "A portal controls the unit spawning.";
		sync[] = {"RHNET_ab_moduleAP_F","RHNET_ab_moduleWP_F"};

		position = 1;
		direction = 1;
		duplicate = 1;

		class RHNET_ab_moduleWP_F {
			description = "If there are multiple waypoints available only one will be randomly selected.";
			position = 1;
			duplicate = 1;
		};
	};
};