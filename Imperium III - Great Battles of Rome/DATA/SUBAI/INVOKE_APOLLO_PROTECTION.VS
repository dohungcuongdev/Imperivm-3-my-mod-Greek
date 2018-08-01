// void, Obj This
Building this;

this=This.AsBuilding();

EnvWriteString(this.AsBuilding.player,"Protection of Apollo","researched");
EnvWriteInt(this.AsBuilding.player,"ApolloMin",1);
EnvWriteInt(this.AsBuilding.player,"ApolloSec",0);
PlaySound(.player, "data/Sounds Entities/StonehengeSpell.xml");