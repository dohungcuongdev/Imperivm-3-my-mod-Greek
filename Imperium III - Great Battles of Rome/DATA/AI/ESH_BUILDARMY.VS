// void, Settlement set

// WARNING: since the script language doesn't have arrays and has complete boolean evaluation,
//          the code in this script is ridiculously big and ugly :)

// called from "ES_Stronghold.vs". return "nBuildCount" and "nBuildType" in the environment.

int AIPlayer, nRace;
str strTech = "", strRace = "", strDbg = "";
int nType;
int nCount;
int nArmyBuilds;
int nAssUnderFire;
bool bBuildArmy;
bool bNoArmyFromPop;
int  nLastResearched;
int  nLRCounter;
int  nLastBuilt;
int  nEnabled = 0;
int  nEarlyResearch;
int  nLastResearchTime, nLastCounterTime;
int i, j;
bool bNoArchers, bArchers;
bool bNeedTraining;
int nDbg = 0;
bool bResearchTime;
bool bLogArmy;
int nCarthageSpec;
int nMilUnits = 0;
int nNewResearchCount = 20;
bool bHeavyWant = false;
StrArray imperialTech, //Tecnologie imperiale.
         imperialUType; //Classi imperiale.
StrArray greekTech, //Tencologie Grecia.
         greekUType; //Classi Grecia.
		 
// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;

/* SEZIONE DEDICATA ALLE TECNOLOGIE DI ROMA IMPERIALE: */
if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
{
	imperialTech[0] = "";
	imperialTech[1] = "Roman Archers";
	imperialTech[2] = "Roman Velit";
	imperialTech[3] = "Roman Principle";
	imperialTech[4] = "Roman Scout";
	imperialTech[5] = "Roman Praetorian";

	imperialUType[0] = "RHastatus"; 
	imperialUType[1] = "RArcher"; 
	imperialUType[2] = "RVelit"; 
	imperialUType[3] = "RPrinciple"; 
	imperialUType[4] = "RScout"; 
	imperialUType[5] = "RPraetorian"; 
}	//Fine if.
/* FINE SEZIONE DEDICATA ALLE TECNOLOGIE DI ROMA IMPERIALE. */

/* SEZIONE DEDICATA ALLE TECNOLOGIE DI GRECIA: */
if(nRace == Greece)
{
	greekTech[0] = "Greek Spears";               //Di prova: finché non ci saranno tutte le unità.
	greekTech[1] = "Greek Archers";
	greekTech[2] = "Greek Spears";
	greekTech[3] = "Greek Royal Armor";          //Di prova: finché non ci saranno tutte le unità.   
	greekTech[4] = "Greek Chariot Wheels";
	greekTech[5] = "Greek Royal Armor";
	
	greekUType[0] = "HHoplite";     //Di prova: finché non ci saranno tutte le unità.
	greekUType[1] = "HToxotes"; 
	greekUType[2] = "HHoplite";       
	greekUType[3] = "HHypaspista";    //Di prova: finché non ci saranno tutte le unità.
	greekUType[4] = "HChariot"; 
	greekUType[5] = "HHypaspista"; 
}	//Fine if.
/* FINE SEZIONE DEDICATA ALLE TECNOLOGIE DI GRECIA. */

bLogArmy = (AIVar(AIPlayer, AIV_LogArmy) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);
strTech = "";
strRace = GetRaceStr(nRace);
nAssUnderFire = EnvReadInt(set, "AssUnderFire");         /// set in "ES_Stronghold.vs"
nArmyBuilds = EnvReadInt(set, "nArmyBuilds");             /// set in "ES_Stronghold.vs"
nLastResearched = EnvReadInt(set, "nLastResearched");     /// used only here
nLRCounter = EnvReadInt(set, "nLRCounter");               /// used only here
nLastBuilt = EnvReadInt(set, "nLastBuilt");               /// used only here
nEarlyResearch = EnvReadInt(set, "nEarlyResearch");       /// used only here [0..3]
nLastResearchTime = EnvReadInt(set, "nLastResearchTime"); /// used only here
nLastCounterTime = EnvReadInt(set, "nLastCounterTime"); /// used only here
bNeedTraining = EnvReadInt(AIPlayer, "NeedTraining")==1;  /// set in "ES_Stronghold.vs". used also in "ESH_NeedTech.vs"
bResearchTime = !bNeedTraining && (nLastResearchTime == 0 || GetTime() > nLastResearchTime + 600000);
nMilUnits = MilUnits(AIPlayer);


