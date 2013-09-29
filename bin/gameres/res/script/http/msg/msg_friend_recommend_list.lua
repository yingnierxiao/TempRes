--------------------------------------------------------------
-- FileName: 	msg_friend_recommend_list.lua
-- author:		Zjj, 2013/08/28
-- purpose:		好友推荐消息
--------------------------------------------------------------

msg_friend_recommend_list = msg_base:new();
local p = msg_friend_recommend_list;
local super = msg_base;

--创建新实例
function p:new()	
	o = {}
	setmetatable( o, self );
	self.__index = self;
	o:ctor(); return o;
end

--构造函数
function p:ctor()
	super.ctor(self);
    self.idMsg = MSG_FRIEND_RECOMMEND_LIST; --消息号
end

--初始化
function p:Init()
end

--处理消息
function p:Process()
	msg_cache.msg_friend_recommend_list = self;
	WriteConWarning( "** msg_friend_recommend_list:Process() called" );
	friend_mgr.ShowFriendRecommendUI(self);
end
