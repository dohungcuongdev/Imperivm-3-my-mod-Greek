// void, Settlement set

int  AIPlayer;
str  cmd;
int  i,gold,food;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olAxemen,olArchers, olMacemen;
int heroScId;

if (EnvReadInt(set, "GermanyTactic3") == 1) 
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

//aSkills[0] = hsEuphoria;      aSkillLevels[0] = 6;
//aSkills[1] = hsConcealment;   aSkillLevels[1] = 10;
/**
if (rand(2)==0)
	aSkills[2] = hsDefensiveCry;  
else
	aSkills[2] = hsAssault;  
	
aSkillLevels[2] = 10;
*/


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
{
	// Research Fast warrior equipment I	
	// Hire a hero
	bool bBarrack1 = false;
	bool bBarrack2 = false;
	bool bBarrack3 = false;
		
	while (!hero.IsValid() ||! bBarrack1 || !bBarrack2 || !bBarrack3 )
	{
		if (!hero.IsValid())
			hero = set.TSRecruitHero();
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (bBarrack1 && !bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack1 && bBarrack2 && !bBarrack3)
			bBarrack3 = set.TSResearch("TBarrack Level 3");
		
		//Sleep(5205 + rand(10)*100);
		Sleep(500);
	}	
}

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	return;
}
if(hero.IsValid)
{
	ObjList ol;
	Obj oDummy;
	ol.Add(hero);
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	heroScId = AIRun("TS_AttackAtWill.vs", set, ol,oDummy, 0);	
}

// Fights 10 Archers && 3 Increase axe production
{
	int nCount = 5; 	
	bool bFights = false;
	int nMaxAxemen = 0;
	while(olArchers.count<nCount || !bFights || nMaxAxemen!=30)
	{
		int nNeeded;
		nNeeded = nCount - olArchers.count;
		olArchers.AddList(set.TSRecruitArmy("TArcher",nNeeded));
		
		nMaxAxemen = EnvReadInt(AIPlayer, "MaxAxemen");				
		if (nMaxAxemen<30)
		{
			Building bld;
			
			cmd = "Axemen production";
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid)
			if (bld.CmdCount(cmd) < 3 - (nMaxAxemen/10))
				set.TSResearch(cmd);			
		}
		if (!bFights)
			bFights = set.TSResearch("TFights");
		else
			if (set.food<1000)
				set.TSResearch("buyfoodforgold"); // don't waste time, buy food			
		//Sleep(10205 + rand(10)*100);
		Sleep(500);
	}
	
	if (EnvReadInt(set,"StopTacticScript") == 1)
	{
		AIBreakScript(heroScId);
		if (hero.IsValid)
			hero.SetNoAIFlag(false);
		olArchers.ClearDead();
		SetNoAIFlag(olArchers,false);
		SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
		SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
		SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
		SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
		SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
		return;
	}

	nCount = 10;
	while(olArchers.count<nCount)
	{
		int nNeeded;
		nNeeded = nCount - olArchers.count;
		olArchers.AddList(set.TSRecruitArmy("TArcher",nNeeded));
		if (set.food<1000)
			set.TSResearch("buyfoodforgold"); // don't waste time, buy food			
		//Sleep(3205 + rand(10)*100);
		Sleep(500);
	}
}

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	AIBreakScript(heroScId);
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
	olArchers.ClearDead();
	SetNoAIFlag(olArchers,false);
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	return;
}

//30 axemen &&  Learning
{
	int nCount = 30; 	
	bool bLearning = false;
	while(olAxemen.count<nCount || !bLearning)
	{
		int nNeeded;
		nNeeded = nCount - olArchers.count;
		olAxemen.AddList(set.TSRecruitArmy("TAxeman",nNeeded));
		if (!bLearning)
			bLearning = set.TSResearch("Learning");
		//Sleep(10205 + rand(10)*100);
		Sleep(500);
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	AIBreakScript(heroScId);
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
	olArchers.ClearDead();
	olAxemen.ClearDead();
	SetNoAIFlag(olArchers,false);
	SetNoAIFlag(olAxemen,false);
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	return;
}
// Give the army to AI
AIBreakScript(heroScId);
if (hero.IsValid)
if (!hero.IsDead)
{
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	hero.SetCommand("enter", set.GetCentralBuilding());
	hero.SetNoAIFlag(false);
}

olArchers.ClearDead();
olAxemen.ClearDead();
SetNoAIFlag(olArchers,false);
SetNoAIFlag(olAxemen,false);

//30 Increase mace production & 300 macemen
{
	int nCount = 300; 	
	int nMaxMacemen = 0;
	while(olMacemen.count<nCount  || nMaxMacemen!=300)
	{
		int nNeeded;
		nNeeded = nCount - olMacemen.count;
		olMacemen.AddList(set.TSRecruitArmy("TMaceman",nNeeded));
		
		nMaxMacemen = EnvReadInt(AIPlayer, "MaxMacemen");				
		if (nMaxMacemen<300)
		{
			Building bld;
			cmd = "Macemen production";
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid)
			if (bld.CmdCount(cmd) < 30 - (nMaxMacemen/10))
				set.TSResearch(cmd);			
		}

		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			olMacemen.ClearDead();
			SetNoAIFlag(olMacemen,false);
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			return;
		}
		//Sleep(10205 + rand(10)*100);
		Sleep(500);
	}
}

olMacemen.ClearDead();
SetNoAIFlag(olMacemen,false);

SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value

EnvWriteInt(set, "GermanyTactic3",1);