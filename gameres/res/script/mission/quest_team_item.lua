quest_team_item = {}
local p = quest_team_item;

local ui = ui_quest_team_item
local ui_team = ui_cha;
local ui_item = ui_item;
p.layer = nil;
p.stageId = nil;
p.missionId = nil;
p.nowTeamId = nil;
p.teamListData = {};
p.itemListData = {};
p.teamTableView = nil;
p.storyId = nil;

function p.ShowUI(missionId,stageId,nowTeamId,storyId)
	if missionId == nil or stageId == nil then
		WriteConErr("param errer");
		return
	end
	dlg_menu.SetNewUI( p );
	maininterface.HideUI();

	p.stageId = stageId;
	p.missionId = missionId;
	p.nowTeamId = nowTeamId or 1;
	p.storyId = storyId or p.storyId or 0;
	if p.layer ~= nil then 
		p.layer:SetVisible(true);
		return;
	end
	
	local layer = createNDUIDialog();
	if layer == nil then
		return false;
	end

	layer:NoMask();
	layer:Init();
	layer:SetSwallowTouch(false);
	
	GetUIRoot():AddChild(layer);
	LoadDlg("quest_team_item.xui",layer,nil);
	
	p.layer = layer;
	p.SetDelegate(layer);
	
	p.Init()
end

function p.Init()
	local stageTable =  SelectRowInner(T_STAGE,"stage_id",p.stageId);
	local stageNameText = GetLabel(p.layer, ui.ID_CTRL_TEXT_QUEST_NAME);
	stageNameText:SetText(stageTable.stage_name);

	local missionTable = SelectRowInner(T_MISSION,"id",p.missionId);
	local powerText = GetLabel(p.layer, ui.ID_CTRL_TEXT_POWER_V);
	powerText:SetText(missionTable.move_cost);
	
	local uid = GetUID();
	SendReq("Mission","BattleItemOrTeam",uid,"");
	--local param = "Stage_id="..p.stageId;
	--p.showTeamItem()
end

function p.showTeamItem(data)
	if data.result == false then
		dlg_msgbox.ShowOK("错误提示",data.message,nil,p.layer);
		return;
	end

	if data.teams ~= nil then
		p.teamListData = data.teams
	end
	p.ShowTeamList(p.teamListData)
	
	p.itemListData = data.battle_items
	p.ShowItemList(p.itemListData)
end


function p.ShowTeamList(teamData)
	if teamData == nil then
		WriteConErr("teamData is nil");
		return
	end
	local teamNum = 0;
	for k,v in pairs(teamData) do 
		teamNum =  teamNum + 1
	end
	
	local teamTable = GetListBoxHorz(p.layer, ui.ID_CTRL_LIST_TEAM)
	if teamTable == nil then
		return
	end
	teamTable:SetSingleMode(true);
	teamTable:ClearView();
	
	for i = 1,teamNum do
		local teamInfo = teamData["Formation"..i]
		local teamId = i;
		
		local view = createNDUIXView();
		view:Init();
		LoadUI("cha.xui",view,nil);
		local bg = GetUiNode( view, ui_team.ID_CTRL_PICTURE_BG );
        view:SetViewSize( bg:GetFrameSize());
		view:SetId(i);
		view:SetTag(i);
		
		--队伍按钮
		local editTeamBtn = GetButton(view, ui_team.ID_CTRL_BUTTON_BG);
		editTeamBtn:SetId(teamId);
		editTeamBtn:SetLuaDelegate(p.OnBtnClick)
		local editTeamBtn2 = GetButton(view, ui_team.ID_CTRL_BUTTON_EDIT);
		editTeamBtn2:SetId(teamId);
		editTeamBtn2:SetLuaDelegate(p.OnBtnClick)
		
		--队伍图片
		local teamPic = GetImage(view, ui_team.ID_CTRL_PICTURE_TEAM_NUM);
		local teamPicIndex = teamId - 1;
		teamPic:SetPicture( GetPictureByAni("common_ui.teamName", teamPicIndex));
		
		--显示队伍信息
		if teamInfo ~= nil then
			p.showTeamInfo(view,teamInfo)
		end
		teamTable:AddView( view );
	end
	teamTable:SetEnableMove(true);
	-- local teamid = tonumber( p.nowTeam ) or 1;
	-- if teamid <= 0 then
		-- teamid = 0;
	-- else
		-- teamid = teamid - 1;
	-- end
	--teamTable:SetActiveView(0);
	
	local id = tonumber(p.nowTeamId) - 1
	teamTable:SetActiveView(id);

	p.teamTableView = teamTable;
end

