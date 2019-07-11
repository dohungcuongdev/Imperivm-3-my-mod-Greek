// void, Obj This

int time;

if (!This.IsValid || This.IsDead()) 
{
	Sleep(10000);
	return;
}

if (This.AsUnit)
	time = This.AsUnit.GetStaminaDecTime();  
else	
	time = This.GetStaminaDecTime();  

if (time<=0) 
 {
	This.Damage(This.health);     
	return;
 }

while (This.IsValid() && This.stamina>=0)
  {
	Sleep(time);
    if (!This.IsValid || This.IsDead()) 
		return;
	if ((This.stamina - 1) <= -1)
	  break;
	This.SetStamina(This.stamina - 1);
  }
if (!This.IsValid || This.IsDead()) 
	return;

// call end magic damage function for ghost and mist 
if (This.IsHeirOf("GGhost") || This.IsHeirOf("Mist"))
  This.MagicActionEnd();
  
This.Damage(This.health);     
return;