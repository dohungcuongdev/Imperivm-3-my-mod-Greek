// void, Settlement set

int AIPlayer, i, nRace;
int nAssUnderFire;
int nDonateFood, nDonateGold, nDonatePop;
str strTech = "";
bool bLogResearch = false;
StrArray strTechMarket; /// market first upgrades names
IntArray pbTechMarket;  /// market first upgrades
bool bForceResearch = false;
bool bWantTribute = false;
int nMilUnits, nFoodReserve;
point ptDummy; Obj objDummy;

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;
nAssUnderFire = EnvReadInt(set, "AssUnderFire");         /// set in "ES_Stronghold.vs"
nDonateFood = AIVar(AIPlayer, AIV_DonateFood);
nDonateGold = AIVar(AIPlayer, AIV_DonateGold);
nDonatePop = AIVar(AIPlayer, AIV_DonatePop);
bLogResearch = (AIVar(AIPlayer, AIV_LogResearch) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);
nMilUnits = MilUnits(AIPlayer);
nFoodReserve = EnvReadInt(set, "nFoodReserve");

strTechMarket[0] = "Free Beer";
strTechMarket[1] = "Free Wine";
strTechMarket[2] = "Free Trade";
strTechMarket[3] = "Free Drinks";
strTechMarket[4] = "Trade Routes";       //Modificato => In GreekMod, 4 = Grecia, che sostituisce Roma Imperiale.
strTechMarket[5] = "Gambling";
strTechMarket[6] = "GrainTrade";
strTechMarket[7] = "TGrainTrade";

for (i = 0; i < 8; i += 1)
{
	if (IsResearched(set, strTechMarket[i]))
		pbTechMarket[i] = 1;
	else
		pbTechMarket[i] = 0;
}
/// gold -> food. "Buy food" - instant
if (nDonateGold > 0)
if (set.gold > set.food)
if (set.food < 2000)
{
	bool bBuyFood = false;
	str cmd = "buyfoodforgold";
	if (nRace == Germany) 
	{
		if (set.gold > 3 * set.food || rand(3) == 2)
		if (IsResearched(set, "TGrainTrade")) if (IsResearched(set, "TFoodTax")) if (IsResearched(set, "TFights"))
			bBuyFood = true;
	} else 
	{
		if (rand(3) == 2)
		if (set.food < 100)
			bBuyFood = true;
	}
	if (bBuyFood)
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd))
		set.Research(cmd); 
}

if (pbTechMarket[nRace] == 0)
if (set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount))
	strTech = strTechMarket[nRace];

/*
/// gold -> health. "CHeal" - intsant -> Carthage
if (nDonateGold > 0)
if (nAssUnderFire > 0)
if (rand(3) == 2)
if (set.CanResearch("CHeal"))
if (set.CanAfford("CHeal"))
{
	/// this is an instant command
	ObjList ol;
	int i, j, nHealth, nMaxHealth;
	nHealth = 0;
	nMaxHealth = 0;
	ol = set.ObjectsAround("Unit");
	ol.Remove(ol.ObjEnemy(AIPlayer));
	ol.Remove(ol.ObjClass("Peaceful"));

	for (i = 0; i < ol.count; i += 1)
	{
		Unit u;
		u = ol[i].AsUnit;
		if (u.IsAlive)
		{
			nHealth += u.health;
			nMaxHealth += u.maxhealth;
			if (u.AsHero.IsValid)
				for (j = 0; j < u.AsHero.army.count; j += 1)
				{
					Unit u2;
					u2 = u.AsHero.army[j].AsUnit;
					if (u2.IsAlive)	{
						nHealth += u.health;
						nMaxHealth += u.maxhealth;
					}
				}
		}
	}
	if (nMaxHealth - nHealth >= 2000)
	{
		Query ProtectiveArea;
		Query EnemyUnits;
		ProtectiveArea = ObjsInSight(set.GetCentralBuilding,"Unit");
		EnemyUnits = Intersect(ProtectiveArea, EnemyObjs(AIPlayer, "Unit"));
		if (EnemyUnits.count > 0)	{
			set.Research("Heal");
			if (bLogResearch)
				pr("Player " + AIPlayer + "research Heal");
			return;
		}
	}
}
*/

