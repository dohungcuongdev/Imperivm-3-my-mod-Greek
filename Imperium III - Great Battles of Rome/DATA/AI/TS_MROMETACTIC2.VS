// void, Settlement set
int  AIPlayer;
int  i,gold,food;
ObjList olHastati,olArchers,olPriests, olPrinciples,olSpies;

int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
bool bAssUnderFire;
int heroScId;
bool bHeroSc = false;

if (EnvReadInt(set, "MRomeTactic2") == 1) 
	return;

if (EnvReadInt(set,"StopTacticScript") == 1)
	return;

bAssUnderFire	 = false;

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

//set.TSResearch("Roman Praetorian");
//EnvWriteString(set, "Roman Praetorian", "researched");

// gladiator shows & 4 hastati & inc pop & military accademy
{
	ObjList ol;
	bool bGladiatorShow = false;
	bool bMilAcademy    = false;
	int nSpies  = 4;
	int nIncPop = 0;
	while (!bGladiatorShow || olSpies.count<nSpies || nIncPop<1 || !bMilAcademy)
	{
		if (!bGladiatorShow)	
			bGladiatorShow = set.TSResearch("RGladiator Shows2");

		if (bGladiatorShow &&!bMilAcademy)
			bMilAcademy = set.TSResearch("Military Academy");

		if (olSpies.count<nSpies)
		{
			ol.Clear();
			ol.AddList(set.TSRecruitArmy("RHastatus",nSpies));
			ol.RemoveList(olSpies);		
			olSpies.AddList(ol);		
			olSpies.ClearDead();		
			SetNoAIFlag(olSpies, false);		
		}
		if (nIncPop<1 && set.food>=800)
		{
			set.TSResearch("MAddPop");
			nIncPop+=1;
		}
		
		Sleep(5472 + rand(10)*100);
	}
}

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// set AI vars	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

//barrack level 1 & hero
{
	bool bBarrack1 = false;
	while (!bBarrack1 || !hero.IsValid())
	{
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!hero.IsValid())
			hero = set.TSRecruitHero();
	
		Sleep(3472 + rand(10)*100);
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// give army to AI
	hero.SetNoAIFlag(false);
	// set AI vars	
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

// 30 more hastati
{
	int nHastati = 34;
	while (olHastati.count<nHastati)
		{
			int nCount;
			nCount = nHastati - olHastati.count;
			olHastati.AddList(set.TSRecruitArmy("RHastatus",nCount));
			Sleep(5472 + rand(10)*100);	
		}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Break script
	if (bHeroSc)
		AIBreakScript(heroScId);
	// give army to AI
	hero.SetNoAIFlag(false);
	olHastati.ClearDead();
	SetNoAIFlag(olHastati, false);
	// set AI vars	
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

// attach to hero attack outposts
if (hero.IsValid() )
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

//standartization 1, standartization 2, felxibility
{
	bool bStandartization = false;
	bool bStandartization2 = false;
	bool bFlexability = false;
	while (!bStandartization || !bStandartization2 || !bFlexability)
	{
		if (!bStandartization)	
			bStandartization = set.TSResearch("Standartization I");
		
		if (bStandartization && !bStandartization2)	
			bStandartization2 = set.TSResearch("Standartization II");
		
		if (bStandartization && bStandartization2 &&!bFlexability)	
			bFlexability = set.TSResearch("Flexibility");

		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			// Break script
			if (bHeroSc)
				AIBreakScript(heroScId);
			// give army to AI
			hero.SetNoAIFlag(false);
			olHastati.ClearDead();
			SetNoAIFlag(olHastati, false);
			// set AI vars	
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		Sleep(10671 + rand(10)*100);
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
			Sleep(7675 + rand(10)*100);
		}
}

SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Break script
	if (bHeroSc)
		AIBreakScript(heroScId);
	// give army to AI
	hero.SetNoAIFlag(false);
	olHastati.ClearDead();
	SetNoAIFlag(olHastati, false);
	// set AI vars	
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
			Sleep(4472 + rand(10)*100);
		}
}
if (hero.IsValid())
if (hero.IsAlive)
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	


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
SetNoAIFlag(olArchers,false);
SetNoAIFlag(olHastati,false);

SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value

EnvWriteInt(set, "MRomeTactic2",1);
