--------------------------------------------------------------
-- FileName: 	x_battle_camp.lua
-- BaseClass:   battle_camp
-- author:		zhangwq, 2013/06/20
-- purpose:		作战阵营（多实例）
--------------------------------------------------------------

x_battle_camp = battle_camp:new();
local p = x_battle_camp;
local super = battle_camp;
local g_Herofighters = nil;
local g_HeroIndex = 1;
local g_Enemyfighters = nil;
local g_EnemyIndex = 1;
local g_HeroShadows = nil;
local g_HeroShadowIndex = 1;
local g_EnemyShadows = nil;
local g_EnemyShadowsIndex = 1;

PET_FLY_DRAGON_TAG = 1;
PET_MINING_TAG  = 2;
PET_BLUE_DEVIL_TAG = 3;
BOSS_TAG = 4;

local tobjId = {"10392","10684","10706","10745","10774","10835","10836","10838","10884","10953","10999","11000","11007","11008","11024","11027"}

function p:new()
	o = {}
	setmetatable( o, self );
	self.__index = self;
	o:ctor();
	p.jumpIndex = 1;
	return o;
end

--构造函数
function p:ctor()
    super.ctor(self);
end

--获取存活fighters
function p:GetAliveFighters()
	local t = {}
	for k,v in ipairs(self.fighters) do
		if v ~= nil and (not v.isDead) and v:CheckTmpLife() then
			t[#t + 1] = v;
		end
	end
	return t;
end

--添加战士

function p:AddBoss()
	local uiTag = 14;
	local node = GetPlayer( x_battle_mgr.uiLayer, uiTag );
	if node == nil then
		WriteCon( "get player node failed" );
		return;
	end
		
	local f = x_fighter:new();
	self.fighters[#self.fighters + 1] = f;
		
	f:Init( uiTag, node, self.idCamp );
	self:SetBossConfig( f);
	f:standby();
	f.idCamp = E_CARD_CAMP_ENEMY;
		
	if self:IsHeroCamp() then
		node:SetZOrder( 3 );
		f:SetLookAt( E_LOOKAT_RIGHT );
	else
		node:SetZOrder( 3 );
		f:SetLookAt( E_LOOKAT_LEFT );
	end
end

function p.AddHeroFightersJumpEffect()
	local pFighter = g_Herofighters[g_HeroIndex];

	if pFighter == nil then
		return nil;
	end
	
	local node = pFighter:GetPlayerNode();
	if node == nil then
		WriteCon( "get player node failed" );
		return;
	end
		
	local pOldPos = node:GetFramePos();
	
	local x = pOldPos.x + 444;
	local y = pOldPos.y;

	local pNewPos = CCPointMake(x,y);	
	
	local batch = battle_show.GetNewBatch();
	local cmd = pFighter:JumpToPosition(batch,pNewPos,true);
	
	g_HeroIndex = g_HeroIndex + 1;
end

function p.AddEnemyFightersJumpEffect()
	local pFighter = g_Enemyfighters[g_EnemyIndex];

	if pFighter == nil then
		return nil;
	end
	
	local node = pFighter:GetPlayerNode();
	if node == nil then
		WriteCon( "get player node failed" );
		return;
	end
		
	local pOldPos = node:GetFramePos();
	
	local x = pOldPos.x - 440;
	local y = pOldPos.y;

	local pNewPos = CCPointMake(x,y);	
	
	local batch = battle_show.GetNewBatch();
	local cmd = pFighter:JumpToPosition(batch,pNewPos,true);
	
	g_EnemyIndex = g_EnemyIndex + 1;
end

function p:AddAllRandomTimeJumpEffect(bHero)
	if bHero == true then
		g_Herofighters = self.fighters;
		for k,v in ipairs(self.fighters) do
			local fTime = k / 10.0f + 0.3f;
			local str = string.format("Hero jump time is %8.6f",fTime);
			WriteCon(str);
			SetTimerOnce( p.AddHeroFightersJumpEffect, fTime );
		end
	else
		g_Enemyfighters = self.fighters;
		for k,v in ipairs(self.fighters) do
			local fTime = k / 10.0f + 0.3f;
			local str = string.format("Enemy jump time is %8.6f",fTime);
			WriteCon(str);
			SetTimerOnce( p.AddEnemyFightersJumpEffect, fTime );
		end
	end
end

function p:AddShadows(uiArray)
	for i = 1,#uiArray do
		local uiTag = uiArray[i];
		local node = GetPlayer( x_battle_mgr.uiLayer, uiTag );
		if node == nil then
			WriteCon( "get player node failed" );
			return;
		end
		
		local kShadow = shadow:new();
		local nIndex = #self.shadows + 1;
		self.shadows[nIndex] = kShadow;
		local pOldPos = node:GetFramePos();

		if self.idCamp == E_CARD_CAMP_HERO then
			pOldPos.x = pOldPos.x;
		elseif self.idCamp == E_CARD_CAMP_ENEMY then
			pOldPos.x = pOldPos.x;
		end
		
		node:SetFramePos(pOldPos);
		
		local kShadowNode = kShadow:Init("lancer.shadow",node);
		self.fighters[nIndex]:SetShadow(kShadow.m_kNode);
		x_battle_mgr.uiLayer:AddChildZ(kShadowNode,0);
		--self:SetFighterConfig( kShadow, i );
		--kShadow:standby();
		
		if self:IsHeroCamp() then
			--node:SetZOrder( E_BATTLE_Z_HERO_FIGHTER );
			--kShadow:SetLookAt( E_LOOKAT_RIGHT );
		else
			--node:SetZOrder( E_BATTLE_Z_ENEMY_FIGHTER );
			--kShadow:SetLookAt( E_LOOKAT_LEFT );
		end
	end
end

function p:AddFighters( uiArray )
	for i = 1,#uiArray do
		local uiTag = uiArray[i];
		local node = GetPlayer( x_battle_mgr.uiLayer, uiTag );
		if node == nil then
			WriteCon( "get player node failed" );
			return;
		end
		
		local f = x_fighter:new();
		self.fighters[#self.fighters + 1] = f;
		local pOldPos = node:GetFramePos();

		if self.idCamp == E_CARD_CAMP_HERO then
			pOldPos.x = pOldPos.x * GetUIRoot():GetUIScale();
			pOldPos.x = pOldPos.x - 440;
		elseif self.idCamp == E_CARD_CAMP_ENEMY then
			pOldPos.x = pOldPos.x * GetUIRoot():GetUISclae();
			pOldPos.x = pOldPos.x + 440;
		end
		node:SetFramePos(pOldPos);
		
		f:Init( uiTag, node, self.idCamp );
		self:SetFighterConfig( f, i );
		f:standby();
		f.defence = i;
		f.attack_min = 90 - i * 3;
		f.attack_max = 110 - i * 3;
		f.strike_level = i * 200;

		local ft = self.fighters[1];
		ft.defence = 100;
		
		if self:IsHeroCamp() then
			node:SetZOrder( E_BATTLE_Z_HERO_FIGHTER );
			f:SetLookAt( E_LOOKAT_RIGHT );
		else
			node:SetZOrder( E_BATTLE_Z_ENEMY_FIGHTER );
			f:SetLookAt( E_LOOKAT_LEFT );
		end
	end
end

--设置fighter配置

function p:SetBossConfig( f )
	if f == nil then return end;

	f:UseConfig( "boss" );
	f.petTag = BOSS_TAG;
		
		--f:UseConfig( "blue_devil" );
		--f.petTag = PET_BLUE_DEVIL_TAG;
end

function p:SetFighterConfig( f, idx )
	if f == nil then return end;

	--@override:测试用,重载宠物类型
	if false then
		f:UseConfig( "fly_dragon" );
		f.petTag = PET_FLY_DRAGON_TAG;
		return;
	end
	
	f:UseConfig( string.format("test%s", tobjId[self.idCamp == E_CARD_CAMP_HERO and idx or idx + 8]) );
	f.petTag = idx % 2 == 0 and PET_FLY_DRAGON_TAG or PET_BLUE_DEVIL_TAG;
end