//gold->stamina/health -  "refreshment" Gaul,Britain, "heal" Iberia- Townhall
if (nDonateGold > 0)
if (rand(2) == 1)
if (nRace==Gaul || nRace==Britain || nRace==Iberia)
//if (nAssUnderFire > 0)
{
	Query qAll,qEnemy,qAlly;
	ObjList ol,olEnemy,olAlly;
	int i, j, nHealth, nMaxHealth, nStamina, nMaxStamina;
	str cmd;
  int ownEval,allyEval,enemyEval;
  int dEval;
  Building bld;
  
  if (bLogResearch)
  	pr (set.player+" research");
	 
	bld = set.GetCentralBuilding;
	cmd = "";
	nHealth     = 0;
	nMaxHealth  = 0;
	nStamina    = 0;
 	nMaxStamina = 0;

  if (bld.IsValid)
	{
		int bldRange;
		bldRange = (3*bld.sight)/2;
		
		qAll    = Union(ObjsInRange(bld,"Military",bldRange),ObjsInRange(bld,"BaseMage",bldRange));
		qEnemy  = Intersect(qAll,Union(EnemyObjs(set.player,"Military"),EnemyObjs(set.player,"BaseMage")));
		olAlly  = Subtract(qAll, qEnemy).GetObjList();
		
		if (qEnemy.count>0)
	  {
	  	Eval(set.player, bld.pos, bldRange, ownEval, allyEval, enemyEval);
	  	dEval = ownEval + allyEval - enemyEval;
	  
		  if ((dEval >=-500 && dEval<=500) || ownEval+allyEval < 2*enemyEval)
			{
			    if (bLogResearch)
					{
						pr (set.player+" eval " + dEval);
						pr (set.player+" enemy " + qEnemy.count);
					}
		
					for (i = 0; i < olAlly.count; i += 1)
					{
						Unit u;
						u = olAlly[i].AsUnit;
						if (u.IsAlive)
						{
							nHealth += u.health;
							nMaxHealth += u.maxhealth;
							nStamina += u.stamina;
							nMaxStamina +=u.maxstamina;
							if (u.AsHero.IsValid)
								for (j = 0; j < u.AsHero.army.count; j += 1)
								{
									Unit u2;
									u2 = u.AsHero.army[j].AsUnit;
									if (u2.IsAlive)	
									{
										nHealth += u2.health;
										nMaxHealth += u2.maxhealth;
										nStamina += u2.stamina;
										nMaxStamina +=u2.maxstamina;
									}
								}
						}
					}
				if (nRace==Gaul || nRace==Britain)
				{
					if (nStamina<=nMaxStamina/2)
					  {
					  	if (bLogResearch)
					  		pr (set.player+" refreshment");
							cmd = "refreshment";
						}
				}
				else if (nRace==Iberia)
				{
					if (nHealth<=nMaxHealth/2)
					{
					  	if (bLogResearch)
							  pr (set.player+" refreshment");
							cmd = "heal";
					}
				}
			
				if (cmd!="")
				if (set.CanAfford(cmd))
					{
						set.Research(cmd);
						if (bLogResearch)
							pr (set.player + "exec "+ cmd);
						return;
					}
			}
		}
}	
}
/**/
/// gold -> gold. "Tribute" -> All races
if (nDonateGold > 0)
if (strTech == "")
if (nAssUnderFire <= 0)
if (AIVar(AIPlayer, AIV_Tribute) != 0)
if (EnvReadString(AIPlayer, "Tribute") == "")
{
	Building bld;
	str cmd;
	cmd = GetRaceStrPref(set.GetCentralBuilding.race) + "Tribute";
	bld = set.FindResearchLab(cmd);
	if (bld.IsValid)
	if (bld.CmdCount(cmd) < 1)
	{
		int nOutposts, nProfit = 0, nNextTime = 0, nNextProfit = 0, gold = 0;
		nOutposts = Outposts(AIPlayer);
		{
			int i;
			int delay;
			int time;
			str times, values;
			
			times = GetConstStr("TributeTimes");
			values = GetConstStr("TributeGold");
			delay = GetConst("TributeDuration") * 1000;
			
			i = GetTime() + delay;
			
			while (times != "") 
			{
				int old_gold;
				old_gold = gold;
				time = Str2Int(ParseStr(times, times)) * 60000;
				gold = Str2Int(ParseStr(values, values));
				nNextProfit = gold;
				if (i < time) 
				{
					gold = old_gold;
					break;
				}
			}
			nProfit = gold * nOutposts;
			nNextProfit = nNextProfit * nOutposts;
			GetCmdCost(cmd, gold, i);
			nProfit -= gold;
			nNextProfit -= gold;
			nNextTime = time;
		}
		if (nProfit >= 2000)
		if (nProfit >= set.gold || gold >= 2000)
		if (nNextProfit <= nProfit || GetTime + 60 * (nNextProfit - nProfit) < nNextTime)
		{
			int nIndependent, nAll;
			nAll = Outposts(0); /// All Outposts
			nIndependent = Outposts(15) + Outposts(16); /// VX_PLAYER_NEUTRAL + VX_PLAYER_RESCUE
			if (nIndependent < nAll / 10 || nProfit >= 5000)
			{
				bWantTribute = true;
				bForceResearch = true;
				EnvWriteInt(set, "FreezeArmyBuild", 10);
				if (pbTechMarket[nRace] == 0)
					strTech = strTechMarket[nRace];
				else
				{
					Building bld;
					strTech = cmd;
					bld = set.FindResearchLab(cmd);
					if (bld.IsValid)
					if (set.CanAfford(cmd, 1))
					{
						bld.ExecCmd(cmd, ptDummy, objDummy, false);
						strTech = "";
						bForceResearch = false;
						if (cmd == EnvReadString(set, "ReserveFor" + (AIPlayer - 1)))
						{
							set.StopReserving;
							EnvWriteInt(set, "ReserveCounter", 0);
						}
					}
				}
			}
		}
	}
	if (!bWantTribute)
	if (cmd == EnvReadString(set, "ReserveFor" + (AIPlayer - 1)))
	{
		set.StopReserving;
		EnvWriteInt(set, "ReserveCounter", 0);
	}
}

