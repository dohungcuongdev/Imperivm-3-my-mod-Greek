// void, Settlement set
int  AIPlayer;
int  i,gold,food;
ObjList olHastati,olArchers,olPriests, olTribunes,olSpies, olGladiators;

int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;

if (EnvReadInt(set, "RRomeTactic3") == 1) 
	return;

if (EnvReadInt(set,"StopTacticScript") == 1)
	return;

AIPlayer = set.player;
// Read variables
nDonateFood = AIVar(AIPlayer, AIV_DonateFood);
nDonateGold = AIVar(AIPlayer, AIV_DonateGold);
nDonatePop  = AIVar(AIPlayer, AIV_DonatePop);
nBuildArmy  = AIVar(AIPlayer, AIV_BuildArmy);
nResearch   = AIVar(AIPlayer, AIV_Research);
// Set new values to disable 
//SetAIVar(AIPlayer, AIV_DonateFood, 0);
SetAIVar(AIPlayer, AIV_DonateGold, 0);
SetAIVar(AIPlayer, AIV_DonatePop,  0);
SetAIVar(AIPlayer, AIV_BuildArmy,  0);
SetAIVar(AIPlayer, AIV_Research,   0);

// Set skills
aSkills[0] = hsTeamAttack;    aSkillLevels[0] = 10;
aSkills[1] = hsTeamDefense;   aSkillLevels[1] = 10;
aSkills[2] = hsBattleCry; aSkillLevels[2] = 2;
aSkills[3] = hsQuickMarch;    aSkillLevels[3] = 3;

// barrack level 1,2,3 & hero & Altar of Jupiter, God's Gift
{
	ObjList ol;
	bool bBarrack1 = false;
	bool bBarrack2 = false;
	bool bBarrack3 = false;
	bool bAltarJupiter = false;
	bool bGodGift = false;
	while (!bBarrack1 || !hero.IsValid() || !bBarrack2 || !bBarrack3 || !bAltarJupiter || !bGodGift)
	{
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (bBarrack1 && !bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack1 && bBarrack2 && !bBarrack3)
			bBarrack3 = set.TSResearch("RBarrack Level 3");
		if (!bAltarJupiter)
			bAltarJupiter = set.TSResearch("Altar of Jupiter");
		if (bAltarJupiter && !bGodGift)
			bGodGift = set.TSResearch("God's Gift");
		if (!hero.IsValid())
			hero = set.TSRecruitHero();
		//Sleep(10675 + rand(10)*100);
		Sleep(500);
	}
}

//30 hastati 
{
	int nSpies = 0;
	str cmd = "trainRHastatus";
	while (nSpies<30)
	{
		if (nSpies<30)
		{
			point ptDummy; Obj objDummy;
			Barrack barrack;
			barrack = set.BestBarrack(30);
			if (barrack.IsValid)
			if (GetCmdCost(cmd, gold, food))
			{
				set.SpentGoldOnArmy((gold + (food / 2)));
				barrack.ExecCmd(cmd, ptDummy, objDummy, false);
			}	
			nSpies+=1;
		}
	
		//Sleep(3472 + rand(10)*100);
		Sleep(500);
	}
	
}

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Stop Script;
	if (bHeroSc)
		AIBreakScript(heroScId);
	// Set AI flag 
	if (hero.IsValid())
		hero.SetNoAIFlag(false);
	// set AI const	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

if (hero.IsValid())
if(!bHeroSc)
{
	ObjList ol;
	Obj oDummy;
	ol.Add(hero);
	hero.KillCommand();
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	heroScId = AIRun("TS_AttackAtWill.vs", set, ol,oDummy, 0);	
	bHeroSc = true;					
}	
else
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Stop Script;
	if (bHeroSc)
		AIBreakScript(heroScId);
	// Set AI flag 
	if (hero.IsValid())
		hero.SetNoAIFlag(false);
	olHastati.ClearDead();
	SetNoAIFlag(olHastati,false);
	// set AI const	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

// attach to hero attack outposts
if (hero.IsValid())
if (hero.IsAlive)
{
	ObjList ol;
	Obj oDummy;

	if (bHeroSc)
	  AIBreakScript(heroScId);
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	hero.SetCommand("enter", set.GetCentralBuilding() );
	olHastati.ClearDead();
	olHastati.SetCommand("attach", hero);
	ol.Add(hero);
	heroScId = AIRun("TS_AttackAtWill.vs", set, ol,oDummy, 0);
}