function p.showTeamInfo(view,teamInfo)
	--卡牌头像
	local cardPic1 = GetImage(view, ui_team.ID_CTRL_PICTURE_CHA1);
	local cardPic2 = GetImage(view, ui_team.ID_CTRL_PICTURE_CHA2);
	local cardPic3 = GetImage(view, ui_team.ID_CTRL_PICTURE_CHA3);
	local cardPic4 = GetImage(view, ui_team.ID_CTRL_PICTURE_CHA4);
	local cardPic5 = GetImage(view, ui_team.ID_CTRL_PICTURE_CHA5);
	local cardPic6 = GetImage(view, ui_team.ID_CTRL_PICTURE_CHA6);
	
	local attackText = GetLabel(view, ui_team.ID_CTRL_TEXT_ATTACK_V);
	local defenseText = GetLabel(view, ui_team.ID_CTRL_TEXT_DEFENSE_V);
	local HPText = GetLabel(view, ui_team.ID_CTRL_TEXT_HP_V);
	
	local cardLv1 = GetLabel(view, ui_team.ID_CTRL_TEXT_LV1);
	local cardLv2 = GetLabel(view, ui_team.ID_CTRL_TEXT_LV2);
	local cardLv3 = GetLabel(view, ui_team.ID_CTRL_TEXT_LV3);
	local cardLv4 = GetLabel(view, ui_team.ID_CTRL_TEXT_LV4);
	local cardLv5 = GetLabel(view, ui_team.ID_CTRL_TEXT_LV5);
	local cardLv6 = GetLabel(view, ui_team.ID_CTRL_TEXT_LV6);
	
	local cardLvPic1 = GetImage(view, ui_team.ID_CTRL_PICTURE_LV1);
	local cardLvPic2 = GetImage(view, ui_team.ID_CTRL_PICTURE_LV2);
	local cardLvPic3 = GetImage(view, ui_team.ID_CTRL_PICTURE_LV3);
	local cardLvPic4 = GetImage(view, ui_team.ID_CTRL_PICTURE_LV4);
	local cardLvPic5 = GetImage(view, ui_team.ID_CTRL_PICTURE_LV5);
	local cardLvPic6 = GetImage(view, ui_team.ID_CTRL_PICTURE_LV6);
	
	--设置攻击,防御,HP
	local attackV = 0;
	local defenseV = 0;
	local hpV = 0;
	local cardId = nil;
	for k,v in pairs(teamInfo) do
		for j,h in pairs(v) do
			if j == "Attack" then
				attackV = attackV + tonumber(h)
			elseif j == "Defence" then
				defenseV = defenseV + tonumber(h)
			elseif j == "Hp" then
				hpV = hpV + tonumber(h)
			elseif j == "CardID" then
				cardId = tonumber(h);
			end
		end
		local cardPicTable = SelectRowInner(T_CHAR_RES,"card_id",cardId);
		if cardPicTable == nil then
			WriteConErr("cardPicTable error ");
		end
		local aniIndex = cardPicTable.head_pic;
		local cardPic = nil;
		local cardLvText = nil;
		local cardLvBgPic = nil;
		if k == "Pos1" then
			cardPic = cardPic1
			cardLvText = cardLv1
			cardLvBgPic = cardLvPic1
		elseif k == "Pos2" then
			cardPic = cardPic2
			cardLvText = cardLv2
			cardLvBgPic = cardLvPic2
		elseif k == "Pos3" then
			cardPic = cardPic3
			cardLvText = cardLv3
			cardLvBgPic = cardLvPic3
		elseif k == "Pos4" then
			cardPic = cardPic4
			cardLvText = cardLv4
			cardLvBgPic = cardLvPic4
		elseif k == "Pos5" then
			cardPic = cardPic5
			cardLvText = cardLv5
			cardLvBgPic = cardLvPic5
		elseif k == "Pos6" then
			cardPic = cardPic6
			cardLvText = cardLv6
			cardLvBgPic = cardLvPic6
		end
		cardPic:SetPicture( GetPictureByAni(aniIndex, 0) );
		cardLvText:SetText(tostring(teamInfo[k]["Level"]));
		cardLvBgPic:SetPicture( GetPictureByAni("common_ui.levelPic", 0) );
		
	end
	
	attackText:SetText(tostring(attackV));
	defenseText:SetText(tostring(defenseV));
	HPText:SetText(tostring(hpV));
end

