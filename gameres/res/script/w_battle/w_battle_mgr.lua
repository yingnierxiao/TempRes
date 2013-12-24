--------------------------------------------------------------
-- FileName: 	n_battle_mgr.lua
-- author:		zhangwq, 2013/06/20
-- purpose:		ս������������ʵ����demo v2.0
--------------------------------------------------------------

n_battle_mgr = {}
local p = n_battle_mgr;

p.heroCamp = nil;			--�����Ӫ
p.enemyCamp = nil;			--�ж���Ӫ
p.uiLayer = nil;			--ս����
p.heroUIArray = nil;		--�����ӪվλUITag��
p.enemyUIArray = nil;		--�ж���ӪվλUITag��

p.petNode={};       --˫��������
p.petNameNode={};   --˫���������ƽ��

p.imageMask = nil			--�����ɰ���Ч

local isPVE = false;
local isActive = false;
local useParallelBatch = true; --�Ƿ�ʹ�ò�������
p.isBattleEnd = false;

local BATTLE_PVE = 1;
local BATTLE_PVP = 2;

--��ʼս������:pve
function p.play_pve( targetId )
    WriteCon("-----------------Enter the pve mission id = "..targetId);
	isPVE = true;	
	n_battle_stage.Init();
    n_battle_stage.EnterBattle_Stage_Loading();
    p.SendStartPVEReq( targetId );
end

--��ʼս������:pvp
function p.play_pvp( targetId )
    WriteCon("-----------------Enter the pvp Tuser id = "..targetId);
    isPVE = false;
    n_battle_stage.Init();
    n_battle_stage.EnterBattle_Stage_Loading();
    p.SendStartPVPReq( targetId );
end

--��ʾ�غ���
function p.ShowRoundNum()
    --local roundNum = n_battle_stage.GetRoundNum();
    --n_battle_mainui.ShowRoundNum( roundNum );
    n_battle_show.DoEffectShowTurnNum();
end

--ս���׶�->����->����
function p.SendStartPVPReq( targetId )
    local UID = GetUID();
    if UID == 0 or UID == nil then
        return ;
    end;
    local param = string.format("&target=%d", targetId);
    SendReq("Fight","StartPvP",UID,param);
end

--ս���׶�->����->����
function p.SendStartPVEReq( targetId )
    --local TID = 101011;
    local UID = GetUID();
    if UID == 0 or UID == nil then
        return ;
    end;
    local param = string.format("&missionID=%d", targetId);
    SendReq("Fight","StartPvC",UID,param);
end

--ս���׶�PVP->����->��Ӧ
function p.ReceiveStartPVPRes( msg )
    n_battle_db_mgr.Init( msg );
    local UCardList = n_battle_db_mgr.GetPlayerCardList();
    local TCardList = n_battle_db_mgr.GetTargetCardList();
    local TPetList = n_battle_db_mgr.GetTargetPetList();
    local UPetList = n_battle_db_mgr.GetPlayerPetList();
    if UCardList == nil or TCardList == nil or #UCardList == 0 or #TCardList == 0 then
    	WriteConErr(" battle data err! ");
    	return false;
    end
    p.createHeroCamp( UCardList );
    p.createEnemyCamp( TCardList );
    
    p.createPet( UPetList, E_CARD_CAMP_HERO );
    p.createPet( TPetList, E_CARD_CAMP_ENEMY );
    p.ReSetPetNodePos();
    
    n_battle_pvp.ReadyGo();
    p.ShowRoundNum();
end

--ս���׶�PVE->����->��Ӧ
function p.ReceiveStartPVERes( msg )
	p.ReceiveStartPVPRes( msg );
end

--ս���׶�->����BUFF����
function p.EnterBattle_Stage_Permanent_Buff()
	n_battle_mainui.OnBattleShowFinished();
end

--����غϽ׶�->�ٻ��ޱ���
function p.EnterBattle_RoundStage_Pet()
    local rounds = n_battle_stage.GetRoundNum();
    local petData = n_battle_db_mgr.GetPetRoundDB( rounds );
    if petData ~= nil and #petData > 0 and rounds <= N_BATTLE_MAX_ROUND then
        n_battle_show.DoEffectPetSkill( petData );
    else
        n_battle_mainui.OnBattleShowFinished();    
    end