if (set.gold < 1000)
	return;

if (set.gold > 5000)
{
	bHeavyWant = set.gold > 10000;
	if (!bHeavyWant)
	if (EnvReadString(AIPlayer, "Tribute") != "")
		bHeavyWant = true;
	if (bHeavyWant)
	if (bLogArmy)
		pr("Player " + AIPlayer + " wish heavy army");
}
EnvWriteInt(set, "HeavyWant", bHeavyWant);

if (nLastResearched != 0)
if (nLRCounter >= nNewResearchCount)
if (GetTime() > nLastResearchTime + 90000)
{
	if(nRace == RepublicanRome && EnvReadString(set,"ChooseImperialRome") == "researched")
	{
		if (!IsResearched(set, imperialTech[nLastResearched - 1]))
		{
			if (!IsResearching(set, imperialTech[nLastResearched - 1]))
			{
				nLastResearched = 0; /// stop waiting
				if (bLogArmy) 
				{
					pr("Player " + AIPlayer + " stops waiting for research " + imperialTech[nLastResearched - 1]);
				}	//Fine if.
			}	//Fine if.
		}	//Fine if.
	}	//Fine if.
	else if(nRace == Greece)
	{
		if (!IsResearched(set, greekTech[nLastResearched - 1]))
		{
			if (!IsResearching(set, greekTech[nLastResearched - 1]))
			{
				nLastResearched = 0; /// stop waiting
				if (bLogArmy) 
				{
					pr("Player " + AIPlayer + " stops waiting for research " + greekTech[nLastResearched - 1]);
				}	//Fine if.
			}	//Fine if.
		}	//Fine if.
	}	//Fine else if.
	else
	{	
		if (!IsResearched(set, UTech(nLastResearched - 1, nRace)))
		{
			if (!IsResearching(set, UTech(nLastResearched - 1, nRace)))
			{
				nLastResearched = 0; /// stop waiting
				if (bLogArmy)
				{
					pr("Player " + AIPlayer + " stops waiting for research " + UTech(nLastResearched - 1, nRace));
				}	//Fine if.
			}	//Fine if.
		}	//Fine if.
	}	//Fine else.
}	//Fine if.
nCarthageSpec = -1;
if (nRace == Carthage)
if (EnvReadString(set, "Specialization") != "")
{
	nCarthageSpec = EnvReadInt(set, "SpecializedUnit") - 1;
	if (bLogArmy)
		if (nCarthageSpec < 0)
			pr("Mish-Mash with specialization of player " + AIPlayer);
		else if (!IsResearched(set, UTech(nCarthageSpec, nRace)))
			pr("Mish-Mash2 with specialization of player " + AIPlayer + "about " + UTech(nCarthageSpec, nRace));
}
if (nCarthageSpec >= 0)
	EnvWriteInt(set, "nNextSpec", 0);

i = 0;
i += Count(AIPlayer, "GArcher");
i += Count(AIPlayer, "RArcher");
i += Count(AIPlayer, "CJavelinThrower");
i += Count(AIPlayer, "IArcher") + Count(AIPlayer, "ISlinger");
i += Count(AIPlayer, "BBowman");
i += Count(AIPlayer, "EArcher") + Count(AIPlayer, "EAxetrower");
i += Count(AIPlayer, "TArcher") + Count(AIPlayer, "THuntress") + Count(AIPlayer, "TeutonArcher");
i += Count(AIPlayer, "HToxotes");    // Aggiunti arcieri greci al conteggio -> I Mirmidoni dato che possono essere solo 50 non verrano considerati.

bNoArchers = i > (AIVar(AIPlayer, AIV_ArcherPercent) * nMilUnits / 100);
bArchers = (nMilUnits > 15) && (i < (AIVar(AIPlayer, AIV_ArcherPercent) * nMilUnits / 200));

if (!bResearchTime)
if (nRace == Carthage)
if (nCarthageSpec < 0)
	bResearchTime = true;