function p.ShowItemList(itemData)
		local tiemTable = GetListBoxHorz(p.layer, ui.ID_CTRL_LIST_ITEM)
		if tiemTable == nil then 
			return
		end
		tiemTable:ClearView();
		
		local view = createNDUIXView();
		view:Init();
		
		LoadUI("item.xui",view,nil);
		local bg = GetUiNode( view, ui_item.ID_CTRL_PICTURE_BG );
        view:SetViewSize( bg:GetFrameSize());
		
		--编辑物品按钮
		local editItemBtn = GetButton(view, ui_item.ID_CTRL_BUTTON_BG);
		--editItemBtn:SetId(teamId);
		editItemBtn:SetLuaDelegate(p.OnBtnClick)
		local editItemBtn2 = GetButton(view, ui_item.ID_CTRL_BUTTON_ITEM_EDIT);
		editItemBtn2:SetLuaDelegate(p.OnBtnClick)

		local itemPic1 = GetImage(view, ui_item.ID_CTRL_PICTURE_ITEM1);
		local itemPic2 = GetImage(view, ui_item.ID_CTRL_PICTURE_ITEM2);
		local itemPic3 = GetImage(view, ui_item.ID_CTRL_PICTURE_ITEM3);
		local itemPic4 = GetImage(view, ui_item.ID_CTRL_PICTURE_ITEM4);
		local itemPic5 = GetImage(view, ui_item.ID_CTRL_PICTURE_ITEM5);
		local itemName1 = GetLabel(view, ui_item.ID_CTRL_TEXT_ITEMNAME1);
		local itemName2 = GetLabel(view, ui_item.ID_CTRL_TEXT_ITEMNAME2);
		local itemName3 = GetLabel(view, ui_item.ID_CTRL_TEXT_ITEMNAME3);
		local itemName4 = GetLabel(view, ui_item.ID_CTRL_TEXT_ITEMNAME4);
		local itemName5 = GetLabel(view, ui_item.ID_CTRL_TEXT_ITEMNAME5);
		local itemNum1 = GetLabel(view, ui_item.ID_CTRL_TEXT_NUM1);
		local itemNum2 = GetLabel(view, ui_item.ID_CTRL_TEXT_NUM2);
		local itemNum3 = GetLabel(view, ui_item.ID_CTRL_TEXT_NUM3);
		local itemNum4 = GetLabel(view, ui_item.ID_CTRL_TEXT_NUM4);
		local itemNum5 = GetLabel(view, ui_item.ID_CTRL_TEXT_NUM5);
		
		local itemNumPic1 = GetImage(view, ui_item.ID_CTRL_PICTURE_32);
		local itemNumPic2 = GetImage(view, ui_item.ID_CTRL_PICTURE_33);
		local itemNumPic3 = GetImage(view, ui_item.ID_CTRL_PICTURE_34);
		local itemNumPic4 = GetImage(view, ui_item.ID_CTRL_PICTURE_35);
		local itemNumPic5 = GetImage(view, ui_item.ID_CTRL_PICTURE_36);

		local itemNamePic1 = GetImage(view, ui_item.ID_CTRL_PICTURE_1);
		local itemNamePic2 = GetImage(view, ui_item.ID_CTRL_PICTURE_2);
		local itemNamePic3 = GetImage(view, ui_item.ID_CTRL_PICTURE_3);
		local itemNamePic4 = GetImage(view, ui_item.ID_CTRL_PICTURE_4);
		local itemNamePic5 = GetImage(view, ui_item.ID_CTRL_PICTURE_5);

		if itemData ~= nil then
			local itemNum = #itemData
			--WriteConErr("itemNum == "..#itemData);
			local itemPic = nil;
			local itemName = nil;
			local itemNUm = nil;
			local itemNumPic = nil;
			local itemNamePic = nil;
			for i = 1,#itemData do
				if tonumber(itemData[i].location) == 1 then
					itemPic = itemPic1
					itemName = itemName1
					itemNUm = itemNum1
					itemNumPic = itemNumPic1
					itemNamePic = itemNamePic1
				elseif tonumber(itemData[i].location) == 2 then
					itemPic = itemPic2
					itemName = itemName2
					itemNUm = itemNum2
					itemNumPic = itemNumPic2
					itemNamePic = itemNamePic2
				elseif tonumber(itemData[i].location) == 3 then
					itemPic = itemPic3
					itemName = itemName3
					itemNUm = itemNum3
					itemNumPic = itemNumPic3
					itemNamePic = itemNamePic3
					elseif tonumber(itemData[i].location) == 4 then
					itemPic = itemPic4
					itemName = itemName4
					itemNUm = itemNum4
					itemNumPic = itemNumPic4
					itemNamePic = itemNamePic4
					elseif tonumber(itemData[i].location) == 5 then
					itemPic = itemPic5
					itemName = itemName5
					itemNUm = itemNum5
					itemNumPic = itemNumPic5
					itemNamePic = itemNamePic5
				end
				local itemId = tonumber(itemData[i].item_id)
				local itemNumber = tonumber(itemData[i].num)
				if itemId > 0 and itemNumber > 0 then
					itemNUm:SetText(tostring(itemNumber));
					WriteCon("itemId == "..itemId);
					
					local itemTable = SelectRowInner(T_MATERIAL,"id",itemId);
					if itemTable == nil then
						WriteConErr("cardPicTable error ");
					end
					itemPic:SetPicture( GetPictureByAni(itemTable.item_pic, 0) );
					itemName:SetText(itemTable.name);
					
					itemNumPic:SetPicture( GetPictureByAni("common_ui.countNameBox", 0) );
					itemNamePic:SetPicture( GetPictureByAni("common_ui.countNameBox", 0) );
				end
			end
		end

		tiemTable:AddView( view );
		tiemTable:SetEnableMove(false);

end

function p.SetDelegate(layer)
	local btnReturn = GetButton( p.layer, ui.ID_CTRL_BTN_TETURN );
	btnReturn:SetLuaDelegate(p.OnBtnClick);
	
	local fightBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_FIGHT );
	fightBtn:SetLuaDelegate(p.OnBtnClick);
	--list:MoveToPrevView();
	--list:MoveToNextView();
