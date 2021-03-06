// void, Obj This

Unit newunit;
Barrack this;
point ptExit, ptEnter;
int perc, level;
Query qEnemies;

str carCmdParam, cdrCmdParam; 

carCmdParam = ParseStr(cmdparam, cdrCmdParam); 

this = This.AsBarrack();
qEnemies = Intersect(ObjsInSight(.settlement.GetCentralBuilding(),"Object"),EnemyObjs(.player(),"Object"));

perc = 100 - EnvReadInt(.settlement, "BarrackTrainTimeDecrease");
.Progress((.cmddelay * perc) / 100);

// Create unit
ptExit = .GetExitPoint(.settlement.GetCentralBuilding.pos, false);
if (ptExit.x==-1 && ptExit.y==-1) {
	newunit = Place(carCmdParam, Point(0,0), this.player);
	.settlement.AddUnit(newunit);
} else {
	newunit = Place(carCmdParam, ptExit, this.player);
	if (qEnemies.IsEmpty())
		newunit.SetCommand("enter", .settlement.GetCentralBuilding);
	else
		newunit.SetCommand("advanceenter", .settlement.GetCentralBuilding);
}

// Set level
level = 1;
//if( GetClassRace(carCmdParam) == Carthage ) { //comment out it should work for all race
	if (!newunit.IsHeirOf("BaseMage"))
	  {	
		if( EnvReadString(.settlement, "Shared Strength") == "researched" ) {
			int nThisClass;
			nThisClass = Count(.player, carCmdParam);
			if( nThisClass > 12 )
				level = 6;
		}
		if( EnvReadString(.settlement, "Shared Triumph") == "researched" ) {
			int nThisClass;
			nThisClass = Count(.player, carCmdParam);
			if( nThisClass > 24 )
				level = 12;
		}
	  }
//}//comment out it should work for all race
{
    int l2;
    l2 = EnvReadInt(.settlement, "levels/" + carCmdParam);
    if (l2 > level) level = l2;
}

// standartization
{
	if (!newunit.IsHeirOf("BaseMage"))
	  {	
		int l2;
		l2 = EnvReadInt(.player, "standard_spawn_level");
		if (l2 > level) level = l2;
      }
}

//Olympic Games
{
	if (!newunit.IsHeirOf("BaseMage") && EnvReadString(.settlement,"Olympic Games")=="researched"){
		if(level<5){	
			level=5;
		}
	}
}

newunit.SetLevel(level);
if (EnvReadInt(.settlement, "items/Herb amulet of luck") == 1)
	newunit.AddItem("Herb amulet of luck");
if (!newunit.IsHeirOf("BaseMage"))
  {	
	if (EnvReadInt(.settlement, "items/Bear teeth amulet") == 1)
		newunit.AddItem("Bear teeth amulet");
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