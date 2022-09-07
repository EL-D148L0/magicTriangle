/* this is a sample of a lamp */
#include "basicdefines_A3.hpp"
class CfgPatches
{
	class MagicTriangleMod
	{
		units[] = {"Thingy"};
		weapons[] = {};
		requiredAddons[] = {};
		requiredVersion = 0.1;
	};
};


class CfgFunctions
{
	class ELD
	{
		class TrenchScripts
		{
			file = "magicTriangle\scripts";
			class initGlobals {
				preInit = 1;
			};
			class getConfigInfo {};
		};
	};
};


class CfgVehicles
{
	class Rocks_base_F;

	class Triangle: Rocks_base_F
	{
		scope				= public;										/// makes the lamp invisible in editor
		scopeCurator		= public;											/// makes the lamp visible in Zeus
		displayName			= "Magic Triangle";									/// displayed in Editor
		model				= \magicTriangle\Triangl.p3d;	/// simple path to model
		hiddenSelections[] = {"camo"}; /// what selection in model could have different textures
		hiddenSelectionsTextures[] = {"\a3\missions_f_aow\data\img\textures\grass\grass_01_co.paa"}; /// what texture is going to be used

		armor				= 5000;	/// just some protection against missiles, collisions and explosions

		class Hitpoints {};
		class AnimationSources {
			class Corner_1_UD_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_1_LR_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_1_FB_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_2_UD_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_2_LR_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_2_FB_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_3_UD_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_3_LR_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
			class Corner_3_LR_source_FB_source
			{
				source = user; // "user" = custom source = not controlled by some engine value
				initPhase = 0; // Initial value of animations based on this source
				animPeriod = 1; // Coefficient for duration of change of this animation
				sound = "GenericDoorsSound"; /// Selects sound class from CfgAnimationSourceSounds that is going to be used for sounds of doors
			};
		};
		
	};
	
	class TriangleLarge: Triangle
	{
		displayName			= "Magic Triangle (larger anim range)";									/// displayed in Editor
		model				= \magicTriangle\largerTriangl\Triangl.p3d;	/// simple path to model
		hiddenSelections[] = {"camo"}; /// what selection in model could have different textures
		hiddenSelectionsTextures[] = {"\a3\missions_f_aow\data\img\textures\grass\grass_01_co.paa"}; /// what texture is going to be used
		
	};

	
};