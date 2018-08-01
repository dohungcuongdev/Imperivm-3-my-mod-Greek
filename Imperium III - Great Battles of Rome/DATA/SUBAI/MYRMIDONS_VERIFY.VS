//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
int max_myrmidons;
str dest, name, reason;

this = objs[0];
dest = cmdparam;
max_myrmidons = EnvReadInt(.player, "MaxMyrmidons");

if(EnvReadString(this.AsBuilding.settlement,"Olympic Games")!="researched"){
	reasonText = Translate(rollover(this,false));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translatef("Requires %s1", "Olympic Games");
	return false;
}
if(EnvReadString(this.AsBuilding,"researching")=="yes"){
	reasonText = rollover(this,true) + Translatef(" (currently %s1)",  "" + (max_myrmidons));
	return false;
}
if(max_myrmidons>=GetConst("MaxMyrmidonsValue")){
	reasonText = rollover(this,"HMyrmidon_Javelin",false) + "<color 255 0 0>\n" + Translatef("You cannot have more than %s1", GetConst("MaxMyrmidonsValue"));
	return false;
}
if ((cmdcost_gold > this.AsBuilding.settlement.gold))
{
	reasonText = rollover(this,false)+ Translatef(" (currently %s1)",  "" + (max_myrmidons));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translate("Not enough gold");
	
	return true;
}
reasonText = rollover(this,false) + Translatef(" (currently %s1)",  "" + (max_myrmidons));
return true;
