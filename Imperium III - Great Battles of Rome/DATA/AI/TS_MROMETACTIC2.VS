// void, Settlement set
int  AIPlayer;
int  i,gold,food;
ObjList olHastati,olArchers,olPriests, olPrinciples;

int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;

if (EnvReadInt(set, "MRomeTactic2") == 1) 
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
aSkills[2] = hsQuickMarch;    aSkillLevels[2] = 3;
aSkills[3] = hsDiscipline;    aSkillLevels[3] = 3;

//barrack level 1 & hero
{
	ObjList ol;
	bool bBarrack1 = false;
	while (!bBarrack1 || !hero.IsValid() )
	{
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!hero.IsValid())
			hero = set.TSRecruitHero();

		Sleep(10072 + rand(13)*100);
	}
}
//5 hastati 
{
	int nSpies = 0;
	str cmd = "trainRHastatus";
	while (nSpies<5)
	{
		if (nSpies<5)
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
			nSpies+=1;
		}
	
		Sleep(3472 + rand(10)*100);
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

// barrack level 2 & 20 more hastati
{
	bool bBarrack2 = false;
	int nHastati = 25;
	while (!bBarrack2 || olHastati.count<nHastati)
		{
			if (!bBarrack2)
				bBarrack2 = set.TSResearch("Barrack Level 2");
				
			if (bBarrack2 && olHastati.count<nHastati)
			{
				int nCount;
				nCount = nHastati - olHastati.count;
				olHastati.AddList(set.TSRecruitArmy("RHastatus",nCount));
				olHastati.ClearDead();
				olHastati.SetCommand("enter", set.GetCentralBuilding());
			}
		Sleep(5472 + rand(10)*100);
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

// gladiator shows & standartization 
{
	bool bStandartization = false;
	bool bGladiatorShow = false;
	while (!bStandartization || !bGladiatorShow)
	{
		if (!bGladiatorShow)	
			bGladiatorShow = set.TSResearch("RGladiator Shows2");

		if (bGladiatorShow &&!bStandartization)
			bStandartization = set.TSResearch("Standartization I");

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
		Sleep(10771 + rand(10)*100);
	}
}

if (hero.IsValid())
if (hero.IsAlive)
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

// Arrows
{
	bool bArrows = false;
	while (!bArrows)
		{
			bArrows = set.TSResearch("Roman Archers");
			Sleep(5675 + rand(12)*100);
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

// 20 archers
{
	int nArchers = 20;
	while (olArchers.count<nArchers)
		{
			int nCount;
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("RArcher",nCount));
			Sleep(6472 + rand(10)*100);
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

// pikes
{
	bool bPikes = false;
	while (!bPikes)
	{
		if (!bPikes)
			bPikes = set.TSResearch("Roman Principle");
		Sleep(6472 + rand(10)*100);
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

set.Research("autotrain_start_gr");

//30 principles
{
	int nPrinciples = 30;
	while (olPrinciples.count<nPrinciples)
	{
		if (olPrinciples.count<nPrinciples)	
		{
			int nCount;
			nCount = nPrinciples - olPrinciples.count;
			olPrinciples.AddList(set.TSRecruitArmy("RPrinciple",nCount));
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
			olPrinciples.ClearDead();
			SetNoAIFlag(olPrinciples,false);
			
			// set AI const	
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		Sleep(5472 + rand(10)*100);
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
olPrinciples.ClearDead();
SetNoAIFlag(olArchers,false);
SetNoAIFlag(olHastati,false);
SetNoAIFlag(olPrinciples,false);

SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value

// standartization 2 & flexibility
{
	bool bStandartization2 = false;
	bool bFlexibility = false;
	while (!bStandartization2 || !bFlexibility)
	{
		if (!bStandartization2)
			bStandartization2 = set.TSResearch("Standartization II");

		if (bStandartization2 && !bFlexibility)
			bFlexibility = set.TSResearch("Flexibility");
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}			
		Sleep(10872 + rand(12)*100);
	}
}


SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

EnvWriteInt(set, "MRomeTactic2",1);
