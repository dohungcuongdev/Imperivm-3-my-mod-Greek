//void, Settlement set, str class, int num, ObjList ol

//BUG!!!! HACK!!!!
//BE CAREFUL NOT TO DIRECTLY ASSIGN TO ol!!!!!!!
//ol IS USED TO RETURN THE OBJECTS AND ASSIGNING TO IT WILL NOT CHANGE THE ORIGINAL LIST!!!!!!!!!
//ol MUST BE CHANGED USEING ONLY THE Add/Remove METHODS!!!!!!!!!
//BUG!!!! HACK!!!!

ObjList ol2;
ObjList oll;
Building b;
Unit u;
int i;
str cmd;
int nBuildType;
int nRace;
str tech;
StrArray imperialBuildName, //Classi Roma imperiale. 
		 imperialTech, //Tecnologie fucina imperiale.
         imperialTrainCmd; //Comandi caserma imperiale.
StrArray greekBuildName, //Classi Grecia. 
         greekTrainCmd, //Comandi caserma Grecia.
		 greekTech; //Tecnologie fucina Grecia.
		 
// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

nRace = set.GetCentralBuilding.race;

/** 
if(nRace == RepublicanRome && EnvReadString(set,"ChooseRepublicanRome") == "researched")
{
	imperialTech[0] = "";
	imperialTech[1] = "Roman Archers"; 
	imperialTech[2] = "Roman Gladiator";
	imperialTech[3] = "Roman Principle";
	imperialTech[4] = "Roman Scout";
	imperialTech[5] = "Roman Full Armor";
	
	imperialTrainCmd[0] = "trainRHastatus";
	imperialTrainCmd[1] = "trainRArcher";
	imperialTrainCmd[2] = "trainRGladiator";
	imperialTrainCmd[3] = "trainRPrinciple"; 
	imperialTrainCmd[4] = "trainRScout";
	imperialTrainCmd[5] = "trainRTribune";

	imperialBuildName[0] = "RHastatus";
	imperialBuildName[1] = "RArcher";
	imperialBuildName[2] = "RGladiator";
	imperialBuildName[3] = "RPrinciple";
	imperialBuildName[4] = "RScout"; 
	imperialBuildName[5] = "RTribune";
}	//Fine if.
**/
if(nRace == RepublicanRome && EnvReadString(set,"ChooseImperialRome") == "researched")
{
	/* SEZIONE DEDICATA ALLE TECNOLOGIE DI ROMA IMPERIALE: */
	imperialTech[0] = "";
	imperialTech[1] = "Roman Archers"; 
	imperialTech[2] = "Roman Velit";
	imperialTech[3] = "Roman Principle";
	imperialTech[4] = "Roman Scout";
	imperialTech[5] = "Roman Praetorian";
	/* FINE SEZIONE DEDICATA ALLE TECNOLOGIE DI ROMA IMPERIALE. */

	/* SEZIONE DEDICATA AI COMANDI DI ROMA IMPERIALE: */
	imperialTrainCmd[0] = "trainRHastatus";
	imperialTrainCmd[1] = "trainRArcher";
	imperialTrainCmd[2] = "trainMVelit";
	imperialTrainCmd[3] = "trainRPrinciple"; 
	imperialTrainCmd[4] = "trainRScout";
	imperialTrainCmd[5] = "trainMPraetorian";
	/* FINE SEZIONE DEDICATA AI COMANDI DI ROMA IMPERIALE. */

	/* SEZIONE DEDICATA ALLE CLASSI DI ROMA IMPERIALE: */
	imperialBuildName[0] = "RHastatus";
	imperialBuildName[1] = "RArcher";
	imperialBuildName[2] = "RVelit";
	imperialBuildName[3] = "RPrinciple";
	imperialBuildName[4] = "RScout"; 
	imperialBuildName[5] = "RPraetorian";
	/* FINE SEZIONE DEDICATA ALLE CLASSI DI ROMA IMPERIALE. */
}	//Fine if.
if(nRace == Greece)
{
	/* SEZIONE DEDICATA ALLE TECNOLOGIE DELLA GRECIA: */
	//greekTech[0] = "";          //Di prova: finché non ci saranno tutte le unità.
	greekTech[0] = "Greek Spears";
	greekTech[1] = "Greek Archers";
	greekTech[2] = "Greek Spears";
	greekTech[3] = "Forge Elite Equipment";      //Di prova: finché non ci saranno tutte le unità.
	greekTech[4] = "Greek Chariot Wheels";
	greekTech[5] = "Greek Royal Armor";
	/* FINE SEZIONE DEDICATA ALLE TECNOLOGIE DELLA GRECIA. */

	/* SEZIONE DEDICATA AI COMANDI DELLA GRECIA: */
	//greekTrainCmd[0] = "trainIMilitiaman";        //Di prova: finché non ci saranno tutte le unità.
	greekTrainCmd[0] = "trainHHoplite";
	greekTrainCmd[1] = "trainHToxotes";
	greekTrainCmd[2] = "trainHHoplite";
	greekTrainCmd[3] = "trainHMyrmidon";     //Di prova: finché non ci saranno tutte le unità.
	greekTrainCmd[4] = "trainHChariot";
	greekTrainCmd[5] = "trainHHypaspista";
	/* FINE SEZIONE DEDICATA AI COMANDI DELLA GRECIA. */

	/* SEZIONE DEDICATA ALLE CLASSI DELLA GRECIA: */
	//greekBuildName[0] = "IMilitiaman";       //Di prova: finché non ci saranno tutte le unità.
	greekBuildName[0] = "HHoplite";
	greekBuildName[1] = "HToxotes";
	greekBuildName[2] = "HHoplite";
	greekBuildName[3] = "HMyrmidon_Javelin";     //Di prova: finché non ci saranno tutte le unità.
	greekBuildName[4] = "HChariot"; 
	greekBuildName[5] = "HHypaspista";
	/* FINE SEZIONE DEDICATA ALLE CLASSI DELLA GRECIA. */
}	//Fine if.

