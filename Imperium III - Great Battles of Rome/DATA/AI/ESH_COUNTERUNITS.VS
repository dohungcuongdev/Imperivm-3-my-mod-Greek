// void, Settlement set

int AIPlayer, nRace;
int nEnabled;
int i, nType, total;
IntArray W;
int nCarthageSpec;
bool bLogArmy;
int nMilUnits = 0;
bool bHeavyWant = false;
StrArray imperialTrainCmd, //Comandi caserma imperiale.
         imperialUType, //Classi Roma imperiale.
		 imperialTech; //Tecnologie fucina imperiale.
StrArray greekTrainCmd, //Comandi caserma Grecia.
         greekUType, //Classi Grecia.
		 greekTech; //Tecnologie fucina Grecia.
		 
// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;

bLogArmy = (AIVar(AIPlayer, AIV_LogArmy) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);

/** 
if(nRace == RepublicanRome && EnvReadString(set,"ChooseRepublicanRome") == "researched")
{
	nEnabled = EnvReadInt(AIPlayer, "IRomeUnitsEnabled");
	
	imperialTrainCmd[0] = "trainRHastatus"; 
	imperialTrainCmd[1] = "trainRArcher";
	imperialTrainCmd[2] = "trainRGladiator"; 
	imperialTrainCmd[3] = "trainRPrinciple";
	imperialTrainCmd[4] = "trainRScout";
	imperialTrainCmd[5] = "trainRTribune";
	
	imperialUType[0] = "RHastatus"; 
	imperialUType[1] = "RArcher"; 
	imperialUType[2] = "RGladiator"; 
	imperialUType[3] = "RPrinciple"; 
	imperialUType[4] = "RScout"; 
	imperialUType[5] = "RTribune"; 

	imperialTech[0] = "";
	imperialTech[1] = "Roman Archers";
	imperialTech[2] = "Roman Gladiator";
	imperialTech[3] = "Roman Principle";
	imperialTech[4] = "Roman Scout";
	imperialTech[5] = "Roman Full Armor";
}	//Fine if.
else 
**/
	
if(nRace == RepublicanRome && EnvReadString(set,"ChooseImperialRome") == "researched")
{
	nEnabled = EnvReadInt(AIPlayer, "IRomeUnitsEnabled");
	
	imperialTrainCmd[0] = "trainRHastatus"; 
	imperialTrainCmd[1] = "trainRArcher";
	imperialTrainCmd[2] = "trainMVelit"; 
	imperialTrainCmd[3] = "trainRPrinciple";
	imperialTrainCmd[4] = "trainRScout";
	imperialTrainCmd[5] = "trainMPraetorian";
	
	imperialUType[0] = "RHastatus"; 
	imperialUType[1] = "RArcher"; 
	imperialUType[2] = "RVelit"; 
	imperialUType[3] = "RPrinciple"; 
	imperialUType[4] = "RScout"; 
	imperialUType[5] = "RPraetorian"; 

	imperialTech[0] = "";
	imperialTech[1] = "Roman Archers";
	imperialTech[2] = "Roman Velit";
	imperialTech[3] = "Roman Principle";
	imperialTech[4] = "Roman Scout";
	imperialTech[5] = "Roman Praetorian";
}	//Fine if.
else if(nRace == Greece)
{
	nEnabled = EnvReadInt(AIPlayer, "GreekUnitsEnabled");
	
	//greekTrainCmd[0] = "trainIMilitiaman";   
	greekTrainCmd[0] = "trainHHoplite"; 	
	greekTrainCmd[1] = "trainHToxotes";
	greekTrainCmd[2] = "trainHHoplite";
	greekTrainCmd[3] = "trainHMyrmidon";   
	greekTrainCmd[4] = "trainHChariot";
	greekTrainCmd[5] = "trainHHypaspista";
	greekTrainCmd[6] = "trainEHOPLITA";
	
	//greekUType[0] = "IMilitiaman"; 
	greekUType[0] = "HHoplite";
	greekUType[1] = "HToxotes"; 
	greekUType[2] = "HHoplite"; 
	greekUType[3] = "HMyrmidon_Javelin"; 
	greekUType[4] = "HChariot"; 
	greekUType[5] = "HHypaspista"; 
	greekUType[6] = "EHOPLITA"; 
	
	//greekTech[0] = "";
	greekTech[0] = "Greek Spears";
	greekTech[1] = "Greek Archers";
	greekTech[2] = "Greek Spears";
	greekTech[3] = "Forge Elite Equipment";
	greekTech[4] = "Greek Chariot Wheels";
	greekTech[5] = "Greek Royal Armor";
	greekTech[6] = "Wall of Shields";
}	//Fine else if.
else
{
	nEnabled = EnvReadInt(AIPlayer, GetRaceStr(nRace) + "UnitsEnabled");
}
nCarthageSpec = -1;
if (EnvReadInt(set, "HeavyWant") > 0)
	bHeavyWant = true;