/// "Investment" -> Rome
if (nDonateGold > 0) 
if (strTech == "")
if (rand(3)==2)
if (nAssUnderFire <= 0)
if (nRace == RepublicanRome)
if (GetTime > 120000)
{
	bool bTribute, bRes = false;
	bTribute = EnvReadString(AIPlayer, "Tribute") != "";
	if (bTribute || AIVar(AIPlayer, AIV_Tribute) == 0 || !bWantTribute)
		bRes = true;
	if (bRes)
		if (pbTechMarket[nRace] == 0)
			strTech = strTechMarket[nRace];
		else 
		{
			Building bld;
			strTech = "investR";
			bld = set.FindResearchLab(strTech);
			if (bld.IsValid)
			if (bld.CmdCount("investR") < 1)
			{
				if (set.CanAfford(strTech, 1))
				{
					bld.ExecCmd("investR", ptDummy, objDummy, false);
					strTech = "";
					if ("investR" == EnvReadString(set, "ReserveFor" + (AIPlayer - 1)))
					{
						set.StopReserving;
						EnvWriteInt(set, "ReserveCounter", 0);
					}
				}
				if (strTech != "")
				if (set.gold > 1000)
				{
					bForceResearch = true;
					EnvWriteInt(set, "FreezeArmyBuild", 10);
				}
			}
		}
}

/// food->gold -"GrainTrade" Egypt
if (nDonateFood>0)
if (strTech=="")
if (nRace==Egypt)
if (set.food>2000)
if (rand(3)==2 || set.food>5000)
{
	str cmd; cmd = "GrainTrade";
	if (!IsResearched(set, cmd))
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd))
	if (pbTechMarket[nRace] == 0)
	{
		strTech = strTechMarket[nRace];	
		bForceResearch = true;
	}
}
///food->population "Hecatomb" - Egypt
if (nDonateFood>0)
if (strTech=="")
if (nRace==Egypt)
if (set.population<(6*set.max_population)/10)
if (set.food>3000)
{
	if (pbTechMarket[nRace] == 0)
			{
				strTech = strTechMarket[nRace];	
				bForceResearch = true;
			}
	else
		{
			int nCmdCount;
			str cmd = "Hecatomb";
			Building bld;
			if (set.CanAfford(cmd))
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid)
			if (bld.CmdCount(cmd) < 1)
				strTech = cmd;		
			if (bLogResearch)
				pr ("hecatomb");
		}
}

