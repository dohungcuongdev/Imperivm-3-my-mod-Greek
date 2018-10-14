// void, Obj This
Building this;
int i;
ObjList units;

this = This.AsBuilding();

if(EnvReadString(.player,"GovernmentForm")=="Democracy"){
	units=GetPlayerUnits(.player,"Military");
	for(i=0;i<units.count;i=i+1){
		Unit u;
	
		u=units[i];
		if(u.IsValid()){
			if(u.class!="Sentry" && !u.HasItem("Emblem of Democracy") && u.free_item_slots>0){
				u.AddItem("Emblem of Democracy");
			}
		}
	}
}
else{
	if(EnvReadString(.player,"GovernmentForm")=="Oligarchy"){
		units=GetPlayerUnits(.player,"Military");
		for(i=0;i<units.count;i=i+1){
			Unit u;
	
			u=units[i];
			if(u.IsValid()){
				if(u.class!="Sentry" && u.inherentlevel>=10 && !u.HasItem("Emblem of Oligarchy") && u.free_item_slots>0){
					u.AddItem("Emblem of Oligarchy");
				}
			}
		}
	}	
}
Sleep(1000);