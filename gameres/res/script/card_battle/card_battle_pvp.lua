--------------------------------------------------------------
-- FileName: 	card_battle_pvp.lua
-- author:		zhangwq, 2013/08/14
-- purpose:		卡牌战斗：玩家对战
--------------------------------------------------------------

card_battle_pvp = {}
local p = card_battle_pvp;

local ui = ui_card_battle_pvp;
local heroUIArray = { 
    ui.ID_CTRL_SPRITE_1, 
    ui.ID_CTRL_SPRITE_2, 
    ui.ID_CTRL_SPRITE_3, 
    ui.ID_CTRL_SPRITE_4, 
    ui.ID_CTRL_SPRITE_5, 
}
local enemyUIArray = { 
    ui.ID_CTRL_SPRITE_6,
    ui.ID_CTRL_SPRITE_7,
    ui.ID_CTRL_SPRITE_8,
    ui.ID_CTRL_SPRITE_9,
    ui.ID_CTRL_SPRITE_10,
	ui.ID_CTRL_SPRITE_boss
}    

-----
p.battleLayer = nil;
p.TestHeroFighter1 = nil;
-----

--设置可见
function p.HideUI()
	if p.battleLayer ~= nil then
		p.battleLayer:SetVisible( false );
		GetBattleShow():EnableTick( false );
	end
end

--显示UI
function p.ShowUI()
	if p.battleLayer ~= nil then
		p.battleLayer:SetVisible( true );
		GetBattleShow():EnableTick( true );
		return;
	end

	local layer = createCardBattleUILayer();
    if layer == nil then
        return false;
    end

	layer:Init();
	layer:SetSwallowTouch(false);
	layer:SetFrameRectFull();
	layer:SetSortZOrderByFlag( true );
	GetRunningScene():AddChild(layer);

    LoadUI("card_battle_pvp.xui", layer, nil);

	layer:SetFramePosXY(0,0);
	p.battleLayer = layer;
	
	local skillNameBar = GetImage( p.battleLayer ,ui_card_battle_pvp.ID_CTRL_PICTURE_13 )
	skillNameBar:SetFramePosXY(0,skillNameBar:GetFramePos().y);
	p.skillNameBarOldPos = skillNameBar:GetFramePos();
	
	--添加战斗背景图片
	--p.AddBattleBg();
	
	--战斗
	p.InitBattle();
	return true;
end

--关闭
function p.CloseUI()
	if p.battleLayer ~= nil then	
		p.battleLayer:LazyClose();
		p.battleLayer = nil;
	end
	GetBattleShow():EnableTick( false );
end

--设置技能名称栏UI到左边，以提供从左进入特效
function p.SetSkillNameBarToLeft()
	local skillNameBar = GetImage( p.battleLayer ,ui_card_battle_pvp.ID_CTRL_PICTURE_13 )
	skillNameBar:SetFramePos(p.skillNameBarOldPos);
	
	local tempPos = skillNameBar:GetFramePos();
	tempPos.x = tempPos.x - GetScreenWidth();
	skillNameBar:SetFramePos(tempPos);
end

--设置技能名称栏UI到右边，以提供从右进入特效
function p.SetSkillNameBarToRight()
	local skillNameBar = GetImage( p.battleLayer ,ui_card_battle_pvp.ID_CTRL_PICTURE_13 )
	skillNameBar:SetFramePos(p.skillNameBarOldPos);
	
	local tempPos = skillNameBar:GetFramePos();
	tempPos.x = tempPos.x + GetScreenWidth();
	skillNameBar:SetFramePos(tempPos);
end

--添加战斗背景框
function p.AddBattleBg()
	local bg = createNDUIImage();
	bg:Init();
	bg:SetFrameRectFull();
	p.battleLayer:AddChildZTag( bg, E_BATTLE_Z_GROUND, E_BATTLE_TAG_GROUND );
	
	--获取ani配置中的图片
	local pic = GetPictureByAni("x.battle_bg", 1);
	bg:SetPicture( pic );
	--bg:SetVisible( false );
end

--还原技能名称栏的位置
function p.ReSetSkillNameBarPos()
	local skillNameBar = GetImage( p.battleLayer ,ui_card_battle_pvp.ID_CTRL_PICTURE_13 );
	skillNameBar:SetFramePos(p.skillNameBarOldPos);
	skillNameBar:DelAniEffect("x_cmb.skill_name_fx");
	skillNameBar:DelAniEffect("x_cmb.skill_name_fx_reverse");
end


--初始化战斗
function p.InitBattle()
	card_battle_mgr.uiLayer = p.battleLayer;
	card_battle_mgr.heroUIArray = heroUIArray;
	card_battle_mgr.enemyUIArray = enemyUIArray;
	card_battle_mgr.play_pvp();
end