end

--����غϽ׶�->BUFF����
function p.EnterBattle_RoundStage_Buff()
    local rounds = n_battle_stage.GetRoundNum();
    local buffEffectData = n_battle_db_mgr.GetBuffEffectRoundDB( rounds );
    if buffEffectData ~= nil and #buffEffectData > 0 and rounds <= N_BATTLE_MAX_ROUND then
        n_battle_show.DoEffectBuff( buffEffectData );
    else
        n_battle_mainui.OnBattleShowFinished();   
    end
end

--����սʿ���ϵ�BUFF
function p.UpdateFighterBuff()
	local heroes = p.heroCamp:GetAliveFighters();
	p.DelFighterBuff( heroes );
	local enemies = p.enemyCamp:GetAliveFighters();
	p.DelFighterBuff( enemies );
end

--����սʿ���ϵ�BUFF
function p.DelFighterBuff( fighters )
	if fighters ~= nil and #fighters >0 then
        for key, fighter in ipairs(fighters) do
            local fighterBuff = fighter.buffList;
            for k, v in ipairs(fighterBuff) do
                local buffType = v.buttType;
                local buffAni = v.buffAni;
                if not v.isDel and not HasBuffType( fighter, buffType ) then
                    fighter:GetNode():DelAniEffect( buffAni );
                    v.isDel = true;
                end
            end
        end
    end
end

--����غϽ׶�->��Ź
function p.EnterBattle_RoundStage_Atk()
    local rounds = n_battle_stage.GetRoundNum();
    local atkData = n_battle_db_mgr.GetRoundDB( rounds );
    if atkData ~= nil and #atkData > 0 and rounds <= N_BATTLE_MAX_ROUND then
    	n_battle_show.DoEffectAtk( atkData );
    else
        n_battle_mainui.OnBattleShowFinished();	
    end
end

--����غϽ׶�->����
function p.EnterBattle_RoundStage_Clearing()
    if not p.CheckBattleWin() then
         p.CheckBattleLose();
    end
    --������һ���غ�
    n_battle_stage.NextRound();
    p.ShowRoundNum();
    p.UpdatePetRage();
    n_battle_mainui.OnBattleShowFinished();
end

--ȡս����
function p:GetBattleLayer()
	if not isPVE then
		return n_battle_pvp.battleLayer;
	end
	return nil;
end

