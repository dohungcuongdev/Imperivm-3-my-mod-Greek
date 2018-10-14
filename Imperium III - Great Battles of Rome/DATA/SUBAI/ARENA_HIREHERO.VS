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
// if (.race==Egypt && EnvReadString(.settlement, "Mumification")=="researched") // comment out to apply Mumificatiion for all race
if (EnvReadString(.settlement, "Mumification")=="researched")
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
	newunit = Place(GetRandomHeroClass(cmdparam, .player), Point(0,0), this.player);
	newunit.SetLevel(level);
} else {
	newunit = Place(GetRandomHeroClass(cmdparam, .player), ptExit, this.player);
	newunit.SetCommand("advanceenter", .settlement.GetCentralBuilding);
}
newunit.SetLevel(level);

if (!newunit.IsHeirOf("BaseMage"))
  {	
	if (EnvReadInt(.settlement, "items/Bear teeth amulet") == 1)
		newunit.AddItem("Bear teeth amulet");
	if (EnvReadInt(.settlement, "items/Herb amulet of luck") == 1)
		newunit.AddItem("Herb amulet of luck");
	if (EnvReadInt(.settlement, "items/Belt of might") == 1)
		newunit.AddItem("Belt of might");
	if (EnvReadInt(.settlement, "items/God's Gift") == 1)
		newunit.AddItem("God's Gift");
	if (EnvReadInt(.settlement, "items/God's Strength") == 1)
		newunit.AddItem("God's Strength");
	if (EnvReadInt(.settlement, "items/Thor's Strength") == 1)
		newunit.AddItem("Thor's Strength");
	if (EnvReadInt(.settlement, "items/Kingdom Helmet") == 1)
		newunit.AddItem("Kingdom Helmet");
	if (EnvReadInt(.settlement, "items/Veteran Guild") == 1)
		newunit.AddItem("Veteran Guild");
	if (EnvReadInt(.settlement, "items/Charm of Bastet") == 1)
		newunit.AddItem("Charm of Bastet");
	if (EnvReadInt(.settlement, "items/Charm of Sobek") == 1)
		newunit.AddItem("Charm of Sobek");
	if (EnvReadInt(.settlement, "items/Charm of Ptah") == 1)
		newunit.AddItem("Charm of Ptah");
	if (EnvReadInt(.settlement, "items/Charm of Neith") == 1)
		newunit.AddItem("Charm of Neith");	
	if (EnvReadInt(.settlement, "items/Charm of Seth") == 1)
		newunit.AddItem("Charm of Seth");
	if (EnvReadInt(.settlement, "items/Charm of Thoth") == 1)
		newunit.AddItem("Charm of Thoth");
	if (EnvReadInt(.settlement, "items/Charm of Ra") == 1)
		newunit.AddItem("Charm of Ra");
	if (EnvReadInt(.settlement, "items/Charm of Isis") == 1)
		newunit.AddItem("Charm of Isis");
  }