///gold->population "BuySlaves" - Egypt
if (nDonateGold > 0)
if (strTech=="")
if (nRace==Egypt)
if (set.population<(6*set.max_population)/10)
if (!(IsResearched(set,strTechMarket[nRace]) && set.food>3000))
if (set.gold>10000)
{
			int nCmdCount;
			str cmd = "BuySlaves";
			Building bld;
			if (set.CanAfford(cmd))
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid)
			if (bld.CmdCount(cmd) < 1) {
				strTech = cmd;
			}
			if (bLogResearch)
				pr ("buyslaves");
}


 
///food -> heal - "ReligiousFeast" - Egypt
///gold -> heal - "ReligiousFeast" - Germany
///gold -> heal - "ReligiousFeast" - Greece
if (strTech == "")
if (nMilUnits > 60)
if (rand(3)== 2)
if (  (nRace == Egypt && nDonateGold > 0 && set.food > 2000)
   || (nRace == Germany && nDonateFood > 0 && set.gold > 3000)
   || (nRace == Greece && nDonateFood > 0 && set.gold > 3000) )
{
	str cmd;
	if (nRace == Egypt)   cmd = "ReligiousFeast";
	if (nRace == Germany) cmd = "TReligiousFeast";
	
	if(nRace == Greece)
	{
		cmd = "HReligiousFeast";
	}	//Fine if.
		
	if (!IsResearched(set, cmd))
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd)) {
		if (pbTechMarket[nRace] == 0)
			strTech = strTechMarket[nRace];
		else
			strTech = cmd;
	}
}
/// gold -> food -"TGrainTrade"  - Germany
if (nDonateGold > 0)
if (strTech=="")
if (nRace==Germany)
if (IsResearched(set, "TFights"))
if (set.gold > set.food)
if (set.food < AIVar(AIPlayer, AIV_SquanderFoolAmount))
{
	str cmd = "TGrainTrade";
	if (!IsResearched(set, cmd))
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd))
	if (pbTechMarket[nRace] == 0)
	{
		strTech = strTechMarket[nRace];
		bForceResearch = true;
	}
}

/// gold -> food production - "TFoodTax" - Germany
if (nDonateGold > 0)
if (strTech == "")
if (nRace == Germany)
if (set.gold > AIVar(AIPlayer, AIV_ExcessGold) || ((set.food < 2000 || set.gold > 10000) && GetTime > 600000))
{
	str cmd;
	cmd = "TFoodTax";

	if (!IsResearched(set, cmd))
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd))
	if (pbTechMarket[nRace]==0)
		strTech = strTechMarket[nRace];
	else
		strTech = cmd;
}

/// gold -> food -"TFights"  - Germany. It is doubled in the arena but it is ok
if (nDonateGold > 0)
if (strTech == "")
if (nRace == Germany)
if (set.food < 2000)
{
	str cmd = "TFights";
	if (!IsResearched(set, cmd))
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd))
	{
		strTech = cmd;
		bForceResearch = true;
	}
}

/// gold -> population "Free Trade" -> Carthage
if (nDonateGold > 0)
if (strTech == "")
if (GetTime>120000)
if (set.population < set.max_population * 6 / 10)
{
	str cmd = "Free Trade";
	if (pbTechMarket[nRace] == 0)
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd))		
			strTech = strTechMarket[nRace];
}

/// gold -> max population. "Housing" -> Iberia
if (nDonateGold > 0)
if (strTech == "")
if (set.population > set.max_population * 9 / 10)
{
	str cmd = "Housing";
	if (!IsResearched(set, cmd))
	if (set.CanResearch(cmd))
	if (set.CanAfford(cmd))
		if (pbTechMarket[nRace] == 0)
			strTech = strTechMarket[nRace];
		else
			strTech = cmd;
}

