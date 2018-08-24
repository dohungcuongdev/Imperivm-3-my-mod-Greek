// void, Settlement set
	
int  AIPlayer;
str  cmd;
int  i,gold,food;
bool bFirstSellFood;
ObjList olArchers,olDefenders, olEnchantress;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
Unit enchantress;
bool bHero, bEnchantress;
IntArray aSkills, aSkillLevels;
int heroScId;
bool bHeroSc = false;

if (EnvReadInt(set, "InitialTactic2") == 1) 
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
SetAIVar(AIPlayer, AIV_DonatePop,  0);
SetAIVar(AIPlayer, AIV_BuildArmy,  0);
SetAIVar(AIPlayer, AIV_Research,   0);

// Iberian initial tactic 
aSkills[0] = hsEuphoria;      aSkillLevels[0] = 4;
aSkills[1] = hsTeamDefense;   aSkillLevels[1] = 5;
aSkills[2] = hsHealing;       aSkillLevels[2] = 10;
aSkills[3] = hsEpicEndurance; aSkillLevels[3] = 3;

Sleep(rand(2345));
// Upgrade "Free Drinks".
set.TSResearch("Free Drinks");

// Train 3 Militiamen and send them to spy around the stronghold
cmd = "trainIMilitiaman";
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

// Hire a hero and a couple of Enchantresses 
{
	point ptExit;
	
  ptExit.Set(0,0);
	ptExit.SetLen(set.GetCentralBuilding.radius + 100);
	ptExit = ptExit + set.GetCentralBuilding.pos;

	while (!hero.IsValid() || !enchantress.IsValid)
	{
		if (!hero.IsValid())
			{
				hero = set.TSRecruitHero();
				if (hero.IsValid)
					hero.SetCommand("move", ptExit);
			}
		if (!enchantress.IsValid)
		{
			int nCount;
			nCount =2-olEnchantress.count;
			olEnchantress.AddList(set.TSTempleRecruit(nCount));
			if (olEnchantress.count >0) 
			if (olEnchantress[0].IsValid())
				enchantress = olEnchantress[0];
		}
		Sleep(5023 + rand(24)*100);			
}
	
	if (hero.IsValid)
	if (enchantress.IsValid)
	{
		if (hero.pos!=ptExit)
			hero.SetCommand("move", ptExit);
		Sleep(500 + rand(24)*100);
		if (hero.IsValid)
		if (hero.pos.x!=-1 && hero.pos.y!=-1)
			enchantress.SetCommand("move", hero.pos); 
		hero.AddCommand(false,"stand_position"); 
		enchantress.AddCommand(false, "teach", hero);
	}
}
// Set townhall to auto-teach
set.Research("autotrain_start_i");

// When researched 'Free Drinks' sell 1000 food
{
	bool bFreeDrinks = false;
	while (!bFreeDrinks || set.food<1000 )
		{
			bFreeDrinks = set.TSResearch("Free Drinks");
			Sleep(5023 + rand(24)*100);			
		}
}	
// If food supplies are more than 1000 then sell 1000 food again. 
if (set.food>1000)
	set.TSResearch("Sell food");	
// Allow AI to use food
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	AIBreakScript(heroScId);
	if (!hero.IsDead)
		hero.SetNoAIFlag(false);
	if (!enchantress.IsDead)
	enchantress.SetNoAIFlag(false);
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	olEnchantress.ClearDead();
	SetNoAIFlag(olEnchantress,false);
	return;
}

// Research "Fastest warrior equipment". At the same time research "Spears" upgrade
{
	bool bBarrack1 = false;
	bool bSpears = false;
	while (!bBarrack1 || !bSpears)
	{	
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");	
		if (!bSpears)
			bSpears = set.TSResearch("Spears");	
			
		Sleep(1023 + rand(24)*100);			
	}
}
// Train 20 Archers && Train 20 Defenders
{
	int nArchers; 
	int nDefenders;
	nArchers   = 20; 
	nDefenders = 20;
	while (olArchers.count < nArchers || olDefenders.count < nDefenders)
	{
		int nCount;
		if (olArchers.count < nArchers)
		{
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("IArcher",nCount));	
		}
		if (olDefenders.count < nDefenders)
		{
			nCount = nDefenders - olDefenders.count;
			olDefenders.AddList(set.TSRecruitArmy("IDefender",nCount));	
		}
		if (hero.IsValid)
		if (hero.inherentlevel>=4 && !bHeroSc)
		{
			ObjList ol;
			Obj oDummy;
			ol.Add(hero);
			hero.KillCommand();
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
			heroScId = AIRun("TS_AttackAtWill.vs", set, ol,oDummy, 0);	
			bHeroSc = true;
		}
		olArchers.SetCommand("enter", set.GetCentralBuilding);
		olDefenders.SetCommand("enter", set.GetCentralBuilding);    

			if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			AIBreakScript(heroScId);
			if (!hero.IsDead)
				hero.SetNoAIFlag(false);
			if (!enchantress.IsDead)
			enchantress.SetNoAIFlag(false);
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			olArchers.ClearDead();
			olDefenders.ClearDead();
			olEnchantress.ClearDead();
			SetNoAIFlag(olArchers,false);
			SetNoAIFlag(olDefenders,false);
			SetNoAIFlag(olEnchantress,false);
			
			return;
		}
		Sleep(5023 + rand(24)*100);			
	}
}
if (hero.IsAlive)// new skill
	{
		if (hero.inherentlevel>=29)// new skill
		{
			aSkills[0] = hsTeamDefense;   aSkillLevels[0] = 10;
			aSkills[1] = hsEuphoria;      aSkillLevels[1] = 10;
			aSkills[2] = hsEpicEndurance; aSkillLevels[2] = 10;
			aSkills[3] = hsCeasefire;     aSkillLevels[3] = 10;
		}

		hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	}

// Train 3 Enchantress
while (olEnchantress.count < 5)
{
	int nCount;
	nCount = 5 - olEnchantress.count;
	olEnchantress.AddList(set.TSTempleRecruit(nCount));
	Sleep(5023 + rand(24)*100);			
}

// Attach army to hero
AIBreakScript(heroScId);
if (hero.IsValid)
if (hero.IsAlive)
{
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	hero.SetCommand("enter", set.GetCentralBuilding() );
	olArchers.SetCommand("attach", hero);
	olDefenders.SetCommand("attach", hero);
	olEnchantress.SetCommand("attach", hero);
}
// Allow AI to spend gold and build army
SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value


if (!hero.IsDead)
	hero.SetNoAIFlag(false);
if (!enchantress.IsDead)
	enchantress.SetNoAIFlag(false);

olArchers.ClearDead();
olDefenders.ClearDead();
olEnchantress.ClearDead();
SetNoAIFlag(olArchers,false);
SetNoAIFlag(olDefenders,false);
SetNoAIFlag(olEnchantress,false);

EnvWriteInt(set, "InitialTactic2",1);
