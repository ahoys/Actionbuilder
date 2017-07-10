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

	class Attributes: AttributesBase {
		class Units: Units {
			property = "RHNET_ab_modulePORTAL_F_Units";
		};

		class p_Positioning: Combo {
			property = "RHNET_ab_modulePORTAL_F_p_Positioning";
			displayName = "Positioning";
			tooltip = "The units can spawn to their editor placed positions or the position of the portal module.";
			typeName = "STRING";
			class Values {
				class PORTAL_ORIGINALPOSITION {
					name = "Original unit position";
					value = "NONE";
					default = 1;
				};
				class PORTAL_PORTALPOSITION {
					name = "Portal position";
					value = "PORTAL";
				};
			};
		};

		class p_MinDist: Edit {
			property = "RHNET_ab_modulePORTAL_F_p_MinDist";
			displayName = "No players radius";
			tooltip = "Area radius in meters where there can be no players present for this portal to work (0 - infinite).";
			typeName = "NUMBER";
			defaultValue = 400;
		};

		class p_Damage: Default {
			property = "RHNET_ab_modulePORTAL_F_p_Damage";
			displayName = "Damage";
			tooltip = "How damaged the spawned units are.";
			validate = NUMBER;
			defaultValue = 0;
			control = "Slider";
		};

		class p_Skill: Default {
			property = "RHNET_ab_modulePORTAL_F_p_Skill";
			displayName = "Skill";
			tooltip = "How skilled the spawned units are.";
			validate = NUMBER;
			defaultValue = 0.5;
			control = "Slider";
		};

		class p_Ammo: Default {
			property = "RHNET_ab_modulePORTAL_F_p_Ammo";
			displayName = "Ammunition";
			tooltip = "How much ammunition do the spawned units have.";
			validate = NUMBER;
			defaultValue = 1;
			control = "Slider";
		};

		class p_Fuel: Default {
			property = "RHNET_ab_modulePORTAL_F_p_Fuel";
			displayName = "Fuel";
			tooltip = "How much fuel do the spawned vehicles have.";
			validate = NUMBER;
			defaultValue = 1;
			control = "Slider";
		};

		class p_Special: Combo {
			property = "RHNET_ab_modulePORTAL_F_p_Special";
			displayName = "Special";
			tooltip = "A special attribute of the spawned units.";
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

		class ModuleDescription: ModuleDescription{};
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