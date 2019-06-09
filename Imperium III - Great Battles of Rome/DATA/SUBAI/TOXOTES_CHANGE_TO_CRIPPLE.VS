//void, Obj me

Unit this;

this = me.AsUnit();

if(.IsValid())
	if(!.HasSpecial(31))
		.SetSpecial(12,false);
		.SetSpecial(31,true);