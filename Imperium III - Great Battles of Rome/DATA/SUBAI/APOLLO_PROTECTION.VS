// void, Obj This
Building this;
int i;
str minText,secText,timer;
ObjList gates;

this=This.AsBuilding();
gates=this.AsBuilding.settlement.ObjectsAround("Gate");

if(EnvReadInt(this.AsBuilding.player,"ApolloMin")>0 || EnvReadInt(this.AsBuilding.player,"ApolloSec")>0){
	if(EnvReadInt(this.AsBuilding.player,"ApolloSec")>0){
		EnvWriteInt(this.AsBuilding.player,"ApolloSec",EnvReadInt(this.AsBuilding.player,"ApolloSec")-1);
	}
	else{
		if(EnvReadInt(this.AsBuilding.player,"ApolloSec")==0 && EnvReadInt(this.AsBuilding.player,"ApolloMin")>0){
			EnvWriteInt(this.AsBuilding.player,"ApolloMin",EnvReadInt(this.AsBuilding.player,"ApolloMin")-1);
			EnvWriteInt(this.AsBuilding.player,"ApolloSec",59);
		}
	}
	if(EnvReadInt(this.AsBuilding.player,"ApolloSec")>=10){
		secText=EnvReadInt(this.AsBuilding.player,"ApolloSec");
	}
	else{
		secText="0"+EnvReadInt(this.AsBuilding.player,"ApolloSec");
	}
	if(EnvReadInt(this.AsBuilding.player,"ApolloMin")>=10){
		minText=EnvReadInt(this.AsBuilding.player,"ApolloMin");
	}
	else{
		minText="0"+EnvReadInt(this.AsBuilding.player,"ApolloMin");
	}
	timer=minText+":"+secText;
	for(i=0;i<gates.count;i=i+1){
		gates[i].SetHealth(gates[i].maxhealth);
	}
	ShowAnnouncement(.player+"ApolloProtection",Translatef(("Player %s1 will be protected for %s2"),.player,timer));
}
else{
	HideAnnouncement(.player+"ApolloProtection");
}
Sleep(1000);