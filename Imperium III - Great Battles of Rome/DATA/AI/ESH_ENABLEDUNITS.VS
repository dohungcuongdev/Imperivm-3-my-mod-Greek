// void, Settlement set

int AIPlayer;
int nEnabled;

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

AIPlayer = set.player;

nEnabled = 0;
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGSwordsman),      0, Gaul);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGArcher),         1, Gaul);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGAxeman),         2, Gaul);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGSpearman),       3, Gaul);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGHorseman),       4, Gaul);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGWomanWarrior),   5, Gaul);
EnvWriteInt(AIPlayer, "GaulUnitsEnabled", nEnabled);

if(EnvReadString(set, "ChooseRepublicanRome") == "researched")
{
	nEnabled = 0;
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRHastatus),       0, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRArcher),         1, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRGladiator),      2, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRPrinciple),      3, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRScout),          4, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRTribune),        5, RepublicanRome);
	EnvWriteInt(AIPlayer, "RepublicanRomeUnitsEnabled", nEnabled);
}

if(EnvReadString(set, "ChooseImperialRome") == "researched")
{
	nEnabled = 0;
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRHastatus),       0, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRArcher),         1, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRVelit),          2, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRPrinciple),      3, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRScout),          4, RepublicanRome);
	CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRPraetorian),     5, RepublicanRome);
	//EnvWriteInt(AIPlayer, "RepublicanRomeUnitsEnabled", nEnabled);
	EnvWriteInt(AIPlayer, "IRomeUnitsEnabled", nEnabled);
}	//End if.

/* GRECIA: */
nEnabled = 0;
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxHToxotes),        1, Greece);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxHHoplite),        2, Greece);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxHChariot),        4, Greece);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxHHypaspista),     5, Greece);
EnvWriteInt(AIPlayer, "GreekUnitsEnabled", nEnabled);

nEnabled = 0;
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxCLibyanFootman),  0, Carthage);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxCJavelinThrower), 1, Carthage);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxCBerberAssassin), 2, Carthage);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxCMaceman),        3, Carthage);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxCNumidianRider),  4, Carthage);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxCNoble),          5, Carthage);
EnvWriteInt(AIPlayer, "CarthageUnitsEnabled", nEnabled);

nEnabled = 0;
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxIMilitiaman),     0, Iberia);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxIArcher),         1, Iberia);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxIDefender),       2, Iberia);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxICavalry),        3, Iberia);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxISlinger),        4, Iberia);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxIEliteGuard),     5, Iberia);
EnvWriteInt(AIPlayer, "IberiaUnitsEnabled", nEnabled);

nEnabled = 0;
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxBSwordsman),      0, Britain);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxBBowman),         1, Britain);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxBBronzeSpearman), 2, Britain);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxBShieldBearer),   3, Britain);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxBJavelineer),     4, Britain);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxBHighlander),     5, Britain);
EnvWriteInt(AIPlayer, "BritainUnitsEnabled", nEnabled);

nEnabled = 0;
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxESwordsman),      0, Egypt);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxEArcher),         1, Egypt);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxEAxetrower),      2, Egypt);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxEAnubisWarrior),  3, Egypt);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxEHorusWarrior),   4, Egypt);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxEGuardian),       5, Egypt);
EnvWriteInt(AIPlayer, "EgyptUnitsEnabled", nEnabled);

nEnabled = 0;
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxTSwordsman),      0, Germany);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxTArcher),         1, Germany);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxTAxeman),         2, Germany);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxTHuntress),       3, Germany);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxTTeutonRider),    4, Germany);
CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxTMaceman),        5, Germany);
EnvWriteInt(AIPlayer, "GermanyUnitsEnabled", nEnabled);
