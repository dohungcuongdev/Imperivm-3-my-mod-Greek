// void, Settlement set

int   AIPlayer, nRace;
bool  bRush;
bool  bLogPlayer;
int   nNeedTraining;
bool  bResearch;
StrArray imperialTrainCmd, //Comandi caserma imperiale.
		 imperialTech; //Tecnologie fucina imperiale.
StrArray greekTrainCmd, //Comandi caserma greca.
         greekTech; //Tecnologie fucina greca.

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;	 

// sleep must be more than tactic script initial sleep
Sleep(1000); 

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;
EnvWriteInt(set, "gSellFood", 0);
EnvWriteInt(set, "nArmyBuilds", 0);	/// the amount of times ESH_BuildArmy is called
bLogPlayer = UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);

/** 
if(nRace == RepublicanRome && EnvReadString(set, "ChooseRepublicanRome") == "researched")
{
	imperialTrainCmd[0] = "trainRHastatus"; 
	imperialTrainCmd[1] = "trainRArcher";
	imperialTrainCmd[2] = "trainRGladiator";
	imperialTrainCmd[3] = "trainRPrinciple";
	imperialTrainCmd[4] = "trainRScout";
	imperialTrainCmd[5] = "trainRTribune";

	imperialTech[0] = "";
	imperialTech[1] = "Roman Archers";
	imperialTech[2] = "Roman Gladiator";
	imperialTech[3] = "Roman Principle";
	imperialTech[4] = "Roman Scout";
	imperialTech[5] = "Roman Full Armor";
}	//Fine if.
**/

if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
{
	imperialTrainCmd[0] = "trainRHastatus"; 
	imperialTrainCmd[1] = "trainRArcher";
	imperialTrainCmd[2] = "trainMVelit";
	imperialTrainCmd[3] = "trainRPrinciple";
	imperialTrainCmd[4] = "trainRScout";
	imperialTrainCmd[5] = "trainMPraetorian";
	
/* 	imperialUType[0] = "RHastatus"; 
	imperialUType[1] = "RArcher"; 
	imperialUType[2] = "RVelit"; 
	imperialUType[3] = "RPrinciple"; 
	imperialUType[4] = "RScout"; 
	imperialUType[5] = "RPraetorian";  */

	imperialTech[0] = "";
	imperialTech[1] = "Roman Archers";
	imperialTech[2] = "Roman Velit";
	imperialTech[3] = "Roman Principle";
	imperialTech[4] = "Roman Scout";
	imperialTech[5] = "Roman Praetorian";
}	//Fine if.

if(nRace == Greece)
{
	//greekTrainCmd[0] = "trainIMilitiaman"
	greekTrainCmd[0] = "trainHHoplite";                 //Di prova: finché non ci saranno tutte le unità.
	greekTrainCmd[1] = "trainHToxotes";
	greekTrainCmd[2] = "trainHHoplite";
	greekTrainCmd[3] = "trainHMyrmidon";               //Di prova: finché non ci saranno tutte le unità.
	greekTrainCmd[4] = "trainHChariot";
	greekTrainCmd[5] = "trainHHypaspista";
	greekTrainCmd[6] = "trainEHOPLITA";
	
	//greekTech[0] = "";
	greekTech[0] = "Greek Spears";                       //Di prova: finché non ci saranno tutte le unità.
	greekTech[1] = "Greek Archers";
	greekTech[2] = "Greek Spears";
	greekTech[3] = "Forge Elite Equipment";                  //Di prova: finché non ci saranno tutte le unità.
	greekTech[4] = "Greek Chariot Wheels";
	greekTech[5] = "Greek Royal Armor";
	greekTech[6] = "Wall of Shields";
}	//Fine if.

/// training rush
if (nRace == Gaul)
{
	if (rand(100) < AIVar(AIPlayer, AIV_TrainingRush)) 
	{
		EnvWriteInt(AIPlayer, "NeedTraining", 1);
		if (bLogPlayer)
		if (AIVar(AIPlayer, AIV_LogArmy) != 0)
			pr ("Player " + AIPlayer + " makes training rush");
	}
}

nNeedTraining = EnvReadInt(AIPlayer, "NeedTraining") == 1;

//if (nRace == Rome) SetAIVar(AIPlayer, AIV_ArenaRush, 100); //!!!


