// bool, Obj This, Obj target

Unit this;
this = This.AsUnit();

if (!.IsAlive()) return false;
if (!.HasSpecial(curse)) return false;

if (!target.IsAlive()) return false;
if (!.IsEnemy(target)) return false;
if (target.AsUnit()){
	if (target.AsUnit.InHolder()) return false;
	if (target.AsUnit.IsCursed()) return false;
}
if (!.CanSee(target)) return false;
if (target.AsShip.IsValid()) return false;

return true;
