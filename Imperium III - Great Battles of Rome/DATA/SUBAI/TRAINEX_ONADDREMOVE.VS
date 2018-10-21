// bool, Obj This, bool bAdd  
int number, maxnumber, queued, build, curnmb;
str class, groupname, dest, research, numparam; 
Building this;

this = This.AsBuilding;
dest = cmdparam;

number = Str2Int(ParseStr(dest, dest));
numparam = ParseStr(dest, dest);
class = ParseStr(dest, dest);
groupname = ParseStr(dest, dest);
queued = EnvReadInt(this, "QueuedBuild/"+class);
build = EnvReadInt(this, "Build/"+class);

if( numparam == "elephant" ) {
	maxnumber = EnvReadInt(.player, "MaxElephants") + 1;
}
else if( numparam == "axemen" ) {
	maxnumber = EnvReadInt(.player, "MaxAxemen");
}
else if( numparam == "huntress" ) {
	maxnumber = EnvReadInt(.player, "MaxHuntresses");
}
else if( numparam == "teutonrider" ) {
	maxnumber = EnvReadInt(.player, "MaxTeutonRiders");
}
else if( numparam == "macemen" ) {
	maxnumber = EnvReadInt(.player, "MaxMacemen");
}
else if (numparam == "myrmidon"){
	maxnumber = EnvReadInt(.player, "MaxMyrmidons");
}
else if (numparam == "mountaineer") {
	maxnumber = Str2Int(EnvReadString(.player, "MaxMountaineers"));
	if (maxnumber == 0)
		maxnumber = 10;
}
else if( numparam == "shero" ) {
	maxnumber = 1;
}
else {
	maxnumber = Str2Int(numparam);
}

if(bAdd)
{
	//curnmb = GetGroupSize("Player"+.player+groupname) + number + build + queued;
	curnmb =Count(.player, class) + number + queued;
	if (numparam=="teutonrider")
		curnmb = number + Count(.player, "TTeutonRider") + Count(.player, "TTeutonArcher") + queued;
	
	if (numparam=="shero")
		curnmb = number + queued
			+ Count(.player, "SBVikingLord")
			+ Count(.player, "SBShieldBearer")
			+ Count(.player, "SCLibyanFootman")
			+ Count(.player, "SCNoble")
			+ Count(.player, "SEGuardian")
			+ Count(.player, "SEHorusWarrior")
			+ Count(.player, "SIEliteGuard")
			+ Count(.player, "SIDefender")
			+ Count(.player, "STSwordsman")
			+ Count(.player, "STMaceman")
			+ Count(.player, "SRTribune") 
			+ Count(.player, "SRPrinciple")
			+ Count(.player, "SGAxeman")
			+ Count(.player, "SGSpearman")
			+ Count(.player, "Rlider2")
			+ Count(.player, "Rlider3")
			+ Count(.player, "SBBronzeSpearman");

	if(curnmb > maxnumber)
	{
		return false;
	} else
	{
		EnvWriteInt(this, "QueuedBuild/"+class, queued + number);
		return true;
	}
}
else
{
	EnvWriteInt(this, "QueuedBuild/"+class, queued - number);
	return true;
}
return true;