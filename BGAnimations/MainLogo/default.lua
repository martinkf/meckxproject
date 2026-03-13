local t = Def.ActorFrame {};

t[#t+1] = LoadActor("logo_underlay")..{
	InitCommand=cmd();
}

t[#t+1] = LoadActor("logo_overlay")..{
	InitCommand=cmd();
}

return t;