if (!bResearchTime)
if (nRace == Carthage)
if (nLastResearched == 0)
if (nCarthageSpec >= 0)
if (Count(AIPlayer, UType(nCarthageSpec, Carthage)) > 10)
	bResearchTime = true;

if (!bResearchTime)
if (bNoArchers)
if (nRace == Carthage)
if (nCarthageSpec == 1)
	bResearchTime = true;

/// still researching...
if (nLastResearched > 0)
{
	if(nRace == RepublicanRome && EnvReadString(set,"ChooseImperialRome") == "researched")
	{
		if (IsResearching(set, imperialTech[nLastResearched - 1]))
		{
			if (bLogArmy) 
			{
				pr("Player " + AIPlayer + " waits for research " + imperialTech[nLastResearched - 1]);
			}	//Fine if.
			
			return;
		}	//Fine if.
	}	//Fine if.
	else if(nRace == Greece)
	{
		if (IsResearching(set, greekTech[nLastResearched - 1]))
		{
			if (bLogArmy) 
			{
				pr("Player " + AIPlayer + " waits for research " + greekTech[nLastResearched - 1]);
			}	//Fine if.
			return;
		}	//Fine if.
	}	//Fine else if.
	else 
	{
		if (IsResearching(set, UTech(nLastResearched - 1, nRace)))
		{
			if (bLogArmy) 
			{
				pr("Player " + AIPlayer + " waits for research " + UTech(nLastResearched - 1, nRace));
			}
			return;
		}
	}
}

//------------ENABLED UNITS (depend on the current count!) ----------------
set.AIRun("ESH_EnabledUnits.vs");

if(nRace == RepublicanRome && EnvReadString(set,"ChooseImperialRome") == "researched")
{
	nEnabled = EnvReadInt(AIPlayer, "IRomeUnitsEnabled");
}	//Fine if.
else if(nRace == Greece)
{
	nEnabled = EnvReadInt(AIPlayer, "GreekUnitsEnabled");
}	//Fine else if.
else
{
	nEnabled = EnvReadInt(AIPlayer, GetRaceStr(nRace) + "UnitsEnabled");
}	//Fine else.

//------------INITIALIZATIONS MADE ONLY ONCE-------------------------------------
if (EnvReadInt(set, "TechSeq" + AIPlayer + "_Initted") == 0)
	set.AIRun("ESH_ArmyTechSeq.vs"); /// decide "research sequence" as numbers in [1..5] 

if (nLastResearched >= 0)
if (!UEnabled(nEnabled, nLastResearched - 1))
{	/// the current count is more then allowed
	nLastResearched = 0;
	EnvWriteInt(set, "nLastResearched", 0);
	if (bLogArmy) 
		pr("Player " + AIPlayer + " last reserch units limits reached");
}

//------------DECIDE "EARLY RESEARCH"-------------------------------------
if (nEarlyResearch == 0)
{
	nEarlyResearch = 1;
	if (nRace != Carthage)
	if (rand(5) == 0)
		nEarlyResearch = 2;
	EnvWriteInt(set, "nEarlyResearch", nEarlyResearch);
}
 
//------------DECIDE WHETHER TO BUILD ARMY AT ALL-------------------------
strDbg = "";
bBuildArmy = false;
bNoArmyFromPop = false;
if (nAssUnderFire > 0) 
{
	bBuildArmy = true;
	strDbg = "AssUnderFire";
} 
else if (EnvReadInt(set, "FreezeArmyBuild") != 0) 
{
	bBuildArmy = false;
	strDbg = "Building army is temporary freezed";
} 
else if (set.population <= 10 && nRace != Carthage) 
{
	bBuildArmy = false;
	strDbg = "The population is too low";
} 
else if (nArmyBuilds == 0)	
{
	bBuildArmy = true;
	strDbg = "Stronghold have no mind";
} 
else if (set.food < 100 && nMilUnits >= 100)
{
	bBuildArmy = false;
	strDbg = "Too large army and no food";
} 
else 
{
	int n, nPop = 0;
	strDbg = "Wait more population";
	if (nMilUnits < 20 || nArmyBuilds < 2)
		nPop = 60;
	else if (nArmyBuilds < 10)
		nPop = 80;
	else
		nPop = 100;
	
	n = 100 - set.gold / 250;
	
	if (n < 40) 
		n = 40;
	
	nPop = nPop * n / 100;
	bBuildArmy = (set.population >= set.max_population * nPop / 100);
	
	if (!bHeavyWant)
	if (GetTime > 5 * 60 * 1000)
		bHeavyWant = (set.population < set.max_population * 85 / 100);
	if (bHeavyWant)
		EnvWriteInt(set, "HeavyWant", bHeavyWant);
	if (!bBuildArmy)
		bNoArmyFromPop = true;
}