--��������
function p.createPet( petList, camp )
	if petList == nil or #petList < 0 then
        return false;
    end
    for key, var in ipairs(petList) do
        local petId = tonumber( var.Pet_id );
        local skillId = tonumber( var.Skill_id );
        local Position = tonumber( var.Position );
        
        if camp == E_CARD_CAMP_ENEMY then
        	Position = Position + N_BATTLE_CAMP_CARD_NUM ;
        end
        
        local petPic = createNDUINode();
        petPic:Init();
        if camp == E_CARD_CAMP_ENEMY then
        	petPic:AddFgReverseEffect( SelectCell( T_PET_RES, petId, "total_pic" ) );
        else
            petPic:AddFgEffect( SelectCell( T_PET_RES, petId, "total_pic" ) );
        end
        p.uiLayer:AddChildZ( petPic,101);
        petPic:SetId( Position );
        p.petNode[ #p.petNode+1 ] = petPic;
        
        local petName = createNDUINode();
        petName:Init();
        petName:AddFgEffect( SelectCell( T_SKILL_RES, skillId, "name_effect" ) );
        p.uiLayer:AddChildZ( petName,101);
        p.petNameNode[ #p.petNameNode+1 ] = petName;
        petName:SetId( Position );
        
        local petLV = tonumber( var.Level );
        local petName = SelectCell( T_PET, petId, "name" );
        local petIconAni = SelectCell( T_PET_RES, petId, "face_pic" );
        local petSkillIconAni = SelectCell( T_SKILL_RES, skillId, "icon" );
        
        n_battle_pvp.InitPetUI( Position, petName, petLV, petIconAni, petSkillIconAni );
        n_battle_pvp.InitPetRage( Position, 0 );
    end
end

--���³���ŭ��
function p.UpdatePetRage()
    local UPetList = n_battle_db_mgr.GetPlayerPetList();
    local TPetList = n_battle_db_mgr.GetTargetPetList();
    if UPetList ~= nil then
    	for key, var in ipairs(UPetList) do
            local pos = tonumber( var.Position );
            local sp = tonumber( var.Sp );
            n_battle_pvp.UpdatePetRage( pos, sp );
        end
    end
    if TPetList ~= nil then
        for key, var in ipairs(UPetList) do
            local pos = tonumber( var.Position ) + N_BATTLE_CAMP_CARD_NUM;
            local sp = tonumber( var.Sp );
            n_battle_pvp.UpdatePetRage( pos, sp );
        end
    end
    
end

--��ȡ������
function p.GetPetNode( posId, camp )
	if posId == nil or camp == nil then
		return false;
	end
	local ln = #p.petNode;
	local posId = tonumber( posId )
	if camp == E_CARD_CAMP_ENEMY then
		posId = posId + N_BATTLE_CAMP_CARD_NUM;
	end
	for i=1, ln do
		local pNode = p.petNode[i];
		if pNode ~= nil and pNode:GetId() == posId then
			return pNode;
		end
	end
end 

--��ȡ�������ƽ��
function p.GetPetNameNode( posId, camp )
    if posId == nil or camp == nil then
        return false;
    end
    local ln = #p.petNameNode;
    local posId = tonumber( posId )
    if camp == E_CARD_CAMP_ENEMY then
        posId = posId + N_BATTLE_CAMP_CARD_NUM;
    end
    for i=1, ln do
        local pNode = p.petNameNode[i];
        if pNode ~= nil and pNode:GetId() == posId then
            return pNode;
        end
    end
end

--���ó��Ｐ���ƽ��λ��
function p.ReSetPetNodePos()
	local ln = #p.petNode;
	local ln2 = #p.petNameNode;
    for i=1, ln do
        local petNode = p.petNode[i];
        local id = petNode:GetId();
        if id > N_BATTLE_CAMP_CARD_NUM then
            petNode:SetFramePosXY( 768, GetScreenHeight()/2 - 128 );
        else
            petNode:SetFramePosXY( -256, GetScreenHeight()/2 ); 
        end
    end
    for j=1, ln2 do
        local pNode = p.petNameNode[j];
        local pId = pNode:GetId();
        if pId > N_BATTLE_CAMP_CARD_NUM then
            pNode:SetFramePosXY( -256, GetScreenHeight()/2 - 128 );
        else
            pNode:SetFramePosXY( 768, GetScreenHeight()/2 ); 
        end
    end
end

--�����ɰ�ͼƬ
function p.AddMaskImage()
	if p.imageMask == nil then
		p.imageMask = createNDUIImage();
		p.imageMask:Init();
		p.imageMask:SetFrameRectFull();
		
		local pic = GetPictureByAni("lancer.mask", 0); 
		p.imageMask:SetPicture( pic );
		p.uiLayer:AddChildZ( p.imageMask,100);
		p.imageMask:AddActionEffect("x.imageMask_fadein");
	else
		p.ShowMaskImage();
	end
end

--��ʾ�ɰ�
function p.ShowMaskImage()
	if p.imageMask ~= nil then
		--p.imageMask:SetVisible(true);
		p.imageMask:AddActionEffect("x.imageMask_fadein");
	end
end

--����ʾ�ɰ�
function p.HideMaskImage()
	if p.imageMask ~= nil then
		--p.imageMask:SetVisible(false);
		p.imageMask:AddActionEffect("x.imageMask_fadeout");
	end
end

--[[
--ȡboss
function p.GetBoss()
	return p.enemyCamp:GetFirstFighter();
end
--]]

--�Ƿ�active
function p.IsActive()
    return isActive;
end

--ȡ��һ��hero
function p.GetFirstHero()
	return p.heroCamp:GetFirstFighter();
end

--ȡ��һ��enemy
function p.GetFirstEnemy()
	return p.enemyCamp:GetFirstFighter();
end

--���������Ӫ
function p.createHeroCamp( fighters )
	p.heroCamp = n_battle_camp:new();
	p.heroCamp.idCamp = E_CARD_CAMP_HERO;
	p.heroCamp:AddFighters( p.heroUIArray, fighters );
	p.heroCamp:AddShadows( p.heroUIArray, fighters );
	p.heroCamp:AddAllRandomTimeJumpEffect(true);
end

--�����ж���Ӫ
function p.createEnemyCamp( fighters )
	p.enemyCamp = n_battle_camp:new();
	p.enemyCamp.idCamp = E_CARD_CAMP_ENEMY;
	p.enemyCamp:AddFighters( p.enemyUIArray, fighters );
	p.enemyCamp:AddShadows( p.enemyUIArray, fighters );
	p.enemyCamp:AddAllRandomTimeJumpEffect(false);
end

--����PVP
function p.TestPVP()

end

--���������һ��(PVP)
function p.JumpToPoint( pSeq,Pos )
	local batch = battle_show.GetNewBatch();
	local f1 = p.heroCamp:GetRandomFighter();
	local f2 = p.enemyCamp:GetRandomFighter();
	local f3,f4 = p.enemyCamp:GetRandomFighter_2();
	
--	f1:AtkSkillMul( f3, f4, batch );
--	do return end

end

--����fighter
function p.FindFighter(id)
	local f = p.heroCamp:FindFighter(id);
	if f == nil then
		f = p.enemyCamp:FindFighter(id);
	end
	return f;
end

--ս��ʤ��
function p.OnBattleWin()
	--GetBattleShow():Stop();
	p.isBattleEnd = true;
	SetTimerOnce( p.OpenBattleWin, 1.0f );
end

--��ս��ʤ������
function p.OpenBattleWin()
	PlayEffectSoundByName( "battle_win.mp3" );
	n_battle_ko.CloseUI();
	--dlg_battle_win.ShowUI();
	quest_reward.ShowUI( n_battle_db_mgr.GetRewardData() );
end

--ս��ʧ��
function p.OnBattleLose()
	--GetBattleShow():Stop();
	p.isBattleEnd = true;
	SetTimerOnce( p.OpenBattleLose, 2.0f );
end

--��ս��ʧ�ܽ���
function p.OpenBattleLose()
	--dlg_battle_lose.ShowUI();
	quest_reward.ShowUI( n_battle_db_mgr.GetRewardData() );
end

--����Ƿ�ս��ʤ��
function p.CheckBattleWin()
	if p.enemyCamp:IsAllFighterDead() then
		p.OnBattleWin();
		return true;
	end
	return false;
end

--����Ƿ�ս��ʧ��
function p.CheckBattleLose()
	if p.heroCamp:IsAllFighterDead() then
		p.OnBattleLose();
		return true;
	end
	return false;
end

--����ս��
function p.EnterBattle( battleType, missionId )
	WriteCon( "n_battle_mgr.EnterBattle()" );
	
	--hide 
	--GetTileMap():SetVisible( false );
	--task_map_mainui.HideUI();
	
	--���ذ�ť
--	dlg_userinfo2.HideUI();
--	dlg_menu.CloseUI();
    dlg_menu.CloseUI();
    dlg_userinfo.CloseUI();
    
	
	--enter PVP
	n_battle_pvp.ShowUI( battleType, missionId );	
	n_battle_mainui.ShowUI();
	
	--����
	PlayMusic_Battle();
	
	isActive = true;
end

--�˳�ս��
function p.QuitBattle()
	WriteCon( "n_battle_mgr.QuitBattle()" );

	n_battle_pvp.CloseUI();
	n_battle_mainui.CloseUI();

	--game_main.EnterWorldMap();
	dlg_menu.ShowUI();
	dlg_userinfo.ShowUI();
		
	hud.FadeIn();
	
	--����
	PlayMusic_Task();
	
	isActive = false;
	p.clearDate();
end

--���ս������
function p.IsBattleEnd()
	if p.heroCamp:IsAllFighterDead() then
		return true;
	end
	
	if p.enemyCamp:IsAllFighterDead() then
		return true;
	end

	return false;
end

function p.clearDate()
	p.heroCamp = nil;
    p.enemyCamp = nil;          
    p.uiLayer = nil;           
    p.heroUIArray = nil;        
    p.enemyUIArray = nil;       
    p.petNode={};     
    p.petNameNode={};   
    p.imageMask = nil          
    p.isBattleEnd = false;
    n_battle_show.DestroyAll();
end