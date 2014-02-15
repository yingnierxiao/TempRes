msg_stage_list = msg_base:new();
local p = msg_stage_list;
local super = msg_base;

function p:new()
	o = {}
	setmetatable(o, self);
	self.__index = self;
	o:ctor();
	return o;
end

function p:ctor()
	super.ctor(self);
	self.idMsg = MSG_STAGE_LIST;
end

function p:Init()
end

--������Ϣ
function p:Process()
	msg_cache.msg_stage_list = self;
	
	WriteConWarning( "** msg_stage_list:Process() called" );
	if stageMap_main.openMapId == 1 then
		stageMap_1.addAllStage(self);
	elseif stageMap_main.openMapId == 2 then
		stageMap_2.addAllStage(self);
	end
end
