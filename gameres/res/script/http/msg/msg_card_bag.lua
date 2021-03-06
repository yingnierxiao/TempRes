msg_card_bag = msg_base:new();
local p = msg_card_bag;
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
	self.idMsg = MSG_CARD_BAG;
	
	--self.id = nil;
	--self.type = nil;
end

function p:Init()
end

function p:Process()
	msg_cache.msg_card_bag = self;
    WriteConWarning( "** msg_card_bag:Process() called" );
	card_bag_mgr.RefreshUI(self);
	if self.result == true then 
		--card_bag_mgr.RefreshUI(self.cardlist);
		card_intensify2.ShowCardList(self.cardlist,self);
		card_intensify.ShowCardList(self.cardlist,self);
	else
		WriteConWarning( "** msg_card_bag error" );
	end
end