if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
{
	int pippo;

	for(pippo = 0; pippo < 6; pippo += 1)
	{
		if(imperialBuildName[pippo] == class)
		{
			nBuildType = pippo;
			break; 
		}	//Fine if.
	}	//Fine del for.
}	//Fine if.
else if(nRace == Greece)
{
	int paperino;
	//pr("paperino ok start");
	
	for(paperino = 0; paperino < 6; paperino += 1)
	{
		if(greekBuildName[paperino] == class)
		{
			nBuildType = paperino;
			break; 
		}	//Fine if.
	}	//Fine del for.	
}	//Fine else if.
else
{
	nBuildType = RUType(class, nRace);
}	//Fine else.

if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
{
	cmd = imperialTrainCmd[nBuildType];
}	//Fine if.
else if(nRace == Greece)
{
	cmd = greekTrainCmd[nBuildType];
}	//Fine else if.
else
{
	cmd = UTrainCmd(nBuildType, nRace);
}

if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
{
	tech = imperialTech[nBuildType];
}	//Fine if.
else if(nRace == Greece)
{
	tech = greekTech[nBuildType];
}	//Fine else if.
else
{
	tech = UTech(nBuildType, nRace);
}

if (num)
{
	//steal from the AI
	oll = GetGAIKA(set.GetCentralBuilding).GetAIControlledUnits(class, set.player, num, false);
	for (i = 0; i < oll.count; i += 1)
	{
		u = oll[i].AsUnit;
		if (u.IsAlive)
		{
			if (u.hero.IsValid)
			{
				u.DetachFrom(u.hero);
			}
			ol2.Add(u);
		}
	}
	num -= ol2.count;
}

if (num)
{
	//count how many are queued
	ObjList barracks;
	barracks = set.TSGetAllBarracks();

	for (i = 0; i < barracks.count; i+=1)
	{
		num -= barracks[i].CmdCount(cmd);
	}
}

//issue commands
if (tech!="")
if (IsResearched(set, tech))
	tech = "";

if (tech == "")
{
	for (i = 0; i < num; i+=1)
	{
		int gold, food;
		
		if(nRace == Greece)
		{
			/* INDIVIDUO LA CASERMA FRA LE STRUTTURE GRECHE: */
			ObjList struttureInsediamento;
			int bCounter;
			
			struttureInsediamento = set.Buildings();
			
			for(bCounter = 0; bCounter < struttureInsediamento.count(); bCounter += 1)
			{
				//pr(struttureInsediamento[bCounter].race);
				if(struttureInsediamento[bCounter].class == "HBarracks")
				{
					b = struttureInsediamento[bCounter];
					break;
				}	//Fine if.
			}	//Fine del for.	
		}	//Fine if.
		else 
		{
			b = set.BestBarrack(100);
		}	//Fine else.
		
		if (b.IsValid())
		{
			if (nRace == Carthage)
			{
				if (!IsResearched(set, UTech(nBuildType, nRace)))
				{
					cmd = cmd + "NonSpec";
				}
			}

			if (GetCmdCost(cmd, gold, food))
			{
				point ptDummy;
				Obj objDummy;

				if (set.gold < gold || set.food < food)
					break;
				set.SpentGoldOnArmy((gold + (food / 2)) * i);
				b.ExecCmd(cmd, ptDummy, objDummy, false);
			}
		}
	}
}

SetNoAIFlag(ol2, true);
ol.AddList(ol2);
