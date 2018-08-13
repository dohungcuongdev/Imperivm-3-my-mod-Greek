// void, Settlement set

int AIPlayer, nRace, nAvail;
str strTech;
// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

strTech = "";
AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;

nAvail = -1;

///--- Roman upgrade that could be made without priests
if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseRepublicanRome") == "researched") )
if (IsResearched(set, "Altar of Jupiter"))
if (!IsResearched(set, "God's Gift"))
if (rand(20) == 0 || set.gold >= 6000)
{
	EnvWriteString(set, "strTech", "God's Gift"); 
	set.AIRun("ESH_NeedTech.vs");
	return;
}

if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
if (IsResearched(set, "Altar of Jupiter"))
if (!IsResearched(set, "God's Strength"))
if (rand(20) == 0 || set.gold >= 6000)
{
	EnvWriteString(set, "strTech", "God's Strength"); 
	set.AIRun("ESH_NeedTech.vs");
	return;
}

///--- Tecnologie greche che possono essere fatte senza dover avere necessariamente dei preti:
if(nRace == Greece)
{
	if (IsResearched(set, "Offer to Gods") == true)
	{
		//Ricerca Statue of Zeus: "All moribund warriors kill an enemy have 50% chance to fully recovering his health"
		if (IsResearched(set, "Statue of Zeus") == false) 
		{
			if( (rand(20) == 10) || (set.gold >= 5000) )
			{
				EnvWriteString(set, "strTech", "Statue of Zeus"); 
				set.AIRun("ESH_NeedTech.vs");
			}	//Fine if.
		}	//Fine if.
		
		if (IsResearched(set, "HRestoration") == false) 
		{
			if( (rand(20) == 10) || (set.gold >= 5000) )
			{
				EnvWriteString(set, "strTech", "HRestoration"); 
				set.AIRun("ESH_NeedTech.vs");
			}	//Fine if.
		}
		
		///Protection of Apollo
		/* ---------- PENSARE IN CHE OCCASIONE RENDERE INDISTRUTTIBILE LA PORTA ------------- */
	}	//Fine if.
}	//Fine if.

///--- specify technology
if (nRace == Gaul)
{
	if (!IsResearched(AIPlayer, "Ghoul Summoning"))  strTech = "Ghoul Summoning";
	else if (!IsResearched(AIPlayer, "Restoration")) strTech = "Restoration";
	else return;
	if (!IsResearched(set, "Ritual Chamber"))        strTech = "Ritual Chamber";
	nAvail = Count(AIPlayer, "GDruid");
}
if(nRace == RepublicanRome)
{
	if (!IsResearched(AIPlayer, "Cloud of Plague"))       strTech = "Cloud of Plague";
	else if (!IsResearched(AIPlayer, "Wrath of Jupiter")) strTech = "Wrath of Jupiter";
	else return;
	if (!IsResearched(set, "Altar of Jupiter"))           strTech = "Altar of Jupiter";
	nAvail = Count(AIPlayer, "RPriest");
}
if(nRace == Greece)
{
	if(IsResearched(AIPlayer, "Greek Mass Heal") == false) 
		strTech = "Greek Mass Heal";
	else
		return;
	if (IsResearched(set, "Offer to Gods") == false)           
		strTech = "Offer to Gods";
	
	nAvail = Count(AIPlayer, "HPriest");
}	//Fine if.
if (nRace == Carthage)
{
	if (!IsResearched(AIPlayer, "Zombify")) strTech = "Zombify";
	else return;
	if (!IsResearched(set, "Dark Rituals")) strTech = "Dark Rituals";
	nAvail = Count(AIPlayer, "CShaman");
}
if (nRace == Iberia)
{
	if (!IsResearched(AIPlayer, "Cover of Mercy"))         strTech = "Cover of Mercy";
	else if (!IsResearched(AIPlayer, "Iberian Mass Heal")) strTech = "Iberian Mass Heal";
	else return;
	if (!IsResearched(AIPlayer, "Code of Valor"))          strTech = "Code of Valor";
	nAvail = Count(AIPlayer, "IEnchantress");
	if (!IsResearched(AIPlayer, "Cover of Mercy"))
		nAvail = 3 * nAvail; /// boost combat upgrades because enchantress can only train
}
if (nRace == Britain)
{
	if (!IsResearched(AIPlayer, "Britain Ghoul Summoning")) strTech = "Britain Ghoul Summoning";
	else if (!IsResearched(AIPlayer, "Britain Mass Heal"))  strTech = "Britain Mass Heal";
	else return;
	if (!IsResearched(set, "Britain chamber"))              strTech = "Britain chamber";
	nAvail = Count(AIPlayer, "BDruid");
	if (!IsResearched(AIPlayer, "Britain Ghoul Summoning"))
		nAvail = 3 * nAvail; /// boost combat upgrades because BDruids can only hide units
}
if (nRace == Egypt)
{
	if (!IsResearched(AIPlayer, "ECloud of Plague")) strTech = "ECloud of Plague";
	else if (!IsResearched(AIPlayer, "EZombify"))    strTech = "EZombify";
	else return;
	if (!IsResearched(set, "Cult of Osiris"))        strTech = "Cult of Osiris";
	nAvail = Count(AIPlayer, "EPriest");
}
if (nRace == Germany)
{
	if (!IsResearched(AIPlayer, "German Mass Heal")) strTech = "German Mass Heal";
	else return;
	if (!IsResearched(set, "German chamber"))        strTech = "German chamber";
	nAvail = Count(AIPlayer, "TEnchantress");
}

if (nAvail < AIVar(AIPlayer, AIV_CombatMagic) && set.gold < AIVar(AIPlayer, AIV_SquanderGoldAmount))
	return;

if (strTech != "")
{
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
	return;
}
