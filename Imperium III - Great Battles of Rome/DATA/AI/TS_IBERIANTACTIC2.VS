// void, Settlement set

int  AIPlayer;
str  cmd;
int  i;
int  nDonateFood, nDonateGold, nDonatePop, nBuildArmy, nResearch; // Variables for controlling AI
Hero hero;
Unit enchantress;
bool bHero, bEnchantress;
IntArray aSkills, aSkillLevels;
ObjList olMountaineers,olEnchantress;
int heroScId;
bool bHeroScStart = false;

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
//SetAIVar(AIPlayer, AIV_DonatePop,  0);
SetAIVar(AIPlayer, AIV_BuildArmy,  0);
SetAIVar(AIPlayer, AIV_Research,   0);

aSkills[0] = hsEuphoria;      aSkillLevels[0] = 10;
aSkills[1] = hsTeamDefense;   aSkillLevels[1] = 10;
aSkills[2] = hsHealing;       aSkillLevels[2] = 10;
aSkills[3] = hsEpicEndurance; aSkillLevels[3] = 10;
aSkills[4] = hsCeasefire;     aSkillLevels[4] = 10;

Sleep(rand(2345));
// Upgrade "Free Drinks".
set.TSResearch("Free Drinks");

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
		Sleep(5234 + rand(20)*100);
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

// When researched 'Free Drinks' sell 1000 food
{
	bool bFreeDrinks = false;
	while (!bFreeDrinks || set.food<1000 )
		{
			bFreeDrinks = set.TSResearch("Free Drinks");
			Sleep(5023 + rand(20)*100);			
		}
}	
// If food supplies are more than 1000 then sell 1000 food again. 
if (set.food>1000)
	set.TSResearch("Sell food");	
// Allow AI to use food
SetAIVar(AIPlayer, AIV_DonateFood, nDonateFood); // Return variable to its value

if (EnvReadInt(set,"StopTacticScript") == 1)
{
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	
	if (!hero.IsDead)
		hero.SetNoAIFlag(false);
	if (!enchantress.IsDead)
		enchantress.SetNoAIFlag(false);
	
	olEnchantress.ClearDead();
	SetNoAIFlag(olEnchantress,false);
	return;
}

// Research Tournaments and start  hireing mountaineesrs
{
	ObjList ol,olSpies;
	int nCount = 7;
	
	set.TSResearch("Tournaments");
	while (olSpies.count<3) // Research 3 mountaineers and send them to spy
	{
		Sleep(5234 + rand(20)*100);
		set.TSResearch("Tournaments");
		ol.Clear();
		ol.AddList(set.TSArenaRecruit(3));
		ol.RemoveList(olSpies);		
		olSpies.AddList(ol);		
		olSpies.ClearDead();		
		SetNoAIFlag(olSpies, false);
		
		
		if (hero.IsValid)
		if (!bHeroScStart)
		{
			ObjList ol;
			Obj oDummy;
			ol.Add(hero);
			hero.KillCommand();			
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
			heroScId = AIRun("TS_AttackAtWill.vs", set, ol,oDummy, 0);	
			bHeroScStart = true;
		}
		
		while (set.food>1000)
			set.TSResearch("Sell food");	
	}
	
	if (EnvReadInt(set,"StopTacticScript") == 1)
	{
		AIBreakScript(heroScId);
		SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
		SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
		SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
		SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
		
		if (!hero.IsDead)
			hero.SetNoAIFlag(false);
		if (!enchantress.IsDead)
			enchantress.SetNoAIFlag(false);
		
		olEnchantress.ClearDead();
		SetNoAIFlag(olEnchantress,false);
		return;
	}
	while (olMountaineers.count < nCount) // Research 7 mountaineers
	{
		int nNeeded;
		nNeeded = nCount - olMountaineers.count;		
		olMountaineers.AddList(set.TSArenaRecruit(nNeeded));
		olMountaineers.RemoveList(olSpies);
		olSpies.ClearDead();		
		SetNoAIFlag(olSpies, false);
		while (set.food>1000)
			set.TSResearch("Sell food");	
		Sleep(5234 +rand(20)*100);
	}
	
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	AIBreakScript(heroScId);
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	
	if (!hero.IsDead)
		hero.SetNoAIFlag(false);
	if (!enchantress.IsDead)
		enchantress.SetNoAIFlag(false);
	
	olEnchantress.ClearDead();
	olMountaineers.ClearDead();
	SetNoAIFlag(olEnchantress,false);
	SetNoAIFlag(olMountaineers,false);
	return;
}
// Research 8 more enchantress
{
	int nCount = 10;
	while (olEnchantress.count < nCount) // Research 7 mountaineers
	{
		int nNeeded;
		
		nNeeded = nCount - olEnchantress.count;
		olEnchantress.AddList(set.TSTempleRecruit(nNeeded));
		while (set.food>1000)
			set.TSResearch("Sell food");	

		Sleep(5234 + rand(20)*100);			
	}
}
if (EnvReadInt(set,"StopTacticScript") == 1)
{
	AIBreakScript(heroScId);
	SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
	SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
	SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
	SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
	
	if (!hero.IsDead)
		hero.SetNoAIFlag(false);
	if (!enchantress.IsDead)
		enchantress.SetNoAIFlag(false);
	
	olEnchantress.ClearDead();
	olMountaineers.ClearDead();
	SetNoAIFlag(olEnchantress,false);
	SetNoAIFlag(olMountaineers,false);
	return;
}
// Set townhall to auto-teach
set.Research("autotrain_start_i");

