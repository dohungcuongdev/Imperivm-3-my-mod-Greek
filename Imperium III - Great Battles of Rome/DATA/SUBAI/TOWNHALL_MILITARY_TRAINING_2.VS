//void, Obj This

Building bld;
Settlement this;

bld = This.AsBuilding();
if (bld.IsValid) {
	this = bld.settlement;
	if (.IsValid) {
		ObjList l;
		int i;
		Unit u;

		l = .ObjectsAround("Military");
		l.AddList(.ObjectsAround("BaseMage"));
		for (i = l.count; i > 0;) {
			i -= 1;
			u = l[i].AsUnit();
			if (bld.IsEnemy(u))
				continue;
			
			//if you want no limit lv, comment out this condition - begin
			//if (u.inherentlevel >= 30)
			//	continue;
			//if you want no limit lv, comment out this condition - end
			
			u.SetLevel(u.inherentlevel + 1);
			CreateFeedback("Experience", u);
		}	
		bld.PlaySound("data/Sound Entities/TownhallMilitaryTraining.xml");
	}
}