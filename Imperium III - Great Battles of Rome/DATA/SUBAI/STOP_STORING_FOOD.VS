// void, Obj This
Building this;

this = This.AsBuilding();

EnvWriteInt(.settlement,"IsStoring",false);
.settlement.SetFood(.settlement.food+EnvReadInt(.settlement,"FoodStorage"));
EnvWriteInt(.settlement,"FoodStorage",0);