/*
//----------- BUILD 5 ZERO TYPE UNITS IF NO MILITARY UNITS ---------------
if (bBuildArmy)
if (nMilUnits == 0)
{
	nType = 0;
	if (nCarthageSpec >= 0)
		nType = nCarthageSpec;
	if (UEnabled(nEnabled, nType))
	{
		EnvWriteInt(set, "nBuildCount", 5);
		EnvWriteInt(set, "nBuildType", nType);
		return;
	}
}
*/
//----------- SPECIFY A NEW COUNTER UNIT [AND/OR] NEW RESEARCH UNIT ------
nType = -1;

/* ARCIERI: */
if (bArchers == true && nLastResearched == 0)
{
	strTech = "";
	
	nType = 1; // GArcher, RArcher, CJavelinThrower, IArcher, BBowman, EArcher, TArcher, HToxotes
	if (Iberia == nRace) 
	{
		if (IsResearched(set, UTech(4, nRace)))
			nType = 4; // ISlinger
	} 
	else if(Egypt == nRace) 
	{
		nType = 2; // EAxetrower
	}
	/*
	else if (Germany == nRace)
	//TeutonArcher
	*/
}	//Fine if.

if (nType == -1)
if (nLastResearched == 0)
{
	int nNextCounter = 1;

	strTech = "";
	nType = EnvReadInt(set, "nNextSpec") - 1;

	if (nType < 0)
	if (AIVar(AIPlayer, AIV_CounterUnits) != 0)
	{	
		/// specify a counter unit and a technology needed to build it
		if (nLastCounterTime == 0 || GetTime() > nLastCounterTime + 15000)	
		{
			set.AIRun("ESH_CounterUnits.vs");
			nLastCounterTime = GetTime();
			EnvWriteInt(set, "nLastCounterTime", nLastCounterTime);
		}
		i = EnvReadInt(set, "CounterUnit_" + nNextCounter) - 1;

		while (i >= 0)
		{
			if (i == 5)
			if (bNoArmyFromPop)
			{
				if (nRace == Carthage)
				{
					nNextCounter += 1;
					i = EnvReadInt(set, "CounterUnit_" + nNextCounter) - 1;
					continue;
				}	
				if (i == 1)
				if (bNoArchers)
				{
					nNextCounter += 1;
					i = EnvReadInt(set, "CounterUnit_" + nNextCounter) - 1;
					continue;
				}
				nType = i;
				if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
				{
					strTech = imperialTech[i];
				}	//Fine if.
				else if(nRace == Greece)
				{
					strTech = greekTech[i];
				}	//Fine else if.
				else
				{
					strTech = UTech(i, nRace);
				}	//Fine else.
			}
			break;
		}

		if (nType >= 0)
		{	 
			if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
			{
				if(bLogArmy)
					pr("Player " + AIPlayer + " choosed counter " + imperialUType[nType]);
			}	//Fine if.
			else if(nRace == Greece)
			{
				if(bLogArmy)
					pr("Player " + AIPlayer + " choosed counter " + greekUType[nType]);
			}	//Fine else if.
			else  
			{
				if (bLogArmy)
					pr("Player " + AIPlayer + " choosed counter " + UType(nType, nRace));
			}	//Fine else.
		}	//Fine if.
	}

	/// check for a new research if it's not specified a counter unit
	if (nType < 0)
	if (bResearchTime) 
	if ((nMilUnits >= 20) || (nEarlyResearch == 1) || (nRace == Carthage && nCarthageSpec < 0))
	{
		if (bLogArmy) pr("Player " + AIPlayer + " will try to make random research");
		if (nRace == Carthage)
		{
			if (nCarthageSpec >= 0)
			if (rand(3) == 0)
			if (!IsResearched(set, UTech(5, Carthage)))
				nType = 5;
			if (nType < 0)
			{
				bool bResearch = true;
				if (nCarthageSpec >= 0)
				if (Count(AIPlayer, UType(nCarthageSpec, Carthage)) > 20)
				if (rand(nCarthageSpec) == 0)
					bResearch = false;
				if (bResearch)
				{
					IntArray wTech;
					int count = 0, nMin = 0;
					if (GetTime() > 600000 || set.gold > 10000)
						nMin += 1;
					if (GetTime() > 1200000 || set.gold > 10000)
						nMin += 1;
					for (i = nMin; i < 5; i += 1)
					{
						if (!UEnabled(nEnabled, i)) 
							continue;
						if (i == nCarthageSpec) 
							continue;
						if (i == 1 && bNoArchers) 
							continue;
						wTech[count] = i;
						count += 1;
					}
					if (count > 0) 
					{
						nType = wTech[rand(count)];
						strTech = UTech(nType, Carthage);
					}
					if (nType < 0) nType = nCarthageSpec;
					if (nType >= 0)
						if (bLogArmy) pr("Player " + AIPlayer + " specialization is " + strTech);
				}
			}
		}
		else
		{
			nType = -1;
			if (bHeavyWant == true)
			{
				for (i = 5; i > 0 && nType < 0; i -= 1)
				{
					if(UEnabled(nEnabled, i))
					{
						if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
						{
							if (imperialTech[i] != "")
							if (!IsResearched(set, imperialTech[i]))
								nType = i;
						}	//Fine if.
						else if(nRace == Greece)
						{
							if (greekTech[i] != "")
							if (!IsResearched(set, greekTech[i]))
								nType = i;
						}	//Fine else if.
						else
						{
							if (UTech(i, nRace) != "")
							if (!IsResearched(set, UTech(i, nRace)))
								nType = i;
						}	//Fine else.
					}	//Fine if.
				}
			}
			if (nType < 0)
			{
				for (i = 1; i < 7 && strTech == ""; i += 1)
				{
					nType = EnvReadInt(set, "TechSeq" + AIPlayer + "_" + i) - 1;
					if (nType < 0)
						break; /// no more research
					/// check for heavy upgrades
					if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
					{
						strTech = imperialTech[nType];
					}	//Fine if.
					else if(nRace == Greece)
					{
						strTech = greekTech[nType];
					}	//Fine else if.
					else
					{
						strTech = UTech(nType, nRace);
					}	//Fine else.
					if (strTech != "")
					if (!IsResearched(set, strTech))
						break;
				}
			}
		}
	}
	if (nType >= 0)
	{
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			strTech = imperialTech[nType];
		}	//Fine if.
		if(nRace == Greece)
		{
			strTech = greekTech[nType];
		}	//Fine else if.
		else
		{
			strTech = UTech(nType, nRace);
		}	//Fine else.
	}
	if (AIVar(AIPlayer, AIV_Research) != 0)
	while (strTech != "")
	{
		bool bResearching = false;
		if (bLogArmy) pr("Player " + AIPlayer + " will try to reserch " + strTech);
		if (IsResearched(set, strTech))
			break;
		if (bLogArmy) pr("Build army script for player " + AIPlayer + " wished to research " + strTech);
		if (!IsResearching(set, strTech))
		{
			if (nRace == Carthage && nType < 5)
			{	/// force research
				if (nCarthageSpec >= 0)
				{
					EnvWriteInt(set, "TestTechSucceed", 1);
					EnvWriteString(set, "strTech", strTech);
					set.AIRun("ESH_NeedTech.vs");
					EnvWriteInt(set, "TestTechSucceed", 0);
					if (EnvReadString(set, "NeedTechSucceed") != 0)	{
						EnvWriteInt(set, "nNextSpec", nType + 1);
						set.Research("StopSpecialization");
						return;
					}
				}
				else
					if (set.CanResearch(strTech) && set.CanAfford(strTech))
					{
						set.Research(strTech);
						bResearching = true;
					} 
					else
						return;
			}	
			else 
			{
				//if (bLogArmy) pr("Player " + AIPlayer + " call ESH_NeedTech for tech " + strTech);
				EnvWriteString(set, "strTech", strTech);
				set.AIRun("ESH_NeedTech.vs");
				if (EnvReadString(set, "NeedTechSucceed") != 0)
					bResearching = true;
			}
		}
		if (bResearching)
		{
			EnvWriteInt(set, "nEarlyResearch", 3);
			EnvWriteInt(set, "nLastResearched", nType + 1);
			EnvWriteInt(set, "nLRCounter", nNewResearchCount);
			EnvWriteInt(set, "nLastResearchTime", GetTime());
			EnvWriteInt(set, "nNextSpec", 0);
			if (bLogArmy) pr("Player " + AIPlayer + " do not build army coz is researching " + strTech);
			return; 
		}	
		else if (bLogArmy) 
			pr("Player " + AIPlayer + " can not research " + strTech);

		nType = EnvReadInt(set, "CounterUnit_" + nNextCounter) - 1;
		if (nType == 5)
		if (bNoArmyFromPop)
		if (nRace == Carthage) 
		{
			nNextCounter += 1;
			nType = EnvReadInt(set, "CounterUnit_" + nNextCounter) - 1;
		}
		if (nType < 0)
			break;
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			strTech = imperialTech[nType];
		}	//Fine if.
		if(nRace == Greece)
		{
			strTech = greekTech[nType];
		}	//Fine else if.
		else
		{
			strTech = UTech(nType, nRace);
		}	//Fine else.
		nNextCounter += 1;
	}
}

