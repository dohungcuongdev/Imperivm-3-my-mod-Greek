//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
int max_myrmidons;
str dest, name, reason;

this = objs[0];
dest = cmdparam;

if(EnvReadString(this.AsBuilding.settlement,"Olympic Games")!="researched"){
	reasonText = Translate(rollover(this,false));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translatef("Requires %s1", "Olympic Games");
	return false;
}
if(EnvReadString(this.AsBuilding,"researching")=="yes"){
	reasonText = rollover(this,true);
	return false;
}
if(EnvReadString(this.AsBuilding.player,"GovernmentForm")=="Oligarchy"){
	reasonText = Translate(rollover(this,false));
	reasonText = reasonText + "\n<color 255 255 0>";
	reasonText = reasonText + Translate("(The Oligarchy is already in force)");
	return false;
}
if ((cmdcost_gold > this.AsBuilding.settlement.gold)){
	reasonText = rollover(this,false)+ Translatef(" (currently %s1)",  "" + (max_myrmidons));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translate("Not enough gold");
	return true;
}
return true;
