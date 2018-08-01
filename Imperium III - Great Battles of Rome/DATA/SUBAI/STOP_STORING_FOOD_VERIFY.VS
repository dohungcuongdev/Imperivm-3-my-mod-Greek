//bool, ObjList objs, str OUT reasonText

Building this;
this = objs[0].AsBuilding();

reasonText = "";

if(.IsValid)
{
	if(EnvReadString(this.AsBuilding,"researching")=="yes"){
		return false;
	}
	if(EnvReadInt(.settlement,"IsStoring")==false) {
		return false;
	}
	return true;
} 

return false;