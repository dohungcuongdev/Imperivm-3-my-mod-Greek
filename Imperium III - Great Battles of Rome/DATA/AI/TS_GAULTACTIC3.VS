// void, Settlement set
int  AIPlayer;
int  i;
ObjList olArchers, olSpearmen;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;

if (EnvReadInt(set, "GaulTactic2") == 1) 
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
	aSkills[0] = hsLeadership;    aSkillLevels[0] = 10;
	aSkills[1] = hsBattleCry;     aSkillLevels[1] = 10;

// hire hero & barrack level 1 & 2x inc pop
{
	int nIncPop=0;
	bool bBarrack1 = false;
	bool bSpears1 = false;
	while(!hero.IsValid() || !bBarrack1 || nIncPop<2 || !bSpears1)
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
		if (!bSpears1)
			bSpears1 = set.TSResearch("Gaul Spearman");
		if (nIncPop<2)
		if (set.food>400)
		{
			set.TSResearch("GAddPop");
			nIncPop+=1;
		}
		Sleep(7024 + rand(15)*100);		
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
			
// spears 2 & Fights
{
	bool bSpears2 = false;
	bool bFights = false;
	while (!bSpears2 || !bFights)
	{
		if (!bSpears2)
			bSpears2 = set.TSResearch("Gaul Iron Spearheads");
		if (!bFights)
			bFights = set.TSResearch("Fights");
		Sleep(4024 + rand(15)*100);		
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

// 30 spearmen & 20 archers & training 1
{
	bool bTraining = false;
	int nSpearmen  = 30;
	int nArchers   = 20;
	while (!bTraining || olArchers.count<nArchers || olSpearmen.count<nSpearmen)
	{
		int nCount;
		if (olSpearmen.count<nSpearmen)
		{
			nCount = nSpearmen - olSpearmen.count;
			olSpearmen.AddList(set.TSRecruitArmy("GSpearman",nCount));			
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
			olSpearmen.ClearDead();
			SetNoAIFlag(olArchers,false);
			SetNoAIFlag(olSpearmen,false);

			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		Sleep(15024 + rand(10)*100);		
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
olSpearmen.ClearDead();
SetNoAIFlag(olArchers,false);
SetNoAIFlag(olSpearmen,false);


SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

EnvWriteInt(set, "GaulTactic2",1);