if (!bBuildArmy) 
{
	if (bNoArmyFromPop && nRace == Carthage)
		CheckUEnabled(nEnabled, AIPlayer, 0, 5, Carthage);
	else 
	{
		if (bLogArmy)
		if (strDbg != "")
			pr("Player " + AIPlayer + ": do not build army coz: " + strDbg);
		return;
	}
}

if (nType >= 0)
	nDbg = 5;	/// counter unit chosen
else if (nLastResearched > 0)
{	/// continue with the last researched
	nDbg = 1;
	nType = nLastResearched - 1;
} 
else if (rand(nLastBuilt/2+2) != 0)
{	/// continue with the last built
	nDbg = 2;
	nType = nLastBuilt;
}
else 
{ /// randomly builds
	nDbg = 3;
	if (nRace == Carthage)
	{
		if (nCarthageSpec >= 0)
		if (nCarthageSpec != 1 || !bNoArchers)
			nType = nCarthageSpec;
		if (nType < 0 || rand(2) == 1)
		if (IsResearched(set, UTech(5, Carthage)))
			nType = 5;
	}
	else
	{
		if (!bNoArchers && rand(3) == 1)
			nType = 1;
		else 
		{
			nType = rand(6);
			if (nType < 5)
			if (GetTime() > 900000)
			if (rand(2) == 1)
				nType += 1;
			if (nType < 5)
			if (set.gold >= AIVar(AIPlayer, AIV_ExcessGold))
				nType += 1;
		}
	}
}
if (nType >= 0)
{
	if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
	{
		strTech = imperialTech[nType];
	}	//Fine if.
	else if(nRace == Greece)
	{
		strTech = greekTech[nType];
	}	//Fine else if.
	else
	{
		strTech = UTech(nType, nRace);
	}	//Fine else.
	if (strTech != "")
	if (IsResearching(set, strTech)) 
	{
		if (bLogArmy) pr("Player " + AIPlayer + " waits for " + strTech);
		return;
	}
}