// Arrows
{
	bool bArrows = false;
	while (!bArrows)
		{
			bArrows = set.TSResearch("Roman Archers");
			//Sleep(3675 + rand(10)*100);
			Sleep(500);
		}
}
if (hero.IsValid())
if (hero.IsAlive)
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Stop Script;
	if (bHeroSc)
		AIBreakScript(heroScId);
	// Set AI flag 
	if (hero.IsValid())
		hero.SetNoAIFlag(false);
	olHastati.ClearDead();
	SetNoAIFlag(olHastati,false);
	// set AI const	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}
// 25 archers
{
	int nArchers = 25;
	while (olArchers.count<nArchers)
		{
			int nCount;
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("RArcher",nCount));
			//Sleep(7675 + rand(10)*100);
			Sleep(500);
		}
}

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Stop Script;
	if (bHeroSc)
		AIBreakScript(heroScId);
	// Set AI flag 
	if (hero.IsValid())
		hero.SetNoAIFlag(false);
	olHastati.ClearDead();
	SetNoAIFlag(olHastati,false);
	olArchers.ClearDead();
	SetNoAIFlag(olArchers,false);
	// set AI const	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

if (hero.IsValid())
if (hero.IsAlive)
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

// pikes & gladiator shows & training 
{
	bool bPikes = false;
	bool bGladiatorShow = false;
	bool bTraining = false;
	while (!bPikes || !bGladiatorShow || !bTraining)
	{
		if (!bPikes)
			bPikes = set.TSResearch("Roman Full Armor");
		if (!bGladiatorShow)	
			bGladiatorShow = set.TSResearch("RGladiator Shows");
		if (bGladiatorShow && !bTraining)
			bTraining = set.TSResearch("Rome Training 1");

		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			// Stop Script;
			if (bHeroSc)
				AIBreakScript(heroScId);
			// Set AI flag 
			if (hero.IsValid())
				hero.SetNoAIFlag(false);
			olHastati.ClearDead();
			SetNoAIFlag(olHastati,false);
			olArchers.ClearDead();
			SetNoAIFlag(olArchers,false);
			// set AI const	
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}

		//Sleep(7675 + rand(10)*100);
		Sleep(500);
	}
}

if (hero.IsValid())
if (hero.IsAlive)
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

set.Research("autotrain_start_gr");

//10 priests & 300 Tribunes & 100 Gladiators
{
	int nPriests = 10;
	int nTribunes = 300;
	int nGladiators = 100;
	while (olPriests.count<nPriests || olTribunes.count<nTribunes || olGladiators.count<nGladiators)
	{
		if (olPriests.count<nPriests)	
		{
			int nCount;
			nCount = nPriests - olPriests.count;
			olPriests.AddList(set.TSTempleRecruit(nCount));
		}
		if (olTribunes.count<nTribunes)	
		{
			int nCount;
			nCount = nTribunes - olTribunes.count;
			olTribunes.AddList(set.TSRecruitArmy("RTribune",nCount));
		}
		if (olGladiators.count<nGladiators)	
		{
			int nCount;
			nCount = nGladiators - olGladiators.count;
			olGladiators.AddList(set.TSRecruitArmy("RGladiator",nCount));
		}

		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			// Stop Script;
			if (bHeroSc)
				AIBreakScript(heroScId);
			// Set AI flag 
			if (hero.IsValid())
				hero.SetNoAIFlag(false);
			olArchers.ClearDead();
			olHastati.ClearDead();
			olPriests.ClearDead();
			olTribunes.ClearDead();
			olGladiators.ClearDead();
			SetNoAIFlag(olArchers,false);
			SetNoAIFlag(olHastati,false);
			SetNoAIFlag(olPriests,false);
			SetNoAIFlag(olTribunes,false);
			SetNoAIFlag(olGladiators,false);
			// set AI const	
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}

		//Sleep(8675 + rand(10)*100);
		Sleep(500);
	}
}

// Give army to AI
if (bHeroSc)
	AIBreakScript(heroScId);

if (hero.IsValid)
if (hero.IsAlive)
{
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	hero.SetCommand("enter", set.GetCentralBuilding() );
	hero.SetNoAIFlag(false);
}

olArchers.ClearDead();
olHastati.ClearDead();
olPriests.ClearDead();
olTribunes.ClearDead();
olGladiators.ClearDead();
SetNoAIFlag(olArchers,false);
SetNoAIFlag(olHastati,false);
SetNoAIFlag(olPriests,false);
SetNoAIFlag(olTribunes,false);
SetNoAIFlag(olGladiators,false);

SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

EnvWriteInt(set, "RRomeTactic3",1);
