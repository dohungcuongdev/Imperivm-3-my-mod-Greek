// void, Obj This

Building this;

this = This.AsBuilding();

if( (EnvReadString(.settlement, "ChooseRepublicanRome") == "researched") || (EnvReadString(.settlement, "ChooseImperialRome") == "researched") )
{
	.CmdEnable("RAddPop");
	Sleep(50);
	.CmdEnable("Free Wine");
	Sleep(50);
	.CmdEnable("Import horses");
	Sleep(50);
	.CmdEnable("Scout Area");
	Sleep(50);
	.CmdEnable("investR");
	Sleep(50);
	.CmdEnable("RTribute");
	Sleep(50);	
	if(EnvReadString(.settlement, "ChooseRepublicanRome") == "researched")
	{
		.CmdEnable("buyfoodforgold");
		Sleep(50);
	}	//End if.
	else
	{
		.CmdDisable("buyfoodforgold");
		Sleep(50);
	}
}	//End if.
else
{
	.CmdDisable("RAddPop");
	Sleep(50);
	.CmdDisable("Free Wine");
	Sleep(50);
	.CmdDisable("Import horses");
	Sleep(50);
	.CmdDisable("Scout Area");
	Sleep(50);
	.CmdDisable("investR");
	Sleep(50);
	.CmdDisable("RTribute");
	Sleep(50);
	.CmdDisable("buyfoodforgold");
	Sleep(50);
}	//End else.

Sleep(1000);

// Edit by Riccardo "Highlander" Tedesco (Alias Ricky1996, Ricky96Highlander)