if (AIVar(AIPlayer, AIV_Research) != 0)
if (nRace == Carthage)
{
	if (nType != nCarthageSpec && nType != 5)
		nType = nCarthageSpec;
	if (bNoArchers && nType == 1)
		nType = 5;
	if (nType < 0)
		return;
	if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
	{
		strTech = imperialTech[nType];
	}	//Fine if.
	else if(nRace == Greece)
	{
		strTech = greekTech[nType];
	}	//Fine else if.	
	else
	{
		strTech = UTech(nType, nRace);
	}	//Fine else.
	
	if (strTech != "")
	if (!IsResearched(set, strTech))
	{
		if (set.CanResearch(strTech))
		if (set.CanAfford(strTech))
			set.Research(strTech);
		return;
	}
}
else
{
	if (nType == 1)
	if (bNoArchers)
	{
		nType = rand(6);
	}
	while (nType >= 0)
	{
		if (!UEnabled(nEnabled, nType))
		{
			nType -= 1;
			continue;
		}
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			strTech = imperialTech[nType];
		}	//Fine if.
		else if(nRace == Greece)
		{
			strTech = greekTech[nType];
		}	//Fine else if.
		else
		{
			strTech = UTech(nType, nRace);
		}	//Fine else.
		if (strTech != "")
		if (!IsResearched(set, strTech))
		{
			nType -= 1;
			continue;
		}
		break;
	}
	if (nType == 1)
	if (bNoArchers)
	{
		nType = 0;
	}
	if (nType < 0) 
	{
		if (bLogArmy) pr("Player " + AIPlayer + " do not build army coz can not deside what to build");
		return;
	}
}
if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
{
	strTech = imperialTech[nType];
}	//Fine if.
else if(nRace == Greece)
{
	strTech = greekTech[nType];
}	//Fine else if.
else
{
	strTech = UTech(nType, nRace);
}	//Fine else.
if (strTech != "")
if (IsResearching(set, strTech))
{
	if (bLogArmy)
	{
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{	
			pr("Player " + AIPlayer + " waits for " + imperialTech[nType] + " (2nd choice)");
		}	//Fine if.
		else if(nRace == Greece)
		{	
			pr("Player " + AIPlayer + " waits for " + greekTech[nType] + " (2nd choice)");
		}	//Fine else if.
		else
		{
			pr("Player " + AIPlayer + " waits for " + UTech(nType, nRace) + " (2nd choice)");
		}	//Fine else.
	}
	return;
}

