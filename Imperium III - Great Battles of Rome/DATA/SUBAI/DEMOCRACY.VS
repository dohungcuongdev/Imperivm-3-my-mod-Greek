// void, Obj This
Building this;
int i;
ObjList units;

this = This.AsBuilding();

.Progress();
EnvWriteString(this.AsBuilding,"researching","no");
if(EnvReadString(.player,"GovernmentForm")=="Oligarchy"){
	units=GetPlayerUnits(.player,"Military");
	for(i=0;i<units.count;i=i+1){
		Unit u;
	
		u=units[i];
		if(u.IsValid()){
			if(u.class!="Sentry" && u.HasItem("Emblem of Oligarchy")){
				u.RemoveItem("Emblem of Oligarchy");
			}
		}
	}
}
EnvWriteString(.player,"GovernmentForm","Democracy");