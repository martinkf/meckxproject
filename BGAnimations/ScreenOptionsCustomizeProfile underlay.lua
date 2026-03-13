
--JNC Todo esto se cambio, pero hay un backup :))
local profile= GAMESTATE:GetEditLocalProfile()
local index = 0

local arrAvatars = GAMESTATE:GetAvatarFolder();
local arrSkinsUsb = GAMESTATE:GetSkinUsbFolder();

local number_entry= new_numpad_entry{
	Name= "number_entry",
	InitCommand= cmd(diffusealpha, 0; xy, _screen.cx*1.5, _screen.cy),
	value_color= PlayerColor(PLAYER_1),
	cursor_draw= "first",
	cursor_color= PlayerDarkColor(PLAYER_1),
}

local function calc_list_pos(value, list)
	for i, entry in ipairs(list) do
		if entry.setting == value then
			return i
		end
	end
	return 1
end

-- color array;
local color_list = {
	{setting="0", display_name="White"},
	{setting="1", display_name="Bronce"},
	{setting="2", display_name="Green"},
	{setting="3", display_name="LightBlue"},
	{setting="4", display_name="Gold"},
	{setting="5", display_name="Violet"},
	{setting="6", display_name="Purple"},
	{setting="7", display_name="Red"},
	{setting="8", display_name="Blue"},
	{setting="9", display_name="Orange"},
	{setting="10", display_name="GlowPink"},
	{setting="11", display_name="GlowCyan"},
	{setting="12", display_name="GlowRed"},
	{setting="13", display_name="GlowGreen"},
	{setting="14", display_name="GlowGold"},
	{setting="15", display_name="Rainbow"},
}
	



local function item_value_to_text(item, value)
	if item.item_type == "bool" then
		if value then
			value= THEME:GetString("ScreenOptionsCustomizeProfile", item.true_text)
		else
			value= THEME:GetString("ScreenOptionsCustomizeProfile", item.false_text)
		end
	elseif item.item_type == "list" then
		local pos= calc_list_pos(value, item.list)
		return item.list[pos].display_name
	end
	return value
end

local char_list= {}

for i=1,#arrAvatars do
	table.insert(char_list, {setting=arrAvatars[i], display_name="Avatar " .. i } );
end;

local skin_list = {}

-- Add Usb Skins
for i=1,#arrSkinsUsb do
	table.insert(skin_list, {setting=arrSkinsUsb[i], display_name="Skin " .. i } );
end;

local menu_items;

menu_items= {
	{name= "avatar_id", get= "GetAvatarFile", set= "SetAvatarFile",
	 item_type= "list", list= char_list},

	{name= "skin_id", get= "GetSkinUsbFile", set= "SetSkinUsbFile",
	 item_type= "list", list= skin_list},
};

table.insert(menu_items, {name= "color_id", get= "GetColorTitle", set= "SetColorTitle", item_type= "list", list= color_list} );
table.insert(menu_items, {name= "gender", get= "GetIsMale", set= "SetIsMale", item_type= "bool",true_text= "male", false_text= "female"} );
table.insert(menu_items, {name= "exit", item_type= "exit"});


local menu_cursor
local menu_pos= 1
local menu_start= 300
local menu_x= 450
local value_x= 635
local fader
local cursor_on_menu= "main"
local menu_item_actors= {}
local menu_values= {}
local list_pos= 0
local active_list= {}
local left_showing= false
local right_showing= false
local listSection = "avatar_id"


local function fade_actor_to(actor, alf)
	actor:stoptweening()
	actor:linear(.2)
	actor:diffusealpha(alf)
end

local function update_menu_cursor()
	local item= menu_item_actors[menu_pos]
	menu_cursor:playcommand("Move", {item:GetX(), item:GetY()})
	menu_cursor:playcommand("Fit", item)
end

local function update_list_cursor()
	local valactor= menu_values[menu_pos]
	index = active_list[list_pos].setting
	MESSAGEMAN:Broadcast("MoveCursor");
	valactor:playcommand("Set", {active_list[list_pos].display_name})
	if list_pos > 1 then
		if not left_showing then
			valactor:playcommand("ShowLeft")
			left_showing= true
		end
	else
		if left_showing then
			valactor:playcommand("HideLeft")
			left_showing= false
		end
	end
	if list_pos < #active_list then
		if not right_showing then
			valactor:playcommand("ShowRight")
			right_showing= true
		end
	else
		if right_showing then
			valactor:playcommand("HideRight")
			right_showing= false
		end
	end
end

local function exit_screen()
	local profile_id= GAMESTATE:GetEditLocalProfileID()
	PROFILEMAN:SaveLocalProfile(profile_id)
	SOUND:PlayOnce(THEME:GetPathS("Common", "Start"))
	SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
end

local function input(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	if event.type == "InputEventType_Release" then return false end
	local button= event.GameButton
	if cursor_on_menu == "main" then
		if button == "Start" then
			local item= menu_items[menu_pos]
			if item.item_type == "bool" then
				local value= not profile[item.get](profile)
				menu_values[menu_pos]:playcommand(
					"Set", {item_value_to_text(item, value)})
				profile[item.set](profile, value)
			elseif item.item_type == "number" then
				fade_actor_to(fader, .8)
				fade_actor_to(number_entry.container, 1)
				number_entry.value= profile[item.get](profile)
				number_entry.value_actor:playcommand("Set", {number_entry.value})
				number_entry.auto_done_value= item.auto_done
				number_entry.max_value= item.max
				number_entry:update_cursor(number_entry.cursor_start)
				number_entry.prompt_actor:playcommand(
					"Set", {THEME:GetString("ScreenOptionsCustomizeProfile", item.name)})
				cursor_on_menu= "numpad"
			elseif item.item_type == "list" then
				cursor_on_menu= "list"
				active_list= menu_items[menu_pos].list
				ListSection = menu_items[menu_pos].name
				list_pos= calc_list_pos(
					profile[menu_items[menu_pos].get](profile), active_list)
				update_list_cursor()
			elseif item.item_type == "exit" then
				exit_screen()
			end
		elseif button == "Back" then
			exit_screen()
		else
			if button == "MenuLeft" or button == "MenuUp" then
				if menu_pos > 1 then menu_pos= menu_pos - 1 end
				update_menu_cursor()
			elseif button == "MenuRight" or button == "MenuDown" then
				if menu_pos < #menu_items then menu_pos= menu_pos + 1 end
				update_menu_cursor()
			end
		end
	elseif cursor_on_menu == "numpad" then
		local done= number_entry:handle_input(button)
		if done or button == "Back" then
			local item= menu_items[menu_pos]
			if button ~= "Back" then
				profile[item.set](profile, number_entry.value)
				menu_values[menu_pos]:playcommand(
					"Set", {item_value_to_text(item, number_entry.value)})
			end
			fade_actor_to(fader, 0)
			fade_actor_to(number_entry.container, 0)
			cursor_on_menu= "main"
		end
	elseif cursor_on_menu == "list" then
		if button == "MenuLeft" or button == "MenuUp" then
			if list_pos > 1 then list_pos= list_pos - 1 end
			update_list_cursor()
			menu_values[menu_pos]:playcommand("PressLeft")
		elseif button == "MenuRight" or button == "MenuDown" then
			if list_pos < #active_list then list_pos= list_pos + 1 end
			update_list_cursor()
			menu_values[menu_pos]:playcommand("PressRight")
		elseif button == "Start" or button == "Back" then
			if button ~= "Back" then
				profile[menu_items[menu_pos].set](
					profile, active_list[list_pos].setting)
			end
			local valactor= menu_values[menu_pos]
			left_showing= false
			right_showing= false
			valactor:playcommand("HideLeft")
			valactor:playcommand("HideRight")
			cursor_on_menu= "main"
		end
	end
end

local args= {

	LoadActor(THEME:GetPathG("","PIU LOGO"))..{
		OnCommand=cmd(Center;addy,-269;zoom,.6);
	};
	
	LoadFont("_open sans 24px")..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y-120;settext,"Player Level: " .. profile:GetUserLevel());
	};
	
	LoadFont("_open sans 24px")..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y+140;visible,true;queuecommand,"SetVisible");
		SetVisibleCommand=function(self)
			if (profile:GetCustomTitle() == "") then
				self:settext("Press F5 to set a custom title (Max 15 Characters)");
			else
				self:settext("Your Custom title is: \"" .. profile:GetCustomTitle()  .. "\"\nPress F5 to set a custom title.");
			end;
		end;
		
		CustomTitleEditMessageCommand=function(self, params)
			local title = params.Title;
			title = string.upper(title);
			if (title == "") then
				self:settext("Press F5 to set a custom title (Max 15 Characters)");
			else
				self:settext("Your Custom title is: \"" .. title  .. "\"\nPress F5 to set a custom title.");
			end;
			profile:SetCustomTitle(title);
		end;
	};

	LoadActor(THEME:GetPathG("","_blank"))..{
		InitCommand=function(self)
			self:animate(false);
			index = profile:GetSkinUsbFile();
			self:x(SCREEN_CENTER_X+110);
			self:y(SCREEN_CENTER_Y+80);
			self:scaletoclipped(320 ,50);
			self:visible(true);
			if string.find(index, "_video%.png") then
				local videoFile = string.gsub(index, ".png", ".mp4")			
				if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
					self:Load("/UsbSkins/" .. videoFile);
					self:play();
				else
					self:Load(THEME:GetPathG("","_blank"));
				end;
			else
				if FILEMAN:DoesFileExist("/UsbSkins/" .. index) then
					self:Load("/UsbSkins/" .. index);
				else
					self:Load(THEME:GetPathG("","_blank"));
				end;
			end
			
		end;
		
		MoveCursorMessageCommand=function(self)
			if (ListSection == "skin_id") then
				--here we do the most disgusting thing ever to add videos to this 
				--because we need to do this in the src to be more flexible 
				--we don't want to waste time on that.
				--if we encounter an avatar with the tag *_video.png 
				--we will search of the *_video.mp4
				-- were * is any name.				

				if string.find(index, "_video%.png") then
					local videoFile = string.gsub(index, ".png", ".mp4")			
					if FILEMAN:DoesFileExist("/UsbSkins/" .. videoFile) then
						self:Load("/UsbSkins/" .. videoFile);
						self:play();
					else
						self:Load(THEME:GetPathG("","_blank"));
					end;
				else
					if FILEMAN:DoesFileExist("/UsbSkins/" .. index) then
						self:Load("/UsbSkins/" .. index);
					else
						self:Load(THEME:GetPathG("","_blank"));
					end;
				end
			end;
		end;
	};


	
	
	LoadActor(THEME:GetPathG("","_blank"))..{
		InitCommand=function(self)
			self:animate(false);
			index = profile:GetAvatarFile();
			self:x(SCREEN_CENTER_X+190);
			self:y(SCREEN_CENTER_Y-20);
			self:scaletoclipped(116 ,116);
	    end;
		
		MoveCursorMessageCommand=function(self)
			if (ListSection == "avatar_id") then
				if FILEMAN:DoesFileExist("/Avatars/" .. index) then
					self:Load("/Avatars/" .. index);
				else
					index = "000.PNG";
					self:Load("/Avatars/" .. index);
				end;
			end;
		end;
		
	};
	
	Def.Actor{
		InitCommand=function(self)
			ListSection = "avatar_id";
		end;
		OnCommand= function(self)
			update_menu_cursor()
			SCREENMAN:GetTopScreen():AddInputCallback(input)
		end
	},

	Def.Quad{
		Name= "menu_cursor", InitCommand= function(self)
			menu_cursor= self
			self:horizalign(left)
			self:setsize(0, 24)
			self:diffuse(PlayerColor(PLAYER_1))
			self:xy(menu_x - 10, menu_start)
		end,
		MoveCommand= function(self, params)
			self:stoptweening()
			self:linear(.1)
			self:xy(params[1] - 10, params[2])
		end,
		FitCommand= function(self, param)
			self:SetWidth(param:GetWidth() + 20)
		end
	},
}

for i, item in ipairs(menu_items) do
	local item_y= menu_start + ((i-1) * 24)

	args[#args+1]= Def.BitmapText{
		Name= "menu_" .. item.name, Font= "Common Normal",
		Text= THEME:GetString("ScreenOptionsCustomizeProfile", item.name),
		InitCommand= function(self)
			menu_item_actors[i]= self
			self:xy(menu_x, item_y)
			self:diffuse(Color.White)
			self:horizalign(left)
		end
	}
	if item.get then
		local value_text= item_value_to_text(item, profile[item.get](profile))
		local value_args= {
			Name= "value_" .. item.name, 
			InitCommand= function(self)
				menu_values[i]= self
				self:xy(value_x, menu_start + ((i-1) * 24))
			end,
			Def.BitmapText{
				Name= "val", Font= "Common Normal", Text= value_text,
				InitCommand= function(self)
					self:diffuse(Color.White)
					self:horizalign(left)
				end,
				SetCommand= function(self, param)
					self:settext(param[1])
				end,
			}
		}
		if item.item_type == "list" then
			value_args[#value_args+1]= Def.ActorMultiVertex{
				InitCommand= function(self)
					self:SetVertices{
						{{-5, 0, 0}, Color.White}, {{0, -10, 0}, Color.White},
						{{0, 10, 0}, Color.White}}
					self:SetDrawState{Mode= "DrawMode_Triangles"}
					self:x(-8)
					self:visible(false)
					self:playcommand("Set", {value_text})
					MESSAGEMAN:Broadcast("MoveCursor");
				end,
				ShowLeftCommand= cmd(visible, true),
				HideLeftCommand= cmd(visible, false),
				PressLeftCommand= cmd(stoptweening; linear, .2; zoom, 2; linear, .2;
															zoom, 1),
			}
			value_args[#value_args+1]= Def.ActorMultiVertex{
				InitCommand= function(self)
					self:SetVertices{
						{{5, 0, 0}, Color.White}, {{0, -10, 0}, Color.White},
						{{0, 10, 0}, Color.White}}
					self:SetDrawState{Mode= "DrawMode_Triangles"}
					self:visible(false)
				end,
				SetCommand= function(self)
					MESSAGEMAN:Broadcast("MoveCursor");
					local valw= self:GetParent():GetChild("val"):GetWidth()
					self:x(valw+9)
				end,
				ShowRightCommand= cmd(visible, true),
				HideRightCommand= cmd(visible, false),
				PressRightCommand= function(self)
					local valw= self:GetParent():GetChild("val"):GetWidth()
					self:stoptweening()
					self:x(valw+9)
					self:linear(.2)
					self:zoom(2)
					self:linear(.2)
					self:zoom(1);
				end;
				
			}
		end
		args[#args+1]= Def.ActorFrame(value_args)
	end
end

args[#args+1]= Def.Quad{
	Name= "fader", InitCommand= function(self)
		fader= self
		self:setsize(270, #menu_items * 24)
		self:horizalign(left)
		self:vertalign(top)
		self:xy(menu_x-10, menu_start-12)
		self:diffuse(Color.Black)
		self:diffusealpha(0)
	end
}

args[#args+1]= number_entry:create_actors()

return Def.ActorFrame(args)