end

--update by csd 2014-2-23
function p.FightClick()
	--local btn = GetButton( p.layer, ui.ID_CTRL_BUTTON_FIGHT );
	--if btn == nil then
	--	WriteConErr("not find fight button");
	--	return ;
	--end
	--p.OnBtnClick(btn, NUIEventType.TE_TOUCH_CLICK, nil);
	p.CloseUI();
	w_battle_mgr.EnterBattle( W_BATTLE_PVE, 100011, 1 );--进入战斗PVE
end

function p.OnBtnClick(uiNode,uiEventType,param)
	if IsClickEvent(uiEventType) then
		local tag = uiNode:GetTag();
		--返回
		if ( ui.ID_CTRL_BTN_TETURN == tag) then
			WriteCon("p.stageId == "..p.stageId);
			quest_main.ShowUI(p.stageId);
			p.CloseUI();
		--战斗
		elseif (ui.ID_CTRL_BUTTON_FIGHT == tag) then
			WriteCon("p.storyId == "..p.storyId);
			local nowTeamId = tonumber(p.teamTableView:GetActiveView() + 1);
			WriteCon("nowTeamId == "..nowTeamId);
			if tonumber(p.storyId) == 0 then
				--maininterface.m_bgImage:SetVisible(false);
				if E_DEMO_VER== 4 then
					 n_battle_mgr.EnterBattle( N_BATTLE_PVE, p.missionId, nowTeamId );--进入战斗PVE
				else
					w_battle_mgr.EnterBattle( W_BATTLE_PVE, p.missionId, nowTeamId );--进入战斗PVE
				end
				p.CloseUI();
			else
				dlg_drama.ShowUI( p.storyId,after_drama_data.FIGHT ,p.missionId,nowTeamId);
				p.storyId = nil;
				p.CloseUI();
			end

		--队伍编辑
		elseif (ui_team.ID_CTRL_BUTTON_BG == tag or ui_team.ID_CTRL_BUTTON_EDIT == tag) then
			local nowTeamId = uiNode:GetId();
			WriteCon("nowTeamId == "..nowTeamId);
			dlg_card_group_main.ShowUI(p.missionId,p.stageId,nowTeamId)
			p.CloseUI();
			--p.stageId = nil;
		--物品编辑
		elseif (ui_item.ID_CTRL_BUTTON_BG == tag or ui_item.ID_CTRL_BUTTON_ITEM_EDIT == tag) then
			WriteCon("item edit view");
			local nowTeamId = tonumber(p.teamTableView:GetActiveView() + 1);
			--local nowTeamId = uiNode:GetId();
			WriteCon("nowTeamId == "..nowTeamId);
			item_choose.ShowUI( p.itemListData,p.missionId,p.stageId,nowTeamId );
			p.CloseUI();
		end
	end
end

--隐藏UI
function p.HideUI()
	if p.layer ~= nil then
		p.layer:SetVisible(false);
	end
end

--关闭UI
function p.CloseUI()
	if p.layer ~= nil then
		p.layer:LazyClose();
		p.layer = nil;
		p.ClearData()
	end
end

function p.ClearData()
	p.stageId = nil;
	p.missionId = nil;
	p.nowTeamId = nil;
	p.teamListData = {};
	p.itemListData = {};
	p.teamTableView = nil;
	--p.storyId = nil;
end


function p.UIDisappear()
	p.CloseUI();
	--maininterface.BecomeFirstUI();
end
