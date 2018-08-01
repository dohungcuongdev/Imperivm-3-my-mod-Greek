//void, Settlement set, int num, ObjList ol

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
int nRace;
int nUnitsPerCommand;
str tech;
str class;

// -> La Grecia ha per razza la vecchia Roma Imperiale!!!!
int Greece;
Greece = ImperialRome;

nRace = set.GetCentralBuilding.race;
cmd = ArenaTrainCmd(nRace);
tech = ArenaUTech(nRace);
class = ArenaUType(nRace);

if( (nRace == RepublicanRome) && (EnvReadString(set, "ChooseImperialRome") == "researched") )
{
	nUnitsPerCommand = 10;
}	//Fine if.
else if(nRace == Germany)
{
	nUnitsPerCommand = 5;
}	//Fine else if.
else
{
	nUnitsPerCommand = 1;
}	//Fine else.

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
	ObjList arenae;
	arenae = set.TSGetAllArenae();
	for (i = 0; i < arenae.count; i+=1)
	{
		num -= arenae[i].CmdCount(cmd) * nUnitsPerCommand;
	}
}

//issue commands
if (tech!="")
if (IsResearched(set, tech))
	tech = "";

if (tech == "")
{
	num = (num + nUnitsPerCommand - 1) / nUnitsPerCommand;
	for (i = 0; i < num; i+=1)
	{
		int gold, food;
		
		b = set.BestArena();

		if (b.IsValid())
		{
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