GetCounterUnits(set, W);

//bLogArmy = true;
if (bLogArmy)
	pr("Counters for player " + AIPlayer);

// zero weights for disabled types
for (i = 0; i < 6; i += 1) 
{
	if (!UEnabled(nEnabled, i))
	{
		W[i] = 0;
	}
}
// calc weighted random
total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
if (total <= 0)	
{
	EnvWriteInt(set, "CounterUnit_1", 0);
	return;
}

/// spread some additional weight for all units
nMilUnits = MilUnits(AIPlayer);
if (nMilUnits > 20)
{
	int nAddWeight;
	nAddWeight = total / 30; /// 20% -> * 20 / 100 / 6
	for (i = 0; i < 6; i += 1)
		W[i] = W[i] + nAddWeight;
	total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
}

/// boost heavy units. Every units is boosted with its health
if (nMilUnits > 50 || bHeavyWant)
{
	for (i = 0; i < 6; i += 1)
	{
		//In quanto ci sono delle unità che non sono ancora state fatte:
		if(nRace == Greece && greekTrainCmd[i] == "")
		{
			continue;
		}	//Fine if.
		
		if (W[i] != 0)
		{
			int nCost; 
			
			if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
			{
				nCost = GetTrainGold(imperialTrainCmd[i]) / 10;
			}	//Fine if.
			else if(nRace == Greece)
			{
				nCost = GetTrainGold(greekTrainCmd[i]) / 10;
			}	//Fine else if.
			else
			{
				nCost = GetTrainGold(UTrainCmd(i, nRace)) / 10;
			}	//Fine else.
			
			//int nCost; nCost = GetClassHealt(UTrainCmd(i, nRace)) / 10;
			if (nCost > 0)
				W[i] = W[i] * nCost;
			if (bHeavyWant && i > 2)
				W[i] = W[i] * i;
		}	//Fine if.
	}	//Fine del for.
	total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
}

/// boost army variety
if (nMilUnits > 50)
{
	for (i = 0; i < 6; i += 1) 
	{
		int n; 
		
		//In quanto ci sono delle unità ch non sono ancora state fatte:
		if(nRace == Greece && greekUType[i] == "")
		{
			continue;
		}	//Fine if.
		
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			n = 100 * Count(AIPlayer, imperialUType[i]) / nMilUnits;
		}	//Fine if.
		else if(nRace == Greece)
		{
			n = 100 * Count(AIPlayer, greekUType[i]) / nMilUnits;
		}	//Fine else if.
		else
		{
			n = 100 * Count(AIPlayer, UType(i, nRace)) / nMilUnits;
		}	//Fine else.
		
		//n -= 30;
		if (n > 0)
		{
			W[i] = W[i] * (100 - MAX(n, 0)) / 100;
		}	//Fine if.
	}	//Fine del for.
	
	total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
}	//Fine if.

