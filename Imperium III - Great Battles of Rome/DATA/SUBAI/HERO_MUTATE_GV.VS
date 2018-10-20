//bool, ObjList objs, str OUT reasonText
int i;

if (objs.count == 0) 
	return false;

if (EnvReadString(objs[0].player, "Special Hero Transform")!="researched")
  {	 
	reasonText = rollover(objs[0], true) + "\n<color 255 0 0>" + Translate(cmdparam);
	return false;
  }

for(i = 0; i < objs.count(); i += 1)
{
	if(!objs[i].AsHero.InHolder()){
		reasonText = rollover(objs[0], true) + "\n<color 255 0 0>" + Translate("Conversion can be done only inside the outpost or townhall");
		return false;
	}
}
return true;
