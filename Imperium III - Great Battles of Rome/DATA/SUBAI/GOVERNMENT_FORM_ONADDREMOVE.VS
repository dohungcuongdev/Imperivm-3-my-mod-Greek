// bool, Obj This, bool bAdd

Building this;
this=This.AsBuilding();

if(bAdd){
	EnvWriteString(this,"researching","yes");
	return true;
}
else{
	EnvWriteString(this,"researching","no");
	return true;
}
return true;