// void, Settlement set

int  AIPlayer;
str  cmd;
int  i,gold,food;
ObjList olBowmen,olSpearmen, olJavelineers;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;
bool bWinGambling = false;

if (EnvReadInt(set, "BritishTactic") == 1) 
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
//SetAIVar(AIPlayer, AIV_DonatePop,  0);
SetAIVar(AIPlayer, AIV_BuildArmy,  0);
SetAIVar(AIPlayer, AIV_Research,   0);

// Set skills
	aSkills[0] = hsCharge;      aSkillLevels[0] = 10;
	aSkills[1] = hsAssault;     aSkillLevels[1] = 10;

// hire hero & 3xswordsmen & bronze spears
{
	bool bSpears = false;
	int i = 0;
	cmd = "trainBSwordsman";

	while (!hero.IsValid || !bSpears || i<3)
	{
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bSpears)
			bSpears = set.TSResearch("Britain Spears");
		if (i<3)
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
		Sleep(5543+rand(10)*100);
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// give army to AI
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
	// Set Varibles
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

// barrack level 1 & gambling
{
	bool bBarrack1 = false;
	bool bGambling = false;
	int gold;
	gold = set.gold;
	while(!bBarrack1 || !bGambling)
	{
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bGambling)
		{
			gold = set.gold;
			bGambling = set.TSResearch("Gambling");
			if (bGambling)
			  bWinGambling = (set.gold-gold)>4000;
		}
		Sleep(6543+rand(10)*100);
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Stop script
	if (bHeroSc)
		AIBreakScript(heroScId);
	
	// give army to AI
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
	// Set Varibles
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}

if (hero.IsAlive)
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
if (bWinGambling)
{
	// Fights & barrack level 2 & javelins
	{
		bool bFights = false;
		bool bBarrack2 = false;
		bool bJavelins = false;
		while(!bFights || !bBarrack2 || !bJavelins)
		{
			if (!bFights)
				bFights = set.TSResearch("Britain Fights");
			if (!bBarrack2)
				bBarrack2 = set.TSResearch("BBarrack Level 2");
			if (!bJavelins)
				bJavelins = set.TSResearch("Britain Javelins");
			
		Sleep(7543+rand(10)*100);
		}
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	// Stop script
	if (bHeroSc)
		AIBreakScript(heroScId);
	
	// give army to AI
	if (hero.IsValid)
		hero.SetNoAIFlag(false);
	// Set Varibles
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
	return;
}
if (hero.IsAlive)
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	

{
	// 20 archers, 20 spearmen , javelins 10 javelineers
	int nBowmen = 20;
	int nSpearmen = 20;
	int nJavelineers = 10;
	bool bJavelins = false;
	while (olBowmen.count<nBowmen || olSpearmen.count<nSpearmen || olJavelineers.count<nJavelineers || !bJavelins)
	{
		int nCount;
		if (!bJavelins)
			bJavelins = set.TSResearch("Britain Javelins");
		if (olBowmen.count<nBowmen)
		{
			nCount = 	nBowmen - olBowmen.count;
			olBowmen.AddList(set.TSRecruitArmy("BBowman",nCount));	
		}

		if (olSpearmen.count<nSpearmen)
		{
			nCount = 	nSpearmen - olSpearmen.count;
			olSpearmen.AddList(set.TSRecruitArmy("BBronzeSpearman",nCount));	
		}

		if (olJavelineers.count<nJavelineers)
		{
			nCount = 	nJavelineers - olJavelineers.count;
			olJavelineers.AddList(set.TSRecruitArmy("BJavelineer",nCount));	
		}
		
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			// Stop script
			if (bHeroSc)
				AIBreakScript(heroScId);
			
			// give army to AI
			if (hero.IsValid)
				hero.SetNoAIFlag(false);
			olBowmen.ClearDead();
			olSpearmen.ClearDead();
			olJavelineers.ClearDead();
			SetNoAIFlag(olBowmen,false);
			SetNoAIFlag(olSpearmen,false);
			SetNoAIFlag(olJavelineers,false);

			// Set Varibles
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		Sleep(9543+rand(10)*100);
	}
		
}
//Give army to AI
if (bHeroSc)
	AIBreakScript(heroScId);
	
if (hero.IsValid)
if (hero.IsAlive)
{
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	hero.SetCommand("enter", set.GetCentralBuilding() );
	hero.SetNoAIFlag(false);
}

olBowmen.ClearDead();
olSpearmen.ClearDead();
olJavelineers.ClearDead();
SetNoAIFlag(olBowmen,false);
SetNoAIFlag(olSpearmen,false);
SetNoAIFlag(olJavelineers,false);

SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value

if (bWinGambling) // Gambler's test Research Swords
{
	bool bSwords = false;
	bool bGamblersTest = false;
	while(!bSwords || !bGamblersTest)
	{
		if(!bSwords)
			bSwords = set.TSResearch("Britain Swords");
		if(!bGamblersTest)
			bGamblersTest = set.TSResearch("Gambler's Test");

		Sleep(10543+rand(10)*100);
	}
}
else// Research Swords
{
	bool bSwords = false;
	while(!bSwords)
	{
		bSwords = set.TSResearch("Britain Swords");
		Sleep(10543+rand(10)*100);
	}
}

// Allow AI to spend gold and build army
SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

EnvWriteInt(set, "BritishTactic",1);
