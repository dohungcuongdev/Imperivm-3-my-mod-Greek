//void, Obj me

Unit this;

this = me.AsUnit();

if(.IsValid())
	if(!.HasSpecial(12))
		.SetSpecial(12,true);
		.SetSpecial(31,false);