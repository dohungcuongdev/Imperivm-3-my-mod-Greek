// int, Settlement set, int idPlayer

int nRace;
int player;
int rnd;

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

if (!set.IsStronghold)
	return TS_NONE;

nRace = set.GetCentralBuilding.race;
player = set.player;

if (GetTime<2000)
{
	rnd = rand(100);

	if (nRace == Gaul)
	{
		if(set.population > 1500) {
			return TS_GaulTactic3;  // AI is stronger than strongest AI if population is higher (maybe lag in game)
		} else
		if(set.population > 250) {
			return TS_StrongestTactic;// AI is strongest AI
		} else {
			if (rnd<33)	
				return TS_GaulTactic;
			if (rnd<66)	
				return TS_GaulTactic2;
		}
	}
	
	if (nRace == Iberia)
	{
		if(set.population > 1500) {
			return TS_IberianTactic3;  // AI is stronger than strongest AI if population is higher (maybe lag in game)
		} else
		if(set.population > 250) {
			return TS_StrongestTactic;// AI is strongest AI
		} else {
			/**if (rnd<33)	
				return TS_IberianTactic;
			if (rnd<66)	
				return TS_IberianTactic2;
			*/
			if (set.population > 80)
				return TS_IberianTactic;
			else
				return TS_IberianTactic2;
		}
	}

	if (nRace == Germany)
	{
		if(set.population > 1500) {
			return TS_GermanyTactic3; // AI is stronger than strongest AI if population is higher (maybe lag in game)
		} else
		if(set.population > 250) {
			 return TS_StrongestTactic;// AI is strongest AI
		}
		else {
			if (rnd<33)	
				return TS_GermanyTactic;
			if (rnd<66)	
				return TS_GermanyTactic2;
		}
	}

	if (nRace == Egypt)
	{
		if(set.population > 1500) {
			return TS_EgyptTactic3;  // AI is stronger than strongest AI if population is higher (maybe lag in game)
		} else
		if(set.population > 250) {
			return TS_StrongestTactic;// AI is strongest AI
		}
		else { 
			if (rnd<50)	
				return TS_EgyptTactic;
		}
	}

	if (nRace == Britain)
	{
		if(set.population > 1500) {
			return TS_BritishTactic3; // AI is stronger than strongest AI if population is higher (maybe lag in game)
		} else
		if(set.population > 250) {
			return TS_StrongestTactic;// AI is strongest AI
		} else {
			if (rnd<50)	
				return TS_BritishTactic;
		}
	}

	if (nRace == Carthage)
	{
		if(set.population > 1500) {
			return TS_CarthageTactic3;  // AI is stronger than strongest AI if population is higher (maybe lag in game)
		} else
		if(set.population > 250) {
			return TS_StrongestTactic;// AI is strongest AI
		} 
		else {
			if (rnd<33)	
				return TS_CarthageTactic;		
			if (rnd<66)	
				return TS_CarthageTactic2;
		}					
	}
	if (nRace == RepublicanRome) //Roma Repubblicana o Roma Imperiale.
	{	
		/* L'AI SCEGLIE SE GIOCARE CON ROMA REPUBBLICANA O CON ROMA IMPERIALE: */
		if(EnvReadInt(set, "ChooseRomanRace") == 0)
		{
			int random;
			int REPUBLICAN = 0;
			int IMPERIAL = 1;
			                                            
			if (EnvReadString(set, "AI_AIlovesRome") == "Republican")
			{
				random = REPUBLICAN;
			}	//End if.
			else if (EnvReadString(set, "AI_AIlovesRome") == "Imperial")
			{
				random = IMPERIAL;
			}	//End else if.
			else
			{
				random = rand(2);
			}	//End else.
			
			if (random == REPUBLICAN)
			{
				EnvWriteString(set, "ChooseRepublicanRome", "researched");
				EnvWriteInt(set, "ChooseRomanRace", 1);
				//pr("Il giocatore " + player + " ha scelto Roma Repubblicana");
			}	//End if.
			if (random == IMPERIAL)
			{
				EnvWriteString(set, "ChooseImperialRome", "researched");
				EnvWriteInt(set, "ChooseRomanRace", 1);
				//pr("Il giocatore " + player + " ha scelto Roma Imperiale");
			}	//End if.
		}	//End if.
		/* FINE L'AI SCEGLIE SE GIOCARE CON ROMA REPUBBLICANO O CON ROMA IMPERIALE. */

		/* ESECUZIONE DI UNA TATTICA ROMANA DA PARTE DELLA AI: */
		if (EnvReadString(set, "ChooseRepublicanRome") == "researched")
		{
			/**
			if (rnd < 50)
			{
				return TS_RRomeTactic;	
			}	//End if.
			*/
			
			/**
			if (rnd<33) // add other script for AI
			{	
				return TS_RRomeTactic2;		
			}	//End if.
			if (rnd<66)	
			{
				return TS_RRomeTactic;
			}	//End if.
			*/
			if(set.population > 1500) { // AI is stronger than strongest AI if population is higher (maybe lag in game)
				return TS_RRomeTactic3;
			} else
			if(set.population > 250)
			{
				return TS_StrongestTactic;// AI is strongest AI
				//End if.
			}
			else if(set.population > 100) // AI is stronger if population is high 
			{
				return TS_RRomeTactic2;
				//End if.
			}
			else 
			{
				return TS_RRomeTactic;
				//End if.
			}
		}	//End if.
		if (EnvReadString(set, "ChooseImperialRome") == "researched")
		{
			/**
			if (rnd<33)
			{	
				return TS_MRomeTactic;		
			}	//End if.
			if (rnd<66)	
			{
				return TS_MRomeTactic2;
			}	//End if.
			*/
			if(set.population > 1500) {
				return TS_MRomeTactic3; // AI is stronger than strongest AI if population is higher (maybe lag in game)
			} else
			if(set.population > 250) { 
				return TS_StrongestTactic;// AI is strongest AI
			}
			else if(set.population > 100) // AI is stronger if population is high 
			{
				return TS_MRomeTactic2;
				//End if.
			}
			else 
			{
				return TS_MRomeTactic;
				//End if.
			}
		}	//End if.	
		/* FINE ESECUZIONE DI UNA TATTICA ROMANA DA PARTE DELLA AI. */	
	}	//End if.
	// if(nRace == Greece)
	// {
	// }	//Fine if.
}

return TS_NONE;
