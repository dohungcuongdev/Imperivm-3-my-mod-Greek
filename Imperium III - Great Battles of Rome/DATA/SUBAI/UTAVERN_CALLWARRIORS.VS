// void, Obj this

int pop;
int militamen;
int level;
Unit u;

.Progress();

militamen = 50;
level = 12;

//spawn militia
while (militamen) {
	u = Place("TSwordsman", .pos, .player);
	u.SetLevel(level);
	u.SetFood(0);
	
	if (EnvReadInt(.AsBuilding.settlement, "items/Bear teeth amulet") == 1)
		u.AddItem("Bear teeth amulet");
	if (EnvReadInt(.AsBuilding.settlement, "items/Herb amulet of luck") == 1)
		u.AddItem("Herb amulet of luck");
	if (EnvReadInt(.AsBuilding.settlement, "items/Belt of might") == 1)
		u.AddItem("Belt of might");
	if (EnvReadInt(.AsBuilding.settlement, "items/God's Gift") == 1)
		u.AddItem("God's Gift");
	if (EnvReadInt(.AsBuilding.settlement, "items/God's Strength") == 1)
		u.AddItem("God's Strength");
	if (EnvReadInt(.AsBuilding.settlement, "items/Thor's Strength") == 1)
		u.AddItem("Thor's Strength");
	if (EnvReadInt(.AsBuilding.settlement, "items/Kingdom Helmet") == 1)
		u.AddItem("Kingdom Helmet");
	if (EnvReadInt(.AsBuilding.settlement, "items/Veteran Guild") == 1)
		u.AddItem("Veteran Guild");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Bastet") == 1)
		u.AddItem("Charm of Bastet");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Sobek") == 1)
		u.AddItem("Charm of Sobek");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Ptah") == 1)
		u.AddItem("Charm of Ptah");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Neith") == 1)
		u.AddItem("Charm of Neith");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Seth") == 1)
		u.AddItem("Charm of Seth");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Thoth") == 1)
		u.AddItem("Charm of Thoth");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Ra") == 1)
		u.AddItem("Charm of Ra");
	if (EnvReadInt(.AsBuilding.settlement, "items/Charm of Isis") == 1)
		u.AddItem("Charm of Isis");
	
	.AsBuilding.settlement.ForceAddUnit(u);
	militamen -= 1;
}