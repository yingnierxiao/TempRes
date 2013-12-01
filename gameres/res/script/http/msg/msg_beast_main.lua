msg_beast_main = msg_base:new();
local p = msg_beast_main;
local super = msg_base;

--创建新实例
function p:new()
	o = {}
	setmetatable( o,self);
	self.__index = self;
	o:ctor();return o;
end

--构造函数
function p:ctor()
	super.ctor(self);
	self.idMsg = MSG_PET_GETPETDATA;
	
end

--初始化
function p:Init()
end

--处理消息
function p:Process()
	WriteConWarning( "** msg_beast_main:Process() called" );
	if self.result then
		beast_mgr.RefreshUI( self );
	else

	end
end