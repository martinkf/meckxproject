local t = Def.ActorFrame {};

t[#t+1] = LoadActor("_base")..{
	InitCommand=cmd();
}

t[#t+1] = LoadActor("_logo")..{
	InitCommand=cmd();
}


return t;