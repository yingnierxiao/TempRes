--------------------------------------------------------------
-- FileName:    msg_battle.lua
-- author:      hst, 2013/12/6
-- purpose:     PVE
--------------------------------------------------------------

msg_battle_pve = msg_base:new();
local p = msg_battle_pve;
local super = msg_base;

--������ʵ��
function p:new()    
    o = {}
    setmetatable( o, self );
    self.__index = self;
    o:ctor(); return o;
end

--���캯��
function p:ctor()
    super.ctor(self);
    self.idMsg = MSG_BATTLE; --��Ϣ��
end

--��ʼ��
function p:Init()
end

--������Ϣ
function p:Process()
    WriteCon( "** msg_battle:Process() called" );
    n_battle_mgr.ReceiveStartPVERes( self );
end

--[[
msg_battle = msg_base:new();
local p = msg_battle;
local super = msg_base;

--�¼�����
local EVENT_TYPE_BATTLE_BEGIN = 1; --ս����ʼ
local EVENT_TYPE_BATTLE_END = 2;   --ս������

--������ʵ��
function p:new()    
    o = {}
    setmetatable( o, self );
    self.__index = self;
    o:ctor(); return o;
end

--���캯��
function p:ctor()
    super.ctor(self);
    self.idMsg = MSG_BATTLE; --��Ϣ��
    self.event_type = 0;
end

--��ʼ��
function p:Init()
end

--������Ϣ
function p:Process()
    WriteCon( "** msg_battle:Process() called" );
end
--]]