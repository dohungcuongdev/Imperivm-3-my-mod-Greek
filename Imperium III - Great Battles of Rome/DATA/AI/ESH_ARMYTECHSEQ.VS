// void, Settlement set

int AIPlayer, nRace;
int i, min, count;
int nEnabled;
IntArray Randoms;	/// [0..5]
bool bLogResearch;
StrArray imperialTech;    //Tecnologie fucina Roma Imperiale.
StrArray greekTech;       //Tecnologia fucina greca.

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;
if(nRace == RepublicanRome && EnvReadString(set,"ChooseImperialRome") == "researched")
{
	nEnabled = EnvReadInt(AIPlayer, "IRomeUnitsEnabled");
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
	greekTech[0] = "Greek Spears";            //Di prova: finché non ci saranno tutte le unità.
	greekTech[1] = "Greek Archers";
	greekTech[2] = "Greek Spears";
	greekTech[3] = "Greek Royal Armor";       //Di prova: finché non ci saranno tutte le unità.
	greekTech[4] = "Greek Chariot Wheels";
	greekTech[5] = "Greek Royal Armor";
}	//Fine else if.
else
{
	nEnabled = EnvReadInt(AIPlayer, GetRaceStr(nRace) + "UnitsEnabled");
}

bLogResearch = (AIVar(AIPlayer, AIV_LogResearch) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);

/// init with identity
for (i = 5; i >= 0; i -= 1)
	Randoms[i] = i;

/// decide min
min = 0;
if (nRace == Gaul)
{	/// decide quick gaul tweak
	min = 2;
	if (AIVar(AIPlayer, AIV_CounterUnits) == 0)
		if (rand(10) != 0)
		{ // make spearmen first, to handle the damn hastati :)
			Randoms[2] = 3;
			Randoms[3] = 2;
			min = 3;
		}
}
/// scramble
for (i = 10; i > 0 ; i -= 1)
{
	int a, b, c;
	a = min + rand(5 - min);
	c = Randoms[a];	Randoms[a] = Randoms[a+1]; Randoms[a+1] = c;
}
/// remove disabled or when tech is no needed
count = 0;
for (i = 0; i < 6; i += 1)
{
	if (UEnabled(nEnabled, Randoms[i]))	
	{
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched") 
		{
			if (imperialTech[Randoms[i]] != "")
			{
				Randoms[count] = Randoms[i];
				count = count + 1;
			}	//Fine if.
		}	//Fine if.
		else if(nRace == Greece)
		{
			if (greekTech[Randoms[i]] != "")
			{
				Randoms[count] = Randoms[i];
				count = count + 1;
			}	//Fine if.
		}	//Fine else if.
		else
		{
			if (UTech(Randoms[i], nRace) != "")
			{
				Randoms[count] = Randoms[i];
				count = count + 1;
			}
		}
	}
}
/// Iberia slingers are counted as archers and shuld no start with them
if (nRace == Iberia) if (count > 1) if (Randoms[0] == 4)
{
	Randoms[0] = Randoms[1];
	Randoms[1] = 4;
}

/*
if (nRace == Carthage) if (count > 1) if (UEnabled(nEnabled, 5)) if (Randoms[1] != 5)
{	/// put Nobles guard always on pos 1
	for (i = 0; i < count ; i += 1)
		if (Randoms[i] == 5) {
			Randoms[i] = Randoms[1];
			Randoms[1] = 5;
			break;
		}
}

if (nRace == Carthage) if (Randoms[0] == 5) if (count > 1)
{	/// put Nobles more behind
	Randoms[0] = Randoms[1];
	Randoms[1] = 5;
}
*/
for (i = 0; i < count; i += 1)
	EnvWriteInt(set, "TechSeq" + AIPlayer + "_" + (i + 1), Randoms[i] + 1);	/// [1..6]

/// log results
if (bLogResearch)
{
	pr("Player " + AIPlayer + " army research sequence: (" + count + ")");
	for (i = 0; i < count; i += 1)
	{
		str strTech;
		int nType;
		nType = EnvReadInt(set, "TechSeq" + AIPlayer + "_" + (i + 1));
		if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			strTech = imperialTech[nType - 1];
		}	//Fine if.
		else if(nRace == Greece)
		{
			strTech = greekTech[nType - 1];
		}	//Fine else if.
		else
		{ 
			strTech = UTech(nType - 1, nRace);
		} 
		pr("  [" + (i + 1) + "]" + strTech);
	}
}

/// mark as initted
EnvWriteInt(set, "TechSeq" + AIPlayer + "_Initted", 1);