// Research Code of Valor & Mountain Clan
{
	bool bCodeofValor,bMountainClan;
	bCodeofValor = false;
	bMountainClan = false;
	while(!bCodeofValor || !bMountainClan)
	{
		if (!bCodeofValor)
			bCodeofValor = set.TSResearch("Code of Valor");
		if (!bMountainClan )
			bMountainClan = set.TSResearch("Mountain Clan");
		while (set.food>1000)
			set.TSResearch("Sell food");	
		if (hero.IsValid)
		if (!hero.IsDead)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			AIBreakScript(heroScId);
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			
			if (!hero.IsDead)
				hero.SetNoAIFlag(false);
			if (!enchantress.IsDead)
				enchantress.SetNoAIFlag(false);
			
			olEnchantress.ClearDead();
			olMountaineers.ClearDead();
			SetNoAIFlag(olEnchantress,false);
			SetNoAIFlag(olMountaineers,false);
			return;
		}
		Sleep(5234 + rand(20)*100);			
	}
}
// Research Mountain Clan Legacy & Ancestral Knowladge
{
	bool bAncKnowledge,bMountainClanLegacy;
	bAncKnowledge = false;
	bMountainClanLegacy = false;
	while(!bAncKnowledge || !bMountainClanLegacy)
	{
		if (!bAncKnowledge)
			bAncKnowledge = set.TSResearch("Ancestral Knowledge");
		else
		{
			if (hero.IsValid)
			if (!hero.IsDead)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
		}

		if (!bMountainClanLegacy )
			bMountainClanLegacy = set.TSResearch("Mountain Clan Legacy");
		while (set.food>1000)
			set.TSResearch("Sell food");	
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			AIBreakScript(heroScId);
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			
			if (!hero.IsDead)
				hero.SetNoAIFlag(false);
			if (!enchantress.IsDead)
				enchantress.SetNoAIFlag(false);
			
			olEnchantress.ClearDead();
			olMountaineers.ClearDead();
			SetNoAIFlag(olEnchantress,false);
			SetNoAIFlag(olMountaineers,false);
			return;
		}
		Sleep(5234 +rand(20)*100);			
	}
}
AIBreakScript(heroScId);
if (hero.IsValid)
if (hero.IsAlive)
{
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
	hero.SetCommand("enter", set.GetCentralBuilding());
}
// Train 10 more Mountaineers
{
	int nCount = 20;
	while (olMountaineers.count < nCount && Count(AIPlayer, "IMountaineer")<nCount) 
	{
		int nNeeded;
		
		nNeeded = nCount - olMountaineers.count;
		olMountaineers.AddList(set.TSArenaRecruit(nNeeded));
		
		while (set.food>1000)
			set.TSResearch("Sell food");				
		if (hero.IsValid)
		if (!hero.IsDead)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);	
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			
			if (!hero.IsDead)
				hero.SetNoAIFlag(false);
			if (!enchantress.IsDead)
				enchantress.SetNoAIFlag(false);
			
			olEnchantress.ClearDead();
			olMountaineers.ClearDead();
			SetNoAIFlag(olEnchantress,false);
			SetNoAIFlag(olMountaineers,false);
			return;
		}
		Sleep(5234 +rand(20)*100);			
	}
}

// Train Barack Level 1 and Spears
{
	bool bBarrack1,bSpears;
	bBarrack1 = false;
	bSpears = false;
	while(! bBarrack1 || !bSpears)
	{
		if (! bBarrack1)
			 bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bSpears )
			bSpears = set.TSResearch("Spears");
		if (EnvReadInt(set,"StopTacticScript") == 1)
		{
			SetAIVar(AIPlayer, AIV_DonateGold, nDonateGold); // Return variable to its value
			SetAIVar(AIPlayer, AIV_DonatePop,  nDonatePop); // Return variable to its value
			SetAIVar(AIPlayer, AIV_BuildArmy,  nBuildArmy); // Return variable to its value
			SetAIVar(AIPlayer, AIV_Research,  nResearch); // Return variable to its value
			
			if (!hero.IsDead)
				hero.SetNoAIFlag(false);
			if (!enchantress.IsDead)
				enchantress.SetNoAIFlag(false);
			
			olEnchantress.ClearDead();
			olMountaineers.ClearDead();
			SetNoAIFlag(olEnchantress,false);
			SetNoAIFlag(olMountaineers,false);
			return;
		}
		Sleep(5234 + rand(20)*100);			
	}
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

olEnchantress.ClearDead();
olMountaineers.ClearDead();
SetNoAIFlag(olEnchantress,false);
SetNoAIFlag(olMountaineers,false);

EnvWriteInt(set, "InitialTactic2",1);