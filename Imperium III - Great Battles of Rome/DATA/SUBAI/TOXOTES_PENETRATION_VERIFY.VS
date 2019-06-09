//bool, ObjList objs, str OUT reasonText

int i;
Unit u;

for(i=0;i<objs.count();i+=1){
	u = objs[i].AsUnit;
	if (u.IsValid)
		if (!u.HasSpecial(12) && u.HasSpecial(31))
			return true;	
}
return false;