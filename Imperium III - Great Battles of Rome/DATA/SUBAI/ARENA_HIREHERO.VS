// void, Obj This

Unit newunit;
Barrack this;
point ptExit;
int level,i;
ObjList ol;

this = This.AsBuilding();

// needed for the tutorial message to check this ever started
EnvWriteInt(.player, "HeroBuilt", 1);

while(.settlement.IsFull)
	Sleep(500);
.Progress();
while(.settlement.IsFull)
	Sleep(500);

level = EnvReadInt(.settlement, "levels/Hero");

// Mumificatiion
if (.race==Egypt && EnvReadString(.settlement, "Mumification")=="researched")
  {
	level = EnvReadInt(.player, "BestHeroLevel");
	
	ol = GetPlayerUnits(.player, "Hero");
	for (i=0; i<ol.count;i+=1)
		{
		  if (ol[i].IsValid())
			if (ol[i].AsHero().inherentlevel > level)
			  level = ol[i].AsHero().inherentlevel;
		}
	level = (2*level)/3;
	if (level<1)  level = 1;
  }
//

ptExit = .GetExitPoint(.settlement.GetCentralBuilding.pos, false);
if (ptExit.x==-1 && ptExit.y==-1) {
	if(EnvReadString(.settlement, "ChooseRepublicanRome") == "researched")
	{
		newunit = Place(GetRandomHeroClass("RepublicanRomanHero", .player), Point(0,0), this.player);
		newunit.SetLevel(level);
	}	//End if.
	if(EnvReadString(.settlement, "ChooseImperialRome") == "researched")
	{
		newunit = Place(GetRandomHeroClass("ImperialRomanHero", .player), Point(0,0), this.player);
		newunit.SetLevel(level);
	}	//End else/if.
	else
	{
		newunit = Place(GetRandomHeroClass(cmdparam, .player), Point(0,0), this.player);
		newunit.SetLevel(level);
	}	//End else.
} else {
	if(EnvReadString(.settlement, "ChooseRepublicanRome") == "researched")
	{
		newunit = Place(GetRandomHeroClass("RepublicanRomanHero", .player), ptExit, this.player);
		newunit.SetLevel(level);
		newunit.SetCommand("advanceenter", .settlement.GetCentralBuilding);
	}	//End if.
	if(EnvReadString(.settlement, "ChooseImperialRome") == "researched")
	{
		newunit = Place(GetRandomHeroClass("ImperialRomanHero", .player), ptExit, this.player);
		newunit.SetLevel(level);
		newunit.SetCommand("advanceenter", .settlement.GetCentralBuilding);
	}	//End else/if.
	if( (EnvReadString(.settlement, "ChooseRepublicanRome") != "researched") && (EnvReadString(.settlement, "ChooseImperialRome") != "researched") )
	{
		newunit = Place(GetRandomHeroClass(cmdparam, .player), ptExit, this.player);
		newunit.SetCommand("advanceenter", .settlement.GetCentralBuilding);
		newunit.SetLevel(level);
	}	//End else.
}
newunit.SetLevel(level);