if (nRace == Carthage)
{
	/// boost to research more units on a particular type to increase the level they are hired
	/// 0-50% bonus depend on the units count (bonus increase with the count)
	if (IsResearched(set, "Shared Strength"))	/// researching "Shared Triumph" do not change the evaluation
	{
		int nMin = 0, nMax = 50;
		for (i = 0; i < 6; i += 1)
		{
			if (W[i] > 0)	
			{
				int k; k = Count(AIPlayer, UType(i, Carthage));
				if (k > 50) k = 50;
				W[i] += W[i] * (nMin + (nMax - nMin) * k / 50) / 100;
			}
		}
	}
	/// boost current carthage specialization - 20-50% (bonus decrease with the count)
	if (EnvReadString(set, "Specialization") != "")
	{
		nCarthageSpec = EnvReadInt(set, "SpecializedUnit") - 1;
		if (bLogArmy)
			if (nCarthageSpec < 0)
				pr("Mish-Mash with specialization of player " + AIPlayer);
			else if (!IsResearched(set, UTech(nCarthageSpec, nRace)))
				pr("Mish-Mash2 with specialization of player " + AIPlayer);
		if (W[nCarthageSpec] > 0)
		{
			int nMin = 20, nMax = 50;
			int k; k = Count(AIPlayer, UType(nCarthageSpec, Carthage));
			if (k > 50) k = 50;
			W[nCarthageSpec] += W[nCarthageSpec] * (nMin + (nMax - nMin) * (50 - k) / 50) / 100;
		}
	}
}
else
{ /// give some bonus to the original plan for not researched units
	// more boost for heavy units when researched
	/*
	if (W[5] > 0)
	{
		W[5] += total / 15;
		if (UTech(5, nRace) != "") if (!IsResearched(set, UTech(5, nRace)))
			W[5] += total / 5;
	}
	*/
	// boost the next tech seq
	for (i = 1; i < 6; i += 1)
	{
		str strTech;
		int t;
		
		if (i == 1) if (nRace == Gaul)
			continue;
		
		t = EnvReadInt(set, "TechSeq" + AIPlayer + "_" + i);
		
		if (!UEnabled(nEnabled, t))
		{
			continue;
		}
		
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			strTech = imperialTech[t];
		}	//Fine if.
		else if(nRace == Greece)
		{
			strTech = greekTech[t];
		}	//Fine else if.
		else
		{
			strTech = UTech(t, nRace);
		}	//Fine else.
		
		if (strTech != "") if (!IsResearched(set, strTech)) if (t > 0 && t < 6)
			W[t] += total / 10;
		
		break;
	}
}

for (i = 0; i < 6; i += 1) 
{
	if (!UEnabled(nEnabled, i))
		W[i] = 0;
}
total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];

if (bLogArmy)
{
	str s = "";
	for (i = 0; i < 6; i += 1)
	{
		nType = W[i];
		s = s + " " + nType;
	}
	nType = EnvReadInt(set, "CounterUnit_1") - 1;
	pr(s);
}

for (i = 1; i < 7 && total > 0; i += 1)
{
	int r; 
	
	r = rand(total);
	
	for (nType = 0; nType < 6; nType += 1) 
	{
		r -= W[nType];
		if (r < 0) 
		{
			EnvWriteInt(set, "CounterUnit_" + i, nType + 1);
			total -= W[nType];
			W[nType] = 0;
			break;
		}
	}
}

EnvWriteInt(set, "CounterUnit_" + i, 0);

/// logging
if (bLogArmy)
{
	str s = "";

	if (total != 0)
		pr("Player " + AIPlayer + ": Error in the counter units estimation! (total = " + total + ")");

	for (i = 0; i < 6; i += 1)
	{
		nType = W[i];
		s = s + " " + (EnvReadInt(set, "CounterUnit_" + (i + 1)) - 1);
	}
	pr(s);
	nType = EnvReadInt(set, "CounterUnit_1") - 1;
	if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
	{
		pr("Counter unit result for player " + AIPlayer + ": No" + nType + " -> " + imperialUType[nType]);
	}	//Fine if.
	else if(nRace == Greece)
	{
		pr("Counter unit result for player " + AIPlayer + ": No" + nType + " -> " + greekUType[nType]);
	}	//Fine else if.
	else	
	{
		pr("Counter unit result for player " + AIPlayer + ": No" + nType + " -> " + UType(nType, nRace));
	}
}
