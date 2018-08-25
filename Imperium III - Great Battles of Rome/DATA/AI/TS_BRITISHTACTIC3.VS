// void, Settlement set

int  AIPlayer;
str  cmd;
int  i,gold,food;
ObjList olBowmen, olHighlanders, olJavelineers;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;
bool bWinGambling = false;

if (EnvReadInt(set, "BritishTactic3") == 1) 
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

// hire hero & 3xswordsmen & Highlander's swords
{
	bool bSwords = false;
	int i = 0;
	cmd = "trainbSwordsman";

	while (!hero.IsValid || !bSwords || i<3)
	{
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bSwords)
			bSwords = set.TSResearch("Britain Swords");
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
		//Sleep(5543+rand(10)*100);
		Sleep(500);
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

// barrack level 1,2,3 & gambling
{
	bool bBarrack1 = false;
	bool bBarrack2 = false;
	bool bBarrack3 = false;
	bool bGambling = false;
	int gold;
	gold = set.gold;
	while(!bBarrack1 || !bBarrack2 || !bBarrack3 || !bGambling)
	{
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (bBarrack1 && !bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack1 && bBarrack2 && !bBarrack3)
			bBarrack3 = set.TSResearch("Barrack Level 3");
		if (!bGambling)
		{
			gold = set.gold;
			bGambling = set.TSResearch("Gambling");
			if (bGambling)
			  bWinGambling = (set.gold-gold)>4000;
		}
		//Sleep(6543+rand(10)*100);
		Sleep(500);
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
	// Fights & javelins
	{
		bool bFights = false;
		bool bJavelins = false;
		while(!bFights || !bJavelins)
		{
			if (!bFights)
				bFights = set.TSResearch("Britain Fights");
			if (!bJavelins)
				bJavelins = set.TSResearch("Britain Javelins");
			
		//Sleep(7543+rand(10)*100);
		Sleep(500);
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
	// 20 archers, 300 Highlanders , javelins 10 javelineers
	int nBowmen = 20;
	int nHighlanders = 300;
	int nJavelineers = 10;
	bool bJavelins = false;
	while (olBowmen.count<nBowmen || olHighlanders.count<nHighlanders || olJavelineers.count<nJavelineers || !bJavelins)
	{
		int nCount;
		if (!bJavelins)
			bJavelins = set.TSResearch("Britain Javelins");
		if (olBowmen.count<nBowmen)
		{
			nCount = 	nBowmen - olBowmen.count;
			olBowmen.AddList(set.TSRecruitArmy("BBowman",nCount));	
		}

		if (olHighlanders.count<nHighlanders)
		{
			nCount = 	nHighlanders - olHighlanders.count;
			olHighlanders.AddList(set.TSRecruitArmy("BHighlander",nCount));	
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
			olHighlanders.ClearDead();
			olJavelineers.ClearDead();
			SetNoAIFlag(olBowmen,false);
			SetNoAIFlag(olHighlanders,false);
			SetNoAIFlag(olJavelineers,false);

			// Set Varibles
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value
			return;
		}
		//Sleep(9543+rand(10)*100);
		Sleep(500);
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
olHighlanders.ClearDead();
olJavelineers.ClearDead();
SetNoAIFlag(olBowmen,false);
SetNoAIFlag(olHighlanders,false);
SetNoAIFlag(olJavelineers,false);

SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value

//if (bWinGambling) // Gambler's test Research Swords
{
	bool bGamblersTest = false;
	while(!bGamblersTest)
	{
		if(!bGamblersTest)
			bGamblersTest = set.TSResearch("Gambler's Test");

		//Sleep(10543+rand(10)*100);
		Sleep(500);
	}
}

// Allow AI to spend gold and build army
SetAIVar(AIPlayer, AIV_Research,   nResearch); // Return variable to its value

EnvWriteInt(set, "BritishTactic3",1);
