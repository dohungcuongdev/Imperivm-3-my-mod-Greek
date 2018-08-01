//bool, ObjList objs, str OUT reasonText
int i,counter;
Obj this;
ObjList enemyUnits,gates;

this = objs[0];
enemyUnits=this.AsBuilding.settlement.ObjectsAround("Military");
gates=this.AsBuilding.settlement.ObjectsAround("Gate");
counter=enemyUnits.count;

while(counter>0){
	Unit u;

	counter=counter-1;
	u=enemyUnits[counter].AsUnit();
	if(!u.IsEnemy(this.AsBuilding)){
		enemyUnits.Remove(u);	
	}
}
if(EnvReadString(this.AsBuilding.settlement,"Offer to Gods")!="researched"){
	reasonText = Translate(rollover(this,false));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translatef("Requires %s1", "Offer to Gods");
	return false;
}
if(EnvReadString(this.AsBuilding.player,"Protection of Apollo")=="researched"){
	reasonText = rollover(this, "Already available");
	return false;
}
if(EnvReadString(this.AsBuilding,"researching")=="yes"){
	reasonText = rollover(this,true);
	return false;
}
if ((cmdcost_gold > this.AsBuilding.settlement.gold)){
	reasonText = rollover(this,false);
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translate("Not enough gold");
	return true;
}
for(i=0;i<gates.count;i=i+1){
	if(gates[i].AsBuilding.health<(gates[i].AsBuilding.maxhealth*90/100)){
		reasonText = Translate(rollover(this,false));
		reasonText = reasonText + "\n<color 255 0 0>";
		reasonText = reasonText + Translate("One or more gates are broken");
		return false;
	}
}
if(enemyUnits.count>0){
	reasonText = rollover(this,false);
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translate("There are enemies nearby to your base");
	return false;
}	
return true;