if (nRace == Gaul)
if (AIVar(AIPlayer, AIV_GTRush) != 0)
if (EnvReadInt(set, "ArenaRush") == 0) 
{
	EnvWriteInt(set, "GTRush", (rand(100) < AIVar(AIPlayer, AIV_GTRush)));
	if (SettlementCount(set.GetCentralBuilding.pos, 6500, "BaseVillage")<=2)
		EnvWriteInt(set, "GTRush", 1);
}

if (bLogPlayer)
if (AIVar(AIPlayer, AIV_LogRush) != 0)
{
	if (EnvReadInt(set, "ArenaRush") != 0)
		pr("Player " + AIPlayer + " will start with arena rush!");
	if (EnvReadInt(set, "GTRush") != 0)
		pr("Player " + AIPlayer + " will start with GT rush!");
}

/// RestartEconomyScript is for debug purpose only -> it stops the current script and starts the new one.
/// -> EnvWriteInt(sels, "RestartEconomyScript", 1)

while (set.player == AIPlayer && EnvReadInt(set, "RestartEconomyScript") == 0)
{
	bool bHireHero, bMilUnits, bTrain, bAssUnderFire, bEnemies;
	int  nFreezeArmyBuild;
	int  nTrainStart;
	int  nMilUnits, nMilEval, nAllyMilEval;
	int  nEnemyMilEval, nMinEnemyEval, nMaxEnemyEval, nAverEnemyEval;
	int  i, nHeroes, nUnattachedMilUnitsAtHome = 0;
	int  nArenaResearchLevel;
	int  nArenaHire, nArenaComplete;
	bool bFreezeArmyBuild = false;
	bool bInvestMoney = true;

	bLogPlayer = UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer); /// could be set in the game
	nTrainStart = AIVar(AIPlayer, AIV_Training);
	nArenaResearchLevel = EnvReadInt(set, "ArenaResearchLevel");
	nArenaHire = AIVar(AIPlayer, AIV_ArenaHire);
	nArenaComplete = EnvReadInt(set, "ArenaComplete");

	nMilUnits = MilUnits(AIPlayer);
	nMilEval = MilEval(AIPlayer);
	nAllyMilEval = AllyMilEval(AIPlayer);
	nEnemyMilEval = EnemyPlayersEval(AIPlayer, nMinEnemyEval, nMaxEnemyEval, nAverEnemyEval);
	if (nMilEval < nAverEnemyEval || nAllyMilEval < nEnemyMilEval)
		bInvestMoney = false;

	i = nMilUnits / Strongholds(AIPlayer);
	if (i < set.Units.count)
		i = set.Units.count;
	EnvWriteInt(set, "nFoodReserve", i * 20); /// used in some of the scripts called from here

	// freeze army build counter
	nFreezeArmyBuild = EnvReadInt(set, "FreezeArmyBuild");
	if (nFreezeArmyBuild > 0)
	{
		nFreezeArmyBuild -= 1;
		EnvWriteInt(set, "FreezeArmyBuild", nFreezeArmyBuild);
		if (nFreezeArmyBuild == 0)
		if (bLogPlayer)
		if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0)
			pr("Player " + AIPlayer + " enables army build (gave up)");
	}
	bRush = (set.TacticScript != TS_NONE);

	{	// check "ass under fire"
		int nOwn, nAlly, nEnemy, enemy_hidden;
		set.GetGaika.Eval(AI_ALL, AIPlayer, nOwn, nAlly, nEnemy, enemy_hidden);
		bEnemies = (nEnemy > 0);
		bAssUnderFire = (nEnemy > nOwn + nAlly);
	}
	if (bAssUnderFire)
	{
		int nAssUnderFire; nAssUnderFire = 1 + EnvReadInt(set, "AssUnderFire");
		EnvWriteInt(set, "AssUnderFire", nAssUnderFire);
		if (nAssUnderFire > 10)
			set.StopReserving;
		if (bLogPlayer)
		if (AIVar(AIPlayer, AIV_LogAUF) != 0)
			if (nAssUnderFire == 1)
				pr("Player " + AIPlayer + " ass under fire!");
			else if (nAssUnderFire == 11)
				pr("Player " + AIPlayer + " ASS STILL UNDER FIRE!");
	} 
	else 
	{
		if (bLogPlayer)
		if (AIVar(AIPlayer, AIV_LogAUF) != 0)
		if (EnvReadInt(set, "AssUnderFire") != 0)
			pr("Player " + AIPlayer + " ass no longer under fire");
		EnvWriteInt(set, "AssUnderFire", 0);
	}

	// check whether to build military units
	bMilUnits = true;
	if (AIVar(AIPlayer, AIV_BuildArmy) == 0)
		bMilUnits = false;
	else
	{
		i = AIVar(AIPlayer, AIV_MaxMilUnits);
		if (i < 0) ;
		else if (i == 0) bMilUnits = false;
		else if (nMilUnits >= i) bMilUnits = false;

		if (bMilUnits) 
		{
			i = AIVar(AIPlayer, AIV_MaxMilEval);
			if (i < 0) ;
			else if (i == 0) bMilUnits = false;
			else if (MilEval(AIPlayer) >= i) bMilUnits = false;
		}
	}
	
	/// prefer to build arena units when the arena is upgraded
	if (nArenaResearchLevel >= 2)
	if (nArenaHire > 0)
	if ( nRace == Gaul || ( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") ) )
	{
		set.AIRun("ESH_ArenaUnits.vs");
		nArenaComplete = EnvReadInt(set, "ArenaComplete");
		if (nArenaComplete < 1)
		{
			nArenaHire = 0; // disable calling arena again below
			if (!bAssUnderFire)
			bFreezeArmyBuild = true;
		}
	}
	
	// hero support
	bHireHero = false;
	if (bMilUnits)
	if (!bFreezeArmyBuild)
	if (!bRush)
	{
		SquadList  sl;
		bHireHero = true;
		nUnattachedMilUnitsAtHome = 0;
		nHeroes = 0;
		set.GetGaika.GetSquads(sl, AI_STAYING + AI_COMING, AIPlayer, AI_OWN);
		while (!sl.EOL && bHireHero)
		{
			Hero hero;
			Squad squad; squad = sl.Cur; sl.Next;
			if (squad.TestFlags(SF_PEACEFUL + SF_NOAI)) 
				continue;
			if (squad.Leader.GetFlags(UNITFLAG_NOAI)) 
				continue;
			hero = squad.Leader.AsHero();
			if (!hero.IsValid)	
			{
				if (!squad.Leader.HasFreedom)
					nUnattachedMilUnitsAtHome += squad.Size;
				continue;
			}
			nHeroes += 1;
			if (hero.army.count * 90 < hero.maxarmy * 100)
				bHireHero = false;
		}
		if (bHireHero)
		if (nHeroes >= 1)
		if (nUnattachedMilUnitsAtHome == 0)
			bHireHero = false;
		if (bHireHero && nHeroes > 1)
		{
			int nPerc; nPerc = HeroArmiesFullPerc(set.player);
			if (nPerc < 70)
				bHireHero = false;
		}
	}
	if (bHireHero)
	{
		int gold, food;
		str cmd;
		cmd = "hirehero" + GetRaceStrPref(nRace);
		if ( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
		{
			cmd = "hireheroRImperial";
		}	//End if.

		if (GetCmdCost(cmd, gold, food))
		if (set.CanAfford(cmd))
		{
			if (nHeroes <= 0)
			if (set.CanResearch(cmd))
			{
				str strTech;
				if ( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
				if (AIVar(AIPlayer, AIV_Research) > 0)
				if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount))
				if (!IsResearched(set, "Military Academy")) 
				{
					if (!IsResearched(set, "RGladiator Shows2")) strTech = "RGladiator Shows2";
					else strTech = "Military Academy";
					EnvWriteString(set, "strTech", strTech);
					set.AIRun("ESH_NeedTech.vs");
					if (IsResearching(set, strTech))
						bHireHero = false;
				}	//Fine if.
				
				// Grecia -> Preparazione militare.
				// if(nRace == Greece && AIVar(AIPlayer, AIV_Research) > 0 && set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount) )
				if(nRace == Greece)
				{
					if (IsResearched(set, "Military Preparation") == false)
					{
						if (IsResearched(set, "Olympic Games") == false) 
						{
							strTech = "Olympic Games";
						}	//Fine if.
						else
						{
							if(EnvReadInt(set, "AI_ChooseGreekGovernment") == 0)
							{
								if(rand(2) == 0) 
								{
									strTech = "Democracy";
								}	//Fine if.	
								else
								{
									strTech = "Oligarchy";
								}	//Fine else.	
								
								EnvWriteInt(set, "AI_ChooseGreekGovernment", 1);
								EnvWriteString(set, "strTech", strTech);
								set.AIRun("ESH_NeedTech.vs");
							}
							strTech = "Military Preparation";
						}	//Fine else.
						
						EnvWriteString(set, "strTech", strTech);
						set.AIRun("ESH_NeedTech.vs");
						if (IsResearching(set, strTech) == true)
						{
							bHireHero = false;
						}	//Fine if.
					}	//Fine if.
					else {
						// barrack upgrade
						if(IsResearched(set, "Barrack Level 1") == false)
						{
							set.Research("Barrack Level 1");
						}	//Fine if.
						else if(IsResearched(set, "Barrack Level 2") == false)
						{
							set.Research("Barrack Level 2");
						}	//Fine else if.
						else if(IsResearched(set, "Barrack Level 3") == false)
						{
							set.Research("Barrack Level 3");
						}	//Fine else if.
						EnvWriteString(set, "strTech", strTech);
						set.AIRun("ESH_NeedTech.vs");
					}	//Fine if.
				}	//Fine if.
				
				if (nRace == Egypt)
				if (AIVar(AIPlayer, AIV_Research) > 0)
				if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount))
				if (!IsResearched(set, "Mumification")) 
				{
					if (!IsResearched(set, "Cult of Horus")) strTech = "Cult of Horus";
					else strTech = "Mumification";
					EnvWriteString(set, "strTech", strTech);
					set.AIRun("ESH_NeedTech.vs");
					if (IsResearching(set, strTech))
						bHireHero = false;
				}
				if (bHireHero) 
				{
					if (bLogPlayer)
					if (AIVar(AIPlayer, AIV_LogHeroes) != 0)
						pr("Player " + AIPlayer + " hires new hero");
					set.SpentGoldOnArmy(gold + (food / 2));
					set.Research(cmd);
				}
			}
			bHireHero = false;
		}
	}

	// build army in barracks
	if (bMilUnits)
	{
		if (!bFreezeArmyBuild)
		if (!bHireHero || set.gold > 1000 && bAssUnderFire)
		if (bAssUnderFire || nFreezeArmyBuild == 0)
		{
			Barrack barrack;
			str cmd;
			int gold, food, nBuildType;
			int nCount;	

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
						barrack = struttureInsediamento[bCounter];
						break;
					}	//Fine if.
				}	//Fine del for.	
			}	//Fine if.
			else 
			{
				barrack = set.BestBarrack(5);
			}	//Fine else.
			
			if (nRace == Carthage)
			{
				nCount = EnvReadInt(set, "nBuildCount");
				nBuildType = EnvReadInt(set, "nBuildType");
				if (nCount > 0) 
				{
					if (nBuildType == 5)
						barrack = set.FindResearchLab(UTrainCmd(5, Carthage));
				}
			}
			
			if (barrack.IsValid())
			{
				if (barrack.CmdCount < 5)
				{	
					/// available barrack
					nCount = EnvReadInt(set, "nBuildCount");
					nBuildType = EnvReadInt(set, "nBuildType");
					
					if (nCount <= 0)
					if (barrack.command == "idle")
					{	/// ask for new units to build
						if (nRace == Germany)
							set.AIRun("ESH_BuildGermanArmy.vs");
						else
							set.AIRun("ESH_BuildArmy.vs");
						
						nCount = EnvReadInt(set, "nBuildCount");
						nBuildType = EnvReadInt(set, "nBuildType");

						if (nCount > 0) 
						{
							EnvWriteInt(set, "nArmyBuilds", 1 + EnvReadInt(set, "nArmyBuilds"));
							
							if (nRace == Carthage)
							{
								if (nBuildType == 5)
									barrack = set.FindResearchLab(UTrainCmd(5, Carthage));
							}
						}
					}
					
					// delay building waiting a research to complete
					if (nCount > 0)
					if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
					if (IsResearching(set, "Standartization I") || IsResearching(set, "Standartization II"))
						nCount = 0; // wait a little bit
					if (nCount > 0)
					if (nRace == Egypt)
					if (IsResearching(set, "Light of Horus I") || IsResearching(set, "Light of Horus II") || IsResearching(set, "Light of Horus III"))
						nCount = 0; // wait a little bit
					if (nCount > 0)
					if (nRace == Britain)
					if (IsResearching(set, "Britain Fights"))
						nCount = 0; // wait a little bit
					
					if (nCount > 0)
					{
						if (barrack.IsValid())
						{
							if (barrack.command == "idle")
							{
								if(nRace == RepublicanRome && EnvReadString(set, "ChooseImperialRome") == "researched")
								{
									cmd = imperialTrainCmd[nBuildType];
								}	//Fine if.
								else if(nRace == Greece)
								{
									cmd = greekTrainCmd[nBuildType];
									//pr("comando = " + cmd);
								}	//Fine else if.
								else
								{
									cmd = UTrainCmd(nBuildType, nRace);
								}	//Fine else.
								
								if (nBuildType >= 0)
								if (nBuildType < 5)
								if (nRace == Carthage)
								{
									if (!IsResearched(set, UTech(nBuildType, nRace))) 
										cmd = cmd + "NonSpec";
								}
								
								if (GetCmdCost(cmd, gold, food))
								{
									i = set.MaxAffordCount(cmd);
									
									if (i > nCount) i = nCount;
									if (i > 5) i = 5;
									if (i > 0)
									{
										nCount -= i;
										EnvWriteInt(set, "nBuildCount", nCount);
										set.SpentGoldOnArmy((gold + (food / 2)) * i);
										for (0; i > 0; i -= 1) 
										{
											point ptDummy; Obj objDummy;
											barrack.ExecCmd(cmd, ptDummy, objDummy, false);
										}
									}
								}
							}
						}
					}
				}	
			}
		}
	}	//Fine if.
	if (set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount))
 	if (AIVar(AIPlayer, AIV_DonateGold) > 0)
 	if (AIVar(AIPlayer, AIV_Research) > 0)
 	{
		str strTech = "";
 		if (nRace == Carthage) 
		{
			if (!IsResearched(set, "Sacred Legion")) strTech = "Sacred Legion";
 		} 
		else 
		{
 			int nType;
			
			set.AIRun("ESH_EnabledUnits.vs");
			
			if (EnvReadInt(set, "TechSeq" + AIPlayer + "_Initted") == 0)
				set.AIRun("ESH_ArmyTechSeq.vs"); /// decide "research sequence" as numbers in [1..5]
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
				strTech = "";
			}
 		}
		if (strTech != "") 
		{
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
		}
 	}
 	// Strenghten defence
 	if (!IsResearched(set, "Strenghten Stronghold Defences I")) 
	{
 		if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount) ||
 		    GetTime > 60000 * AIVar(AIPlayer, AIV_TimeStrongholdDefences1))
		{
			EnvWriteString(set, "strTech", "Strenghten Stronghold Defences I");
			set.AIRun("ESH_NeedTech.vs");
		}
 	}
 	else if (!IsResearched(set, "Strenghten Stronghold Defences II")) 
	{
 		if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount) ||
 		    GetTime > 60000 * AIVar(AIPlayer, AIV_TimeStrongholdDefences2))
		{
			EnvWriteString(set, "strTech", "Strenghten Stronghold Defences II");
			set.AIRun("ESH_NeedTech.vs");
		}
 	}
	//Strenghten Stronghold Gates (Only Greece!)
	if(nRace == Greece)
	{
		 if (IsResearched(set, "Strenghten Stronghold Gates") == false) 
		{
			if ( (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount)) 
			    || (GetTime > 60000 * AIVar(AIPlayer, AIV_TimeStrenghtenStrongholdGates)) )
			{
				EnvWriteString(set, "strTech", "Strenghten Stronghold Gates");
				set.AIRun("ESH_NeedTech.vs");
			}	//Fine if.
		}	//Fine if.
	}	//Fine if.

	if (!bEnemies)
	if (EnvReadInt(set, "AIV_NoRepair") == 0)
		set.RepairAll;

	// barrack upgrade
	if(nRace == Greece)
	if(IsResearched(set, "Barrack Level 1") == false)
	{
		set.Research("Barrack Level 1");
	}	//Fine if.
	else if(IsResearched(set, "Barrack Level 2") == false)
	{
		set.Research("Barrack Level 2");
	}	//Fine else if.
	else if(IsResearched(set, "Barrack Level 3") == false)
	{
		set.Research("Barrack Level 3");
	}	//Fine else if.
	
	
	if (AIVar(AIPlayer, AIV_DonateGold) > 0)
	if (AIVar(AIPlayer, AIV_UpgradeBarracks) != 0)
	if (!bAssUnderFire)
	if (set.gold >= 500)
	{
		if(nRace != Greece)
		{
			if (set.gold > 10000)
			{
				set.UpgradeBestBarrack(0);
			}	//Fine if.
			else
			{
				set.UpgradeBestBarrack(8);
			}	//Fine else.
		}	//Fine if.
		else 
		{
			if(IsResearched(set, "Barrack Level 1") == false)
			{
				set.Research("Barrack Level 1");
			}	//Fine if.
			else if(IsResearched(set, "Barrack Level 2") == false && MilUnits(AIPlayer) >= 30 && set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount))
			{
				set.Research("Barrack Level 2");
			}	//Fine else if.
			else if(IsResearched(set, "Barrack Level 3") == false && MilUnits(AIPlayer) >= 60 && set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount))
			{
				set.Research("Barrack Level 3");
			}	//Fine else if.
		}	//Fine if.		
	}	//Fine if.
	
	// market/tavern upgrades
	set.AIRun("ESH_Market.vs");

	// gold trade
	i = AIVar(AIPlayer, AIV_TradeGold);
	if (i > 0)
	if (AIVar(AIPlayer, AIV_DonateGold) > 0)
	if (set.gold > 1000)
	if (bInvestMoney)
		set.AIRun("ESH_GoldTrade.vs");
 
	// training
	bResearch = false;
	bTrain = false;
	if (AIVar(AIPlayer, AIV_DonateGold) > 0)
	if (nTrainStart > 0)
		if (set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount))
			bResearch = true;
		else
			if (!bAssUnderFire)
			if (nNeedTraining > 0)
			if (!bFreezeArmyBuild)
			if (nMilUnits >= nTrainStart)
				bResearch = true;
	if (bResearch) 
	{
		bTrain = true;
		set.AIRun("ESH_ResearchTraining.vs");
		if (EnvReadInt(set, "ResearchTrainingComplete") != 0) 
		{
			EnvWriteInt(AIPlayer, "NeedTraining", 2);
			nNeedTraining = 2;
			bTrain = false;
		}
	}

	bResearch = false;
	i = AIVar(AIPlayer, AIV_CombatMagic);
	if (AIVar(AIPlayer, AIV_DonateGold) > 0)
	if (i > 0)
		if (set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount))
			bResearch = true;
		else
			if (!bAssUnderFire)
			if (!bTrain)
				bResearch = true;
	if (bResearch)
		set.AIRun("ESH_CombatMagic.vs"); 

	bResearch = false;
	i = AIVar(AIPlayer, AIV_Druids);
	if (i > 0)
	if (bMilUnits)
		if (set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount))
			bResearch = true;
		else
			if (!bAssUnderFire)
				bResearch = true;
	if (bResearch)
	{
		bool bDruids;
		bDruids = nMilUnits >= 20 && (!bTrain || set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount));
		if (!bDruids)
		if (nRace == Iberia)
		if (Count(AIPlayer, "IEnchantress") * 10 < nMilUnits)
			bDruids = true;
		if (bDruids)
			set.AIRun("ESH_Druids.vs");
	}

	bResearch = false;
	if (nArenaHire > 0)
		if (set.gold > AIVar(AIPlayer, AIV_SquanderGoldAmount))
			bResearch = true;
		else
			if (!bAssUnderFire)
			if (!bTrain)
			if (nMilUnits >= nArenaHire)
				bResearch = true;
	if (bResearch)
		set.AIRun("ESH_ArenaUnits.vs");

	// check if we need overall training
	if (nTrainStart > 0)
	if (!bAssUnderFire)
	if (EnvReadInt(AIPlayer, "NeedTraining") == 0)
	if (nMilUnits >= nTrainStart)
	if (set.gold > 10000 || rand(30) == 0 || nArenaComplete != 1)
	//if (NeedTraining(AIPlayer))
		{ EnvWriteInt(AIPlayer, "NeedTraining", 1); nNeedTraining = 1; }

	// sleep
	Sleep(AIVar(AIPlayer, AIV_Sleep_ES));
}

EnvWriteInt(set, "RestartEconomyScript", 0);
