// void, Obj This 
Building this;

this = This.AsBuilding();

.Progress();
EnvWriteString(this,"researching","no");
EnvWriteInt(.player, "MaxMyrmidons", EnvReadInt(.player, "MaxMyrmidons") + 10);
if(EnvReadString(.player, "Forge Elite Equipment")!="researched"){
	EnvWriteString(.player, "Forge Elite Equipment", "researched");
	PlaySound(.player, "data/Sounds Entities/UpgradeComplete.xml");
}