// food -> population, Increese population -> Gaul, Rome, Iberia, Britain, Germany, GREECE
/// the upgrade is not avalable for Carthage and a massage is logged on the screen about "CAddPop"
if (nDonateFood > 0)
if (rand(2) == 0)
if (nRace == Gaul || nRace == RepublicanRome || nRace == Iberia || nRace == Britain || nRace == Germany || nRace == Greece)
{
	Building bld;
	int nCmdCount, nExpectedPop;
	bool bResearch;
	str cmd; cmd = set.GetCentralBuilding.raceStrPref + "AddPop";
	bld = set.FindResearchLab(cmd);
	bResearch = bld.IsValid;
	if (bResearch)
	{
		nCmdCount = bld.CmdCount;
		bResearch = nCmdCount < 2;
		if (!bResearch) if (nCmdCount < 5) if (nRace == RepublicanRome) bResearch = true;
		if (bResearch) if (nRace == Germany) if (nCmdCount < 0) bResearch = false;
	}
	if (bResearch)
	{
		nExpectedPop = set.population + nCmdCount * 10;
		if (nExpectedPop > set.max_population)
		if (nRace == Iberia || nRace == Germany || set.gold > AIVar(AIPlayer, AIV_ExcessGold))
			bResearch = false;
	}
	if (bResearch)
	{
		int gold, food, nAffordCount;
		GetCmdCost(cmd, gold, food);
		nAffordCount = (set.population - set.max_population) / 3;
		if (nAffordCount < 2) nAffordCount = 2;
		if (food > 0)
			nAffordCount += nFoodReserve / food;
		bResearch = set.CanAfford(cmd, nAffordCount);
	}
	if (bResearch)
		bld.ExecCmd(cmd, ptDummy, objDummy, false);
}

/// food -> gold. "Sell food"	-> Iberia
if (nDonateFood > 0)
if (set.food >= AIVar(AIPlayer, AIV_SellFood))
if (set.population >= set.max_population)
if (set.food > nFoodReserve + 1000)
if (set.CanResearch("Sell food"))
if (set.CanAfford("Sell food"))
	if (pbTechMarket[nRace] == 0) 
	{
		if (strTech != "")
		{
			strTech = strTechMarket[nRace];
			if (set.food > 4000)
				bForceResearch = true; /// force to research selling food
		}
	} 
	else 
	{
		set.Research("Sell food");
		if (bLogResearch)
			pr("Player " + AIPlayer + "research Sell food");
	}


/// population -> gold. "Slavery" -> Carthage.
/**
if (set.CanResearch("Slavery"))
if (set.CanAfford("Slavery"))
{
	int nVillages = 0;
	bool bDoSlavery = false;
	if (set.population > 9 * set.max_population / 10)
	if (AIVar(AIPlayer, AIV_VillageDrain) != 0)
	{
		nVillages = set.SupplyCount("BaseVillage");
		if (nVillages > 2)
			bDoSlavery = true;
		if (!bDoSlavery)
		if (set.gold < 2000)
		if (set.population >= set.max_population)
		if (nVillages > 0)
			if (nAssUnderFire > 30 || rand(50 / nVillages) == 0 || set.population >= set.max_population * 11 / 10)
				bDoSlavery = true;
	}
	if (!bDoSlavery)
	if (nAssUnderFire > 0)
	if (set.gold < 2000)
	if (set.population > set.max_population * 75 / 100)
		bDoSlavery = true;
	if (bDoSlavery)
		if (pbTechMarket[nRace] == 0) 
		{
			if (strTech == "") 
			{
				strTech = strTechMarket[nRace];
				bForceResearch = true;
			}
		} 
		else 
		{
			set.Research("Slavery"); 
			if (bLogResearch)
				pr("Player " + AIPlayer + "research Slavery");
			return;
		}
}
*/

/// population -> gold. "Slavery" -> Carthage. improve
if (nRace == Carthage) {
	if (IsResearched(set, "Free Trade"))
	if (set.population >= set.max_population || set.population > set.max_population * 90 / 100) {
		if(set.gold < 50000) {
			set.Research("Slavery"); 
			if (bLogResearch)
				pr("Player " + AIPlayer + "research Slavery");
			return;
		}
	}
}

/// population -> Military.	"Call to arms" -> Iberia
if (nDonatePop > 0)
if (nAssUnderFire > 0)
if (set.gold < 1000)
if (set.population > set.max_population * 8 / 10)
if (nRace == Iberia)
{
	Building bld;
	str cmd;
	cmd = "Call to arms";
	bld = set.FindResearchLab(cmd);
	if (bld.IsValid)
	if (bld.CmdCount(cmd) < 1)
		if (pbTechMarket[nRace] == 0)
		{
			if (strTech == "")
				strTech = strTechMarket[nRace];
		}
		else
		{
			Query ProtectiveArea;
			Query EnemyUnits;
			ProtectiveArea = ObjsInSight(set.GetCentralBuilding,"Unit");
			EnemyUnits = Intersect(ProtectiveArea, EnemyObjs(AIPlayer, "Unit"));
			if (EnemyUnits.count > 0)
			{
				bld.ExecCmd(cmd, ptDummy, objDummy, false);
				if (bLogResearch)
					pr("Player " + AIPlayer + "research " + cmd);
			}
		}
}

/// gold -> gold. "Mercenary pact" -> Carthage
if (nDonateGold > 0)
if (strTech == "")
if (rand(5) == 2)
if (nMilUnits > 60)
if (nAssUnderFire <= 0)
if (nRace == Carthage)
{
	/*
	bool bResearched = false;
	str cmd = "Mercenary pact";
	Building b; b = EnvReadObj(AIPlayer, "Mercenary pact obj").AsBuilding;
	if (b.IsValid)
	if (b.player == AIPlayer)
		bResearched = true;

	if (!bResearched)
	if (!IsResearching(set, cmd))
	if (pbTechMarket[nRace] == 0)
		strTech = strTechMarket[nRace];
	else
		if (set.CanAfford(cmd))
		{
			b = set.FindResearchLab(cmd);
			b.ExecCmd(cmd, ptDummy, objDummy, false);
		}
		else 
		{
			strTech = cmd;
			bForceResearch = true;
		}
	*/
		
	str cmd = "Mercenary pact";
	if (!IsResearched(AIPlayer, cmd))
	if (set.CanResearch(cmd))
		if (nMilUnits > 50) 
		{
			strTech = cmd;
			bForceResearch = true;
		} 
		else if (set.CanAfford(cmd))
			strTech = cmd;
}

/// kills -> gold. "Spoils of war" -> Carthage
if (nDonateGold > 0)
if (strTech == "")
if (nAssUnderFire <= 0)
if (set.gold > AIVar(AIPlayer, AIV_ExcessGold) || (rand(3) == 2 && EnvReadInt(set, "ArenaComplete") > 0))
{
	str cmd = "Spoils of war";
	if (!IsResearched(AIPlayer, cmd))
	if (set.CanResearch(cmd))
		if (nMilUnits > 100) 
		{
			strTech = cmd;
			bForceResearch = true;
		} 
		else if (set.CanAfford(cmd))
			strTech = cmd;
}

/// gold -> warriors half of food. "Supplies" -> Greece
if(nRace == Greece && nDonateGold > 0 && strTech == "" && nAssUnderFire <= 0)
{
	if(IsResearched(set, "Trade Routes") == true)
	{
		if( (set.food < 250 || set.gold > AIVar(AIPlayer, AIV_ExcessGold)) || (rand(5) == 2) )
		{
			str cmd = "Supplies";
			if(IsResearched(AIPlayer, cmd) == false && set.CanResearch(cmd) == true)
			{
				if (nMilUnits > 100 || set.food < 250) 
				{
					strTech = cmd;
					bForceResearch = true;
				} 	//Fine if.
				else if(set.CanAfford(cmd) == true)
				{
					strTech = cmd;
				}	//Fine else if.
			}	//Fine if.
		}	//Fine if.
	}	//Fine if.
}	//Fine if.

if (strTech != "")
if (bForceResearch)
{
	str strReserving; strReserving = EnvReadString(set, "ReserveFor" + (AIPlayer - 1));
	//if (strReserving != "")
	if (strReserving != strTech)
	{
		int  budget = 0;
		budget = AIVar(AIPlayer, AIV_TechBudget);  // save orig. value
		SetAIVar(AIPlayer, AIV_TechBudget, 100);
		set.StopReserving;
		EnvWriteString(set, "strTech", strTech);
		set.AIRun("ESH_NeedTech.vs");
		SetAIVar(AIPlayer, AIV_TechBudget, budget); // restore budget
		return;
	}
	EnvWriteInt(set, "ReserveCounter", 50);
}

if (strTech != "")
if (set.CanResearch(strTech))
if (set.CanAfford(strTech))
{
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
	return;
}

//if (bLogResearch)
//	pr("Player " + AIPlayer + " was unable to choose Market/Tavern upgrade");
