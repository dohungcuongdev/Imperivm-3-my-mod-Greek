// void, Settlement set

int  AIPlayer;
str  cmd;
int  i,gold,food;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olTRiders;
int heroScId;
bool bHeroScStart = false;

if (EnvReadInt(set, "GermanyTactic2") == 1) 
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
SetAIVar(AIPlayer, AIV_DonateFood, 0);
SetAIVar(AIPlayer, AIV_DonateGold, 0);
//SetAIVar(AIPlayer, AIV_DonatePop,  0);
SetAIVar(AIPlayer, AIV_BuildArmy,  0);
SetAIVar(AIPlayer, AIV_Research,   0);

if (rand(2)==0)
{
	aSkills[0] = hsEuphoria;      aSkillLevels[0] = 6;
	aSkills[1] = hsConcealment;   aSkillLevels[1] = 10;
	aSkills[2] = hsQuickMarch;    aSkillLevels[2] = 10;
}
else
{
	aSkills[0] = hsEuphoria;      aSkillLevels[0] = 6;
	aSkills[1] = hsQuickMarch;    aSkillLevels[1] = 5;
	aSkills[2] = hsAssault;       aSkillLevels[2] = 10;
}

// Hire hero
hero = set.TSRecruitHero();

// Train 3 swordsmen and send them to spy
cmd = "trainTSwordsman";
for (i = 0; i < 3; i += 1) 
{
	point ptDummy; Obj objDummy;
	Barrack barrack;
	barrack = set.BestBarrack(5);
	if (barrack.IsValid)
	if (GetCmdCost(cmd, gold, food))
	{
		set.SpentGoldOnArmy((gold + (food / 2)));
		barrack.ExecCmd(cmd, ptDummy, objDummy, false);
	}	
}
Sleep(1205 + rand(10)*100);
{
	// Research Fast warrior equipment I &  Hire a hero
	// 1 x Increase Horseshoe production
	bool bBarrack1 = false;
	int nMaxHorsemen = 0;

	while (!hero.IsValid() ||! bBarrack1 || nMaxHorsemen!=10)
	{
		if (!hero.IsValid())
			hero = set.TSRecruitHero();
		else if (!bHeroScStart)
		{
			ObjList ol;
			Obj oDummy;
			ol.Add(hero);
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
			heroScId = AIRun("TS_AttackAtWill.vs", set, ol,oDummy, 0);	
			bHeroScStart = true;
		}	
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
				nMaxHorsemen = EnvReadInt(AIPlayer, "MaxTeutonRiders");				
		if (nMaxHorsemen<10)
		{
			Building bld;
			
			cmd = "Horseshoes production";
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid)
			if (bld.CmdCount(cmd) < 1 - (nMaxHorsemen/10))
				set.TSResearch(cmd);			
		}
	
		Sleep(3205 + rand(10)*100);
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	if (bHeroScStart)
		AIBreakScript(heroScId);
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood,  nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateGold,  nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	return;
}

// Grain Trade
// 1 x Increase Horseshoe production
//20 Teuton Riders
{
	bool bGrainTrade = false;
	bool bFoodTax = false;
	int nTRiders = 20;
	int nMaxTRiders = 0;
	while (!bGrainTrade || !bFoodTax || (olTRiders.count<nTRiders && Count(set.player,"TTeutonRiders")<nMaxTRiders) || nMaxTRiders!=20)
	{
		int nNeeded;
		nNeeded = nTRiders - olTRiders.count;
		olTRiders.AddList(set.TSRecruitArmy("TTeutonRider",nNeeded));
		
		if (!bGrainTrade)
			bGrainTrade = set.TSResearch("TGrainTrade");
		else //Increase Horseshoe production
			{
				nMaxTRiders = EnvReadInt(AIPlayer, "MaxTeutonRiders");				
				if (nMaxTRiders<20)
				{
					Building bld;
					cmd = "Horseshoes production";
					bld = set.FindResearchLab(cmd);
					if (bld.IsValid)
					if (bld.CmdCount(cmd) < 2 - (nMaxTRiders/10))
						set.TSResearch(cmd);			
				}
				else
					if (!bFoodTax)
						bFoodTax = set.TSResearch("TFoodTax");
			}
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			if (bHeroScStart)
				AIBreakScript(heroScId);
			if (hero.IsValid)
				hero.SetNoAIFlag(false);
			olTRiders.ClearDead();
			SetNoAIFlag(olTRiders,false);
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood,  nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateGold,  nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			return;
		}
		Sleep(5205 + rand(10)*100);
	}

}
// Food Tax & Fights
{
	bool bFoodTax = false;
	bool bFights = false;
	while (!bFoodTax || !bFights)
	{
		if (!bFoodTax)
			bFoodTax = set.TSResearch("TFoodTax");
		if (!bFights)
			bFights = set.TSResearch("TFights");
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			if (bHeroScStart)
				AIBreakScript(heroScId);
			if (hero.IsValid)
				hero.SetNoAIFlag(false);
			olTRiders.ClearDead();
			SetNoAIFlag(olTRiders,false);
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood,  nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateGold,  nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			return;
		}
		Sleep(7205 + rand(10)*100);
	}
}

// Teuton Master
// 1 x Increase Horseshoe production
//10 Teuton Riders
{
	bool bTMaster = false;
	int nMaxTRiders = 0;
	int nTRiders = 30;
	while(!bTMaster|| (olTRiders.count<nTRiders && Count(set.player,"TTeutonRiders")<nMaxTRiders) || nMaxTRiders!=30)
	{
		int nNeeded;
		nNeeded = nTRiders - olTRiders.count;
		olTRiders.AddList(set.TSRecruitArmy("TTeutonRider",nNeeded));
		
		if (!bTMaster)
			bTMaster = set.TSResearch("Teuton Master");
			
		nMaxTRiders = EnvReadInt(AIPlayer, "MaxTeutonRiders");				
		if (nMaxTRiders<30)
		{
			Building bld;
			cmd = "Horseshoes production";
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid)
			if (bld.CmdCount(cmd) < 3 - (nMaxTRiders/10))
				set.TSResearch(cmd);			
		}
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			if (bHeroScStart)
				AIBreakScript(heroScId);
			if (hero.IsValid)
				hero.SetNoAIFlag(false);
			olTRiders.ClearDead();
			SetNoAIFlag(olTRiders,false);
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood,  nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateGold,  nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			return;
		}
		Sleep(10205 + rand(10)*100);
	}
}

AIBreakScript(heroScId);
if (hero.IsValid)
if (!hero.IsDead)
{
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	hero.SetCommand("enter", set.GetCentralBuilding());
	hero.SetNoAIFlag(false);
}
olTRiders.ClearDead();
SetNoAIFlag(olTRiders,false);

SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood,  nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateGold,  nDonateGold); // Return variable to its value

// Attack focus
// Learning
{
	bool bAttackFocus = false;
	bool bLearning = false;
	while (!bAttackFocus || !bLearning)
	{
		if (!bAttackFocus)
			bAttackFocus = set.TSResearch("Attack focus");
		if (!bLearning)
			bLearning = set.TSResearch("Learning");
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			return;
		}
		Sleep(10205 + rand(10)*100);
	}
}

SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value

EnvWriteInt(set, "GermanyTactic2",1);