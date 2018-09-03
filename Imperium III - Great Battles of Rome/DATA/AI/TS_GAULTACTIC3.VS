// void, Settlement set
int  AIPlayer;
int  i;
ObjList olArchers, olWomenWarrior;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;

if (EnvReadInt(set, "GaulTactic3") == 1) 
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
	//aSkills[0] = hsLeadership;    aSkillLevels[0] = 10;
	//aSkills[1] = hsBattleCry;     aSkillLevels[1] = 10;

// hire hero & barrack level 1,2,3 & FreeBeer & Item & 2x inc pop
{
	int nIncPop=0;
	bool bBarrack1 = false;
	bool bBarrack2 = false;
	bool bBarrack3 = false;
	bool bFreeBeer = false;
	bool bItem1 = false;
	bool bItem2 = false;
	bool bWomanUpgrades1 = false;
	while(!hero.IsValid() || !bBarrack1 || !bBarrack2 || !bBarrack3 || !bFreeBeer || !bItem1 || !bItem2 || nIncPop<2 || !bWomanUpgrades1)
	{
		if (!hero.IsValid())
			hero = set.TSRecruitHero();
		else
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
			
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (bBarrack1 && !bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack1 && bBarrack2 && !bBarrack3)
			bBarrack3 = set.TSResearch("GBarrack Level 3");
		
		if (!bFreeBeer)
			bFreeBeer = set.TSResearch("Free Beer");
		if (bFreeBeer && !bItem1)
			bItem1 = set.TSResearch("Nordic trade routes");
		if (bItem1 &&!bItem2)
			bItem2 = set.TSResearch("Belts of Might");
		
		if (!bWomanUpgrades1)
			bWomanUpgrades1 = set.TSResearch("Gaul Woman Warrior");
		if (nIncPop<2)
		if (set.food>400)
		{
			set.TSResearch("GAddPop");
			nIncPop+=1;
		}
		//Sleep(7024 + rand(15)*100);	
		Sleep(1000);
	}	
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// stop script
	if (bHeroSc)
		AIBreakScript(heroScId);
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
		SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
		SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
		SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
		SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
		SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

	if (hero.IsValid)
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
			
// Women Upgrade level 6 & Fights
{
	bool bWomanUpgrades2 = false;
	bool bFights = false;
	while (!bWomanUpgrades2 || !bFights)
	{
		if (!bWomanUpgrades2)
			bWomanUpgrades2 = set.TSResearch("Gaul Fine Armor");
		if (!bFights)
			bFights = set.TSResearch("Fights");
		//Sleep(4024 + rand(15)*100);
		Sleep(1000);
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// stop script
	if (bHeroSc)
		AIBreakScript(heroScId);
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
		SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
		SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
		SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
		SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
		SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

if (hero.IsValid)
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

// 300 Women Warrior & 10 archers & training 1
{
	bool bTraining = false;
	int nWomenWarrior  = 300;
	int nArchers   = 10;
	while (!bTraining || olArchers.count<nArchers || olWomenWarrior.count<nWomenWarrior)
	{
		int nCount;
		if (olWomenWarrior.count<nWomenWarrior)
		{
			nCount = nWomenWarrior - olWomenWarrior.count;
			olWomenWarrior.AddList(set.TSRecruitArmy("GWomanWarrior",nCount));			
		}
		if (olArchers.count<nArchers)
		{
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("GArcher",nCount));			
		}
		if (!bTraining)
			bTraining = set.TSResearch("Gaul Training 1");	
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			// stop script
			if (bHeroSc)
				AIBreakScript(heroScId);
			if (hero.IsValid)
				hero.SetNoAIFlag(false);

			olArchers.ClearDead();
			olWomenWarrior.ClearDead();
			SetNoAIFlag(olArchers,false);
			SetNoAIFlag(olWomenWarrior,false);

			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		//Sleep(15024 + rand(10)*100);
		Sleep(1000);		
	}
}
set.Research("autotrain_start_gr");

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
olWomenWarrior.ClearDead();
SetNoAIFlag(olArchers,false);
SetNoAIFlag(olWomenWarrior,false);


SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

EnvWriteInt(set, "GaulTactic3",1);
