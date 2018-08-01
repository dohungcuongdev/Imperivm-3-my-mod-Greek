// void, Settlement set

// called by ES_Stronghold.vs

int  AIPlayer, nRace;
str  strTech, strHire, class;
int  max = 0, nMaxAllowed, nCallCount = 1;
int  nHires, nCount;
bool bUpgrade = true, bWaitUpdates = false;
bool bRush = false;
int  nAssUnderFire = 0;
bool bLogPlayer = false, bLogRush = false;
int  nFoodReserve;
int  nArenaResearchLevel;	/// 0 -> no upgrades, 1 -> first, 2 -> important upgrades
int  nArenaComplete = 0; /// 0 or 1. important upgrades + maximum arena units
int  nUpgradeType = 0; // 0 - no upgrade, 1 - player upgrade, 2 - settlement upgrade

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;
bLogPlayer = UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);

nAssUnderFire = EnvReadInt(set, "AssUnderFire");         /// set in "ES_Stronghold.vs"
nFoodReserve = EnvReadInt(set, "nFoodReserve");

nArenaResearchLevel = EnvReadInt(set, "ArenaResearchLevel");
EnvWriteInt(set, "ArenaComplete", 0);

bRush = (EnvReadInt(set, "ArenaRush") != 0);
if (bRush && nRace != Gaul && EnvReadString(set, "ChooseImperialRome") != "researched")
	{ EnvWriteInt(set, "ArenaRush", 0); bRush = false; }
bLogRush = bLogPlayer && bRush && AIVar(AIPlayer, AIV_LogRush) != 0;
if (bLogRush)
{
	pr("Player " + AIPlayer + " makes arena rush!");
	EnvWriteInt(AIPlayer, "ArenaRushLogged", 1);
}

/// FIRST UPGRADES
if (nArenaResearchLevel < 1)
{
	if (nRace == Gaul)
		strTech = "Fights";
	else if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
		strTech = "RGladiator Shows2";
	else if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseRepublicanRome") == "researched") )
		strTech = "Roman Chariot Wheels";
	else if (nRace == Carthage)
		strTech = "People's Assembly";
	else if (nRace == Iberia)
		strTech = "Tournaments";
	else if (nRace == Britain)
		strTech = "Britain Fights";
	else if (nRace == Egypt)
		strTech = "Cult of Osiris";
	else if (nRace == Germany)
		strTech = "TFights";
	else if (nRace == Greece)    // Giochi olimpici per la Grecia.
		strTech = "Olympic Games";
	else
		return;
	if (strTech != "") if (!IsResearched(set, strTech))
	{
		int budget;
		if (bRush) 
		{
			budget = AIVar(AIPlayer, AIV_TechBudget);  // save orig. value
			SetAIVar(AIPlayer, AIV_TechBudget, 100); // all money go for tech
		}
		EnvWriteString(set, "strTech", strTech);
		set.AIRun("ESH_NeedTech.vs");
		if (bRush)
			SetAIVar(AIPlayer, AIV_TechBudget, budget);
		return;
	}
	nArenaResearchLevel = 1;
	if (nRace == Carthage)
		nArenaResearchLevel = 2;
	EnvWriteInt(set, "ArenaResearchLevel", nArenaResearchLevel);
}

if (!bRush) if (rand(100) < 50)
	return; // lets ESH_ResearchTraining take the ball :)

/// SPECIFY ARENA UNITS, ITS COUNT AND MAXIMUM COUNT
strHire = "";
if (nRace == Gaul)
{
	strHire = "Hire Trident warrior";
	class = "GTridentWarrior";
	max = 4;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxGTridentWarrior);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
	nUpgradeType = 2; // settlement
	strTech = "Trident Warrior Exp1";
}
else if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
{
	strHire = "Hire Liberati";
	class = "RLiberatus";
	nCallCount = 10;
	max = 20;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxRLiberati);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
	nUpgradeType = 2; // player
	strTech = "Liberati guild";
}
else if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseRepublicanRome") == "researched") )
{
	strHire = "Equip Chariot";
	class = "RChariot";
	max = 10;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxRChariot);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
}
else if (nRace == Carthage)
{
	strHire = "Train War Elephant";
	class = "CWarElephant";
	max = 1 + EnvReadInt(AIPlayer, "MaxElephants");
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxCWarElephant);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
}
else if (nRace == Iberia)
{
	strHire = "Call Mountaineer";
	class = "IMountaineer";
	max = 10;
	if (IsResearched(AIPlayer, "Mountain Clan"))
		max = 20;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxIMountaineers);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
	nUpgradeType = 1; // player
	strTech = "Mountain Clan";
}
else if (nRace == Britain)
{
	strHire = "Hire Viking Lord";
	class = "BVikingLord";
	max = 4;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxBVikingLord);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
	nUpgradeType = 2; // settlement
	strTech = "Shrine of Thor";
}
else if (nRace == Egypt)
{
	strHire = "Chariot of Osiris";
	class = "EChariot";
	max = 10;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxBVikingLord);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
}
else if (nRace == Germany)
{
	strHire = "Call Valkyries";
	class = "TValkyrie";
	nCallCount = 5;
	max = 10;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxBVikingLord);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
	nUpgradeType = 2; // settlement
	strTech = "Legendary Valkyries";
}
else if(nRace == Greece)    // -> RECLUTAMENTO MIRMIDONI.
{
	strHire = "trainHMyrmidon";
	class = "HMyrmidon";
	max = EnvReadInt(AIPlayer, "MaxMyrmidons");
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxHMyrmidon);
	if (nMaxAllowed >= 0 && nMaxAllowed < max)
		max = nMaxAllowed;
}	//End else if.

if (strHire == "")
	return;
nCount = Count(AIPlayer, class);

/// UPGRADE UNITS

// decide whether to try to upgrade hires
nHires = AIVar(AIPlayer, AIV_ArenaUpgradeHires);
if (nHires < 0) bWaitUpdates = true;
else if (nHires == 0) bUpgrade = false;

if (!bUpgrade)
{
	nArenaResearchLevel = 2;
}
else
{
	// settlement upgrades (germany, irome, briton & gaul)
	if (nUpgradeType == 2)
	if (nArenaResearchLevel < 2)
	{
		if (nRace == Gaul)
		if (IsResearched(set, strTech)) 
		{
			strTech = "Trident Warrior Exp2";
			if (IsResearched(set, strTech))
				strTech = "Trident Warrior Exp3";
		}
		if (IsResearched(set, strTech))
			nArenaResearchLevel = 2;
		else 
		{
			int budget;
			if (bRush) 
			{
				budget = AIVar(AIPlayer, AIV_TechBudget);  // save orig. value
				SetAIVar(AIPlayer, AIV_TechBudget, 100); // all money go for tech
			}
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			if (bRush)
				SetAIVar(AIPlayer, AIV_TechBudget, budget);
			if (bWaitUpdates || IsResearching(set, strTech))
				return; // wait the research
		}
	}

	// player upgrades (iberia & carthage)
	if (nUpgradeType == 1)
	{
		if (nRace == Iberia && max > 10)
			strTech = "Mountain Clan Legacy";
		if (!IsResearched(AIPlayer, strTech))
		{
			int budget;
			if (bRush) {
				budget = AIVar(AIPlayer, AIV_TechBudget);  // save orig. value
				SetAIVar(AIPlayer, AIV_TechBudget, 100); // all money go for tech
			}
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			if (bRush)
				SetAIVar(AIPlayer, AIV_TechBudget, budget);
			if (bWaitUpdates || IsResearching(set, strTech))
				return; // wait the research
		}
		nArenaResearchLevel = 2;
	}

}

EnvWriteInt(set, "ArenaResearchLevel", nArenaResearchLevel);

if (nCount + nCallCount <= max)
{
	bool bBuild;
	int gold, food; 
	bBuild = GetCmdCost(strHire, gold, food);
	if (bBuild) if (nRace == Carthage) if (set.food - food < nFoodReserve)
		bBuild = false;
	if (!bBuild)
	{
		EnvWriteInt(set, "ArenaRush", 0); 
		if (bLogRush)
			pr("Player " + AIPlayer + "'s arena rush failed on " + nCount + "th unit " + strHire);
		return; 
	}
	EnvWriteString(set, "strTech", strHire);
	set.AIRun("ESH_NeedTech.vs");
	return;
}

EnvWriteInt(set, "ArenaRush", 0);
if (bLogRush)
	pr("Player " + AIPlayer + "'s arena rush is complete");

if (nArenaResearchLevel == 2)
	nArenaComplete = 1;
EnvWriteInt(set, "ArenaComplete", nArenaComplete);

if (bUpgrade)
if (nArenaComplete > 0)
{
	/// Gaul: "Battle tactics"
	if (nRace == Gaul)
	if (set.gold >= AIVar(AIPlayer, AIV_ExcessGold))
	{
		strTech = "Battle tactics";
		if (!IsResearched(AIPlayer, strTech))
		{
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			return;
		}
	}

	/// Iberia: "Nobility"
	if (nRace == Iberia)
	if (set.gold >= AIVar(AIPlayer, AIV_ExcessGold))
	{
		strTech = "Nobility";
		if (!IsResearched(set, strTech))
		if (!IsResearching(set, strTech))
		{
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			return;
		}
	}

	/// Carthage: "Mahout School"
	if (nRace == Carthage)
	if (set.food > nFoodReserve)
	if (nMaxAllowed < 0 || max < nMaxAllowed)
	if (IsResearched(AIPlayer, "Spoils of war")) // upgrade in ESH_Market.vs
	{
		int gold, food;
		str cmd = "Train War Elephant";
		GetCmdCost(cmd, gold, food);
		if (set.food - food > nFoodReserve)
		if (set.CanAfford(cmd, 1))
		{
			EnvWriteString(set, "strTech", "Mahout School");
			set.AIRun("ESH_NeedTech.vs");
			return;
		}
	}
	
	///Greece: 
}