if (strTech != "")
if (!IsResearched(set, strTech))
if (nAssUnderFire > 0)
{
	if (!UEnabled(nEnabled, 0))	
	{
		if (bLogArmy) pr("Player " + AIPlayer + " do not build army coz is confused");
		return;
	}
	nDbg = 4;
	nType = 0;
} 
else 
{
	if (bLogArmy) pr("Player " + AIPlayer + " do not build army coz is waiting tech " + strTech);
	return;
}

EnvWriteInt(set, "nBuildType", nType);
nCount = 10;
if (nType >= 0)
if (nType == nLastResearched - 1)
if (nLRCounter > 0)
if (nCount > nLRCounter)
	nCount = nLRCounter - nCount;
EnvWriteInt(set, "nBuildCount", nCount);

if (nType >= 0)
if (nType == nLastResearched - 1)
{
	if (rand(5) == 0) nLRCounter = 0;
	else nLRCounter -= nCount; 
	if (nLRCounter < 0) nLRCounter = 0;
	EnvWriteInt(set, "nLRCounter", nLRCounter);
	if (nLRCounter <= 0) 
		EnvWriteInt(set, "nLastResearched", 0);
}
EnvWriteInt(set, "nLastBuilt", nType);
/*
if (bLogArmy)
{
	if (nDbg == 1) 
	{
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			pr("Player " + AIPlayer + " builds new fancy " + nCount + " " + imperialTech[nType, nRace));
		}
		else
		{
			pr("Player " + AIPlayer + " builds new fancy " + nCount + " " + UType(nType, nRace));
		}
	}
	if (nDbg == 2) 
	{
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
		}
		else
		{
			pr("Player " + AIPlayer + " continues with "   + nCount + " " + UType(nType, nRace));
		}
	}
	if (nDbg == 3) 
		pr("Player " + AIPlayer + " randomly builds "  + nCount + " " + UType(nType, nRace));
	if (nDbg == 4) 
		pr("Player " + AIPlayer + " forced to build "  + nCount + " " + UType(nType, nRace));
	if (nDbg == 5) 
		pr("Player " + AIPlayer + " COUNTERS with "    + nCount + " " + UType(nType, nRace));
	if (nDbg > 5)  
		pr("Player " + AIPlayer + " Unknown what are doing");
}
*/
