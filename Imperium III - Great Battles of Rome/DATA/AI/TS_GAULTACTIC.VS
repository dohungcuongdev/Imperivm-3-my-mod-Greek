// void, Settlement set
int  AIPlayer;
str  cmd;
int  i,gold,food;
ObjList olDruids,olHorsemen;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;

if (EnvReadInt(set, "GaulTactic") == 1) 
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

// hire hero & 5 archers & 2 druids
{
	int i=0;
	int nDruids = 2;
	cmd = "trainGArcher";
	while(!hero.IsValid() || olDruids.count<nDruids || i<5)
	{
		int nCount;
		if (!hero.IsValid())
			hero = set.TSRecruitHero();
		if (olDruids.count<nDruids)
		{
			nCount = nDruids - olDruids.count;			 
			olDruids.AddList(set.TSTempleRecruit(nCount));
		}
		
		if (i<5)
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
			i+=1;			
		}
		Sleep(3020 + rand(15)*130);		
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
}

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	if(bHeroSc)
		AIBreakScript(heroScId);
	if (hero.IsValid)
		hero.SetNoAIFlag(false);	
	olDruids.ClearDead();
	SetNoAIFlag(olDruids,false);
	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}
// 3 druids & horseshoe & 2x increse pop
{
	bool bHorseshoe = false;
	int nIncPop = 0;
	int nDruids = 5;
	while(!bHorseshoe || olDruids.count<nDruids || nIncPop<2)
	{
		if (!bHorseshoe)
			bHorseshoe = set.TSResearch("Gaul Horseman");
		if (olDruids.count<nDruids)
		{
			int nCount;
			nCount = nDruids - olDruids.count;			 
			olDruids.AddList(set.TSTempleRecruit(nCount));			
		}
		if (nIncPop<2)
		if (set.food>400)
		{
			set.TSResearch("GAddPop");
			nIncPop+=1;
		}
		Sleep(5020 + rand(15)*100);		
	}	
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	if(bHeroSc)
		AIBreakScript(heroScId);
	if (hero.IsValid)
		hero.SetNoAIFlag(false);	
	olDruids.ClearDead();
	SetNoAIFlag(olDruids,false);
	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}
if (hero.IsValid)
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

//barrack level 1 & 10 horsemen
{
	bool bBarrack1 = false;
	int nHorsemen = 10;
	while (!bBarrack1 || olHorsemen.count<nHorsemen)
	{
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (bBarrack1 && olHorsemen.count<nHorsemen)
		{
			int nCount;
			nCount = nHorsemen - olHorsemen.count;
			olHorsemen.AddList(set.TSRecruitArmy("GHorseman",nCount));
		}
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			if(bHeroSc)
				AIBreakScript(heroScId);
			if (hero.IsValid)
				hero.SetNoAIFlag(false);	
			olDruids.ClearDead();
			olHorsemen.ClearDead();
			SetNoAIFlag(olDruids,false);
			SetNoAIFlag(olHorsemen,false);
			
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		Sleep(5020 + rand(15)*100);		
	}
}
if (hero.IsValid)
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

// Fights & training 1
{
	bool bFights = false;
	bool bTraining = false;
	while(!bFights || !bTraining)
	{
		if (!bFights)
			bFights = set.TSResearch("Fights");
		if (bFights && !bTraining)
			bTraining = set.TSResearch("Gaul Training 1");	
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			if(bHeroSc)
				AIBreakScript(heroScId);
			if (hero.IsValid)
				hero.SetNoAIFlag(false);	
			olDruids.ClearDead();
			olHorsemen.ClearDead();
			SetNoAIFlag(olDruids,false);
			SetNoAIFlag(olHorsemen,false);
			
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		Sleep(4020 + rand(15)*100);		
	}
}
// Start training warrioirs
set.Research("autotrain_start_gr");
olDruids.ClearDead();
olHorsemen.ClearDead();

olHorsemen.SetCommand("train");
olDruids.SetCommand("train");
// training 2 & 15 horsemen
{
	bool bTraining = false;
	int nHorsemen  = 25;
	while(!bTraining || olHorsemen.count<nHorsemen)
	{
		if (!bTraining)
			bTraining = set.TSResearch("Gaul Training 2");
		if (olHorsemen.count<nHorsemen)
		{
			int nCount;
			nCount = nHorsemen - olHorsemen.count;
			olHorsemen.AddList(set.TSRecruitArmy("GHorseman",nCount));			
		}			
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			if(bHeroSc)
				AIBreakScript(heroScId);
			if (hero.IsValid)
				hero.SetNoAIFlag(false);	
			olDruids.ClearDead();
			olHorsemen.ClearDead();
			SetNoAIFlag(olDruids,false);
			SetNoAIFlag(olHorsemen,false);
			
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		Sleep(6020 + rand(15)*100);		
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

olDruids.ClearDead();
olHorsemen.ClearDead();
SetNoAIFlag(olDruids,false);
SetNoAIFlag(olHorsemen,false);

SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

EnvWriteInt(set, "GaulTactic",1);
