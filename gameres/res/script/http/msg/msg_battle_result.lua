

msg_battle_result = msg_base:new();
local p = msg_battle_result;
local super = msg_base;

--创新实例
function p:new()
	o = {}
	setmetatable( o, self );
    self.__index = self;
    o:ctor();
	return o;
end

--构造函数
function p:ctor()
	super.ctor(self);
	self.idMsg = MSG_BATTLE_RESULT;

end

function p:Init()
end

function p:Process()
	if self.result == true then 
		--w_battle_mgr.GetReuslt();
		--w_battle_mgr.QuitBattle();
		--dlg_userinfo.ShowUI();
		--stageMap_main.OpenWorldMap();
		local lResult = w_battle_mgr.GetReuslt();
		if lResult == 1 then
			WriteConWarning( "**MSG_BATTLE_RESULT  Success" );
		else
			WriteConWarning( "**MSG_BATTLE_RESULT  False" );
		end;
	
	else
		WriteConWarning( "**MSG_BATTLE_RESULT  error" );
	end
end
