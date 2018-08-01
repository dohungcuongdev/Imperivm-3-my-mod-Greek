//void, Settlement set, Hero *h

ObjList oll;
int i;
str cmd;
int nRace;
Hero hh;
bool bNoNeed;

nRace = set.GetCentralBuilding.race;
cmd = "hirehero" + GetRaceStrPref(nRace);
if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
{
	cmd = "hireheroRImperial";
}	//End if.
bNoNeed = false;

//steal from the AI
oll = GetGAIKA(set.GetCentralBuilding).GetAIControlledUnits("Hero", set.player, 1, false);
for (i = 0; i < oll.count; i += 1)
{
	hh = oll[i].AsHero;
	if (hh.IsAlive)
	{
		hh.SetNoAIFlag(true);
		hh.DetachArmy();
		h = hh;
		break;
	} 
}

if (!h.IsAlive())
{
	//count how many are queued
	ObjList barracks;
	barracks = set.TSGetAllBarracks();
	for (i = 0; i < barracks.count; i+=1)
	{
		if (barracks[i].CmdCount(cmd))
		{
			bNoNeed = true;
			break;
		}
	}
	if (!bNoNeed)
	{
		//A friend in need is a pest indeed
		int gold, food;
		
		if (GetCmdCost(cmd, gold, food))
		{
			if (set.CanResearch(cmd) && set.gold >= gold && set.food >= food)
			{
				set.SpentGoldOnArmy(gold + (food / 2));
				set.Research(cmd);
			}
		}
	}
}
