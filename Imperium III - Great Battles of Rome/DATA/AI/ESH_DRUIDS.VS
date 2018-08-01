// void, Settlement set

int AIPlayer, nRace;
str cmd;
int percent, needed, avail;
bool bLogArmy;

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;
bLogArmy = (AIVar(AIPlayer, AIV_LogArmy) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);
percent = AIVar(AIPlayer, AIV_Druids);
needed = percent * MilUnits(AIPlayer) / 100;
avail = Count(AIPlayer, "BaseMage");

if (avail >= needed)
	return;

if (Gaul == nRace)
	cmd = "trainGDruid";
else if (RepublicanRome == nRace)
	cmd = "trainRPriest";
else if (Carthage == nRace)
	cmd = "trainCShaman";
else if (Iberia == nRace)
	cmd = "trainIEnchantress";
else if (Britain == nRace)
	cmd = "trainBDruid";
else if (Germany == nRace)
	cmd = "trainTEnchantress";
else if (Egypt == nRace)
	cmd = "trainEPriest";
else if(Greece == nRace)
	cmd = "trainHPriest";
else
{
	if (bLogArmy) pr("Unknown race: " + set.GetCentralBuilding.raceStr);
	return;
}

if (set.CanResearch(cmd))
{
	int gold, food;
	if (GetCmdCost(cmd, gold, food)) if (set.CanAfford(gold, food))
	{
		set.Research(cmd); 
		set.SpentGoldOnArmy(gold);
		if (bLogArmy)
			pr("Player " + AIPlayer + " " + cmd);
	}
}
