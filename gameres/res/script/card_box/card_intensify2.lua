CARD_BAG_SORT_BY_LEVEL	= 1001;
CARD_BAG_SORT_BY_STAR	= 1002;
CARD_BAG_SORT_BY_TIME = 1003;

PROFESSION_TYPE_1 = 2001;
PROFESSION_TYPE_2 = 2002;
PROFESSION_TYPE_3 = 2003;
PROFESSION_TYPE_4 = 2004;
PROFESSION_TYPE_5 = 2005;
MARK_ON = 100;
MARK_OFF = nil;

card_intensify2  = {}
local p = card_intensify2;

local ui = ui_card_intensify2;
local ui_list = ui_card_list_intensify_view;

p.layer = nil;
p.cardListInfo = nil;
p.curBtnNode = nil;
p.sortByRuleV = nil;
p.baseCardInfo = nil;

--p.selectList = {};
--p.teamList = {};
--p.selectNum = 0;
--p.consumeMoney = 0;
--p.selectCardId = {};
--p.userMoney = 0;
p.cardListByProf = {};
function p.ShowUI(baseCardInfo)
	p.baseCardInfo = baseCardInfo;
	p.cardListInfo = card_rein.getCardListInfo();
	--p.baseCardInfo = baseCardInfo;
	--WriteCon(baseCardInfo.UniqueID.."********************");
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
	
    GetUIRoot():AddDlg(layer);
    LoadDlg("card_intensify2.xui", layer, nil);

    p.layer = layer;
    p.SetDelegate(layer);
	
	--���ؿ����б�����  ������
    p.OnSendReq();
	--p.ShowCardList( cardList )
end

--��ǿ������List����
function p.OnSendReq()
	
	local uid = GetUID();
	--uid = 1234;
	if uid ~= nil and uid > 0 then
		--ģ��  Action  --msg_card_bag
		SendReq("CardList","List",uid,"");
	end
	
end
--[[
--ǿ����������
function p.OnSendReqIntensify(msg)
	local uid = GetUID();
	--uid = 10002;
	if uid ~= nil and uid > 0 then
		--ģ��  Action idm = ���Ͽ���unique_ID (1000125,10000123) 
		local param = string.format("&card_id=%d&idm="..msg, tonumber(p.baseCardInfo.UniqueId));
		SendReq("Card","Feedwould",uid,param);
		card_intensify_succeed.ShowUI(p.baseCardInfo);
		p.ClearData();
	end
end
]]--
--�������¼�����
function p.SetDelegate(layer)
	local retBtn = GetButton(layer, ui.ID_CTRL_BUTTON_RETURN);
	retBtn:SetLuaDelegate(p.OnUIClickEvent);

	local cardBtnAll = GetButton(layer, ui.ID_CTRL_BUTTON_ALL);
	cardBtnAll:SetLuaDelegate(p.OnUIClickEvent);
	p.SetBtnCheckedFX( cardBtnAll );

	local cardBtnPro1 = GetButton(layer, ui.ID_CTRL_BUTTON_PRO1);
	cardBtnPro1:SetLuaDelegate(p.OnUIClickEvent);

	local cardBtnPro2 = GetButton(layer, ui.ID_CTRL_BUTTON_PRO2);
	cardBtnPro2:SetLuaDelegate(p.OnUIClickEvent);
	
	local cardBtnPro3 = GetButton(layer, ui.ID_CTRL_BUTTON_PRO3);
	cardBtnPro3:SetLuaDelegate(p.OnUIClickEvent);
	
	local cardBtnPro4 = GetButton(layer, ui.ID_CTRL_BUTTON_PRO4);
	cardBtnPro4:SetLuaDelegate(p.OnUIClickEvent);
	
	local cardBtnPro5 = GetButton(layer, ui.ID_CTRL_BUTTON_PRO5);
	cardBtnPro5:SetLuaDelegate(p.OnUIClickEvent);
	
	local sortByBtn = GetButton(layer, ui.ID_CTRL_BUTTON_SORT_BY);
	sortByBtn:SetLuaDelegate(p.OnUIClickEvent);
	
	--local intensifyByBtn = GetButton(layer, ui.ID_CTRL_BUTTON_26);
	--intensifyByBtn:SetLuaDelegate(p.OnUIClickEvent);
	
end

--�¼�����
function p.OnUIClickEvent(uiNode, uiEventType, param)
	WriteCon("OnUIClickEvent....");
	local tag = uiNode:GetTag();
	if IsClickEvent(uiEventType) then
		if(ui.ID_CTRL_BUTTON_RETURN == tag) then --����
			p.CloseUI();
		elseif(ui.ID_CTRL_BUTTON_ALL == tag) then --ȫ��
			p.SetBtnCheckedFX( uiNode );
			p.ShowCardView(p.cardListInfo);
			p.cardListByProf = p.cardListInfo;
		elseif(ui.ID_CTRL_BUTTON_PRO1 == tag) then --ְҵ1
			p.SetBtnCheckedFX( uiNode );
			p.ShowCardByProfession(PROFESSION_TYPE_1);
		elseif(ui.ID_CTRL_BUTTON_PRO2 == tag) then --ְҵ2
			p.SetBtnCheckedFX( uiNode );
			p.ShowCardByProfession(PROFESSION_TYPE_2);
		elseif(ui.ID_CTRL_BUTTON_PRO3 == tag) then --ְҵ3
			p.SetBtnCheckedFX( uiNode );
			p.ShowCardByProfession(PROFESSION_TYPE_3);
		elseif(ui.ID_CTRL_BUTTON_PRO4 == tag) then --ְҵ4
			p.SetBtnCheckedFX( uiNode );
			p.ShowCardByProfession(PROFESSION_TYPE_4);
		elseif(ui.ID_CTRL_BUTTON_PRO5 == tag) then --ְҵ5
			p.SetBtnCheckedFX( uiNode );
			p.ShowCardByProfession(PROFESSION_TYPE_5);
		elseif(ui.ID_CTRL_BUTTON_SORT_BY == tag) then --���ȼ�����
				card_bag_sort.ShowUI(1);
		end
	end
end

--[[
--ȷ��ǿ��ΪTRUE
function p.OnMsgBoxCallback(result)
	if result == true then
		WriteCon("true");
		
	end
end
]]--
--����������ť
function p.sortByBtnEvent(sortType)
	WriteCon("sortType = "..sortType);
	if sortType == nil then
		return
	end
	local sortByBtn = GetButton(p.layer, ui.ID_CTRL_BUTTON_SORT_BY);
	sortByBtn:SetLuaDelegate(p.OnUIClickEvent);
	if(sortType == CARD_BAG_SORT_BY_LEVEL) then
		sortByBtn:SetImage( GetPictureByAni("button.card_bag",0));
		p.sortByRuleV = CARD_BAG_SORT_BY_LEVEL;
	elseif(sortType == CARD_BAG_SORT_BY_STAR) then
		sortByBtn:SetImage( GetPictureByAni("button.card_bag",1));
		p.sortByRuleV = CARD_BAG_SORT_BY_STAR;
	elseif(sortType == CARD_BAG_SORT_BY_TIME) then 
		sortByBtn:SetImage( GetPictureByAni("button.card_bag",2));
		p.sortByRuleV = CARD_BAG_SORT_BY_TIME;
	end
	p.sortByRule(sortType)

end 


--����������ʾ Lab��
function p.ShowCardList(cardList,msg)

	card_rein.SetUserMoney(msg.money);
	p.cardListInfo = cardList;
	card_rein.setCardListInfo(cardList);	
	
	if p.layer == nil then
		return;
	end
	if #cardList <= 0 then
		return;
	end
	

	--local cardCount = GetLabel(p.layer,ui.ID_CTRL_TEXT_30);
	--cardCount:SetText(tostring(p.selectNum).."/10"); 	
	
	--local cardMoney = GetLabel(p.layer,ui.ID_CTRL_TEXT_32);
	--cardMoney:SetText("0"); 
	
	
	local countLab = GetLabel(p.layer,ui.ID_CTRL_TEXT_25);
	
	--���н��
	--local moneyLab = GetLabel(p.layer,ui.ID_CTRL_TEXT_31);
	
	
	countLab:SetText(tostring(msg.cardlist_num).."/"..tostring(msg.cardmax));
	--moneyLab:SetText(tostring(msg.money));
	--p.userMoney = msg.money;

	--[[
	--�б�ɾ��Ҫǿ���������������� 
	for i = 1 , #p.cardListInfo do
		if p.cardListInfo[i].UniqueId == p.baseCardInfo.UniqueId then
			table.remove(p.cardListInfo,i);
			break;
		end
	end	
]]--
	p.cardListByProf = p.cardListInfo;
	p.ShowCardView(p.cardListInfo);
	
	
end
--��ʾ�����б�
function p.ShowCardView(cardList)
	local list = GetListBoxVert(p.layer ,ui.ID_CTRL_VERTICAL_LIST_VIEW);
	list:ClearView();
	
	if cardList == nil or #cardList <= 0 then
		WriteCon("ShowCardView():cardList is null");
		return;
	end
	local cardNum = #cardList;
	
	local row = math.ceil(cardNum / 5);
	
	for i = 1, row do
		local view = createNDUIXView();
		view:Init();
		LoadUI("card_list_intensify_view.xui",view,nil);
		
		p.InitViewUI(view); --��������������
		
		local bg = GetUiNode( view, ui_list.ID_CTRL_PICTURE_13);
        view:SetViewSize( bg:GetFrameSize());
		
		local row_index = i;
		local start_index = (row_index-1)*5+1
        local end_index = start_index + 4;

		
		--�����б���Ϣ��һ��5�ſ���
		for j = start_index,end_index do
			if j <= cardNum then
				local card = cardList[j];
				
				local cardIndex = j - start_index + 1;
				p.ShowCardInfo( view, card, cardIndex );
				
			end
		end
		list:AddView( view );
	end
	--p.selectList ID��key   p.selectCardId
	--[[
	for k,v in pairs(p.selectCardId) do
		p.selectList[v]:SetVisible(true);
	end
	]]--
end

function p.InitViewUI(view)
   for cardIndex=1,5 do
		if cardIndex == 1 then
			--cardBtn = ui_list.ID_CTRL_BUTTON_ITEM1;
			cardSelect = ui_list.ID_CTRL_PICTURE_S1;
			cardTeam = ui_list.ID_CTRL_PICTURE_TEAM1;
			cardLevel = ui_list.ID_CTRL_LEVEL_1;
			cardLevelBg = ui_list.ID_CTRL_PICTURE_38;
		elseif cardIndex == 2 then
			--cardBtn = ui_list.ID_CTRL_BUTTON_ITEM2;
			cardSelect = ui_list.ID_CTRL_PICTURE_S2;
			cardTeam = ui_list.ID_CTRL_PICTURE_TEAM2;
			cardLevel = ui_list.ID_CTRL_LEVEL_2;
			cardLevelBg = ui_list.ID_CTRL_PICTURE_39;
		elseif cardIndex == 3 then
			--cardBtn = ui_list.ID_CTRL_BUTTON_ITEM3;
			cardSelect = ui_list.ID_CTRL_PICTURE_S3;
			cardTeam = ui_list.ID_CTRL_PICTURE_TEAM3;
			cardLevel = ui_list.ID_CTRL_LEVEL_3;
			cardLevelBg = ui_list.ID_CTRL_PICTURE_40;
		elseif cardIndex == 4 then
			--cardBtn = ui_list.ID_CTRL_BUTTON_ITEM4;
			cardSelect = ui_list.ID_CTRL_PICTURE_S4;
			cardTeam = ui_list.ID_CTRL_PICTURE_TEAM4;
			cardLevel = ui_list.ID_CTRL_LEVEL_4;
			cardLevelBg = ui_list.ID_CTRL_PICTURE_41;
		elseif cardIndex == 5 then
			--cardBtn = ui_list.ID_CTRL_BUTTON_ITEM5;
			cardSelect = ui_list.ID_CTRL_PICTURE_S5;
			cardTeam = ui_list.ID_CTRL_PICTURE_TEAM5;
			cardLevel = ui_list.ID_CTRL_LEVEL_5;
			cardLevelBg = ui_list.ID_CTRL_PICTURE_47;
		end
		
		local teamPic = GetImage(view,cardTeam);
		teamPic:SetVisible(false);
		
		local cardSelectText = GetImage(view,cardSelect );
		cardSelectText:SetVisible( false );
			
		local levelText = GetLabel(view,cardLevel);
		levelText:SetVisible( false );
		
		local levelTextBg = GetImage(view,cardLevelBg );
		levelTextBg:SetVisible( false );
  end
end;	

--��ʾ���ſ���
function p.ShowCardInfo( view, card, cardIndex )
	--WriteCon("************"..cardIndex);
	local cardBtn = nil;
	local cardLevel = nil;
	local cardTeam = nil;
	local cardSelect = nil;
	if cardIndex == 1 then
		cardBtn = ui_list.ID_CTRL_BUTTON_ITEM1;
		cardSelect = ui_list.ID_CTRL_PICTURE_S1;
		cardTeam = ui_list.ID_CTRL_PICTURE_TEAM1;
		cardLevel = ui_list.ID_CTRL_LEVEL_1;
	elseif cardIndex == 2 then
		cardBtn = ui_list.ID_CTRL_BUTTON_ITEM2;
		cardSelect = ui_list.ID_CTRL_PICTURE_S2;
		cardTeam = ui_list.ID_CTRL_PICTURE_TEAM2;
		cardLevel = ui_list.ID_CTRL_LEVEL_2;
	elseif cardIndex == 3 then
		cardBtn = ui_list.ID_CTRL_BUTTON_ITEM3;
		cardSelect = ui_list.ID_CTRL_PICTURE_S3;
		cardTeam = ui_list.ID_CTRL_PICTURE_TEAM3;
		cardLevel = ui_list.ID_CTRL_LEVEL_3;
	elseif cardIndex == 4 then
		cardBtn = ui_list.ID_CTRL_BUTTON_ITEM4;
		cardSelect = ui_list.ID_CTRL_PICTURE_S4;
		cardTeam = ui_list.ID_CTRL_PICTURE_TEAM4;
		cardLevel = ui_list.ID_CTRL_LEVEL_4;
	elseif cardIndex == 5 then
		cardBtn = ui_list.ID_CTRL_BUTTON_ITEM5;
		cardSelect = ui_list.ID_CTRL_PICTURE_S5;
		cardTeam = ui_list.ID_CTRL_PICTURE_TEAM5;
		cardLevel = ui_list.ID_CTRL_LEVEL_5;
	end
	--��ʾ����ͼƬ
	local cardButton = GetButton(view, cardBtn);
	local cardId = tonumber(card.CardID);
	
	local pCardInfo= SelectRowInner( T_CHAR_RES, "card_id", cardId); --�ӱ��л�ȡ������ϸ��Ϣ	
	cardButton:SetImage( GetPictureByAni(pCardInfo.card_pic, 0) );
	--cardButton:SetImage( GetPictureByAni("card.card_101",0) );
	local cardUniqueId = tonumber(card.UniqueId);
    cardButton:SetId(cardUniqueId);

	--ui.public.team1.png  ����
	local teamText = GetImage(view,cardTeam);
	teamText:SetVisible( true );
	
	if card.Team_marks == 1 then
		teamText:SetPicture( GetPictureByAni("common_ui.teamName", 0) );
	elseif card.Team_marks == 2 then
		teamText:SetPicture( GetPictureByAni("common_ui.teamName", 1) );
	elseif card.Team_marks == 3 then
		teamText:SetPicture( GetPictureByAni("common_ui.teamName", 2) );
	else
		teamText:SetVisible( false );
	end
	--���Ƶȼ�
	local levelText = GetLabel(view,cardLevel);
	levelText:SetText("LV"..tostring(card.Level));
	
	--�Ƿ�ѡ��ͼƬ
	if p.baseCardInfo ~= nil then
		if tonumber(card.UniqueId) == tonumber(p.baseCardInfo.UniqueID) then
			local cardSelectText = GetImage(view,cardSelect );
			cardSelectText:SetVisible( true );
		end;
	end;
	--local Team_marks = card.Team_marks;
	--p.teamList[cardUniqueId] = Team_marks;
	
	--p.selectList[cardUniqueId] = cardSelectText;
	
	
	
	
	--���ÿ��ư�ť�¼�
	cardButton:SetLuaDelegate(p.OnCardClickEvent);
	cardButton:RemoveAllChildren(true);
end

--�������
function p.OnCardClickEvent(uiNode, uiEventType, param)
	local cardUniqueId = uiNode:GetId();
	p.OnSendCardDetail(cardUniqueId);	
end

function p.OnSendCardDetail(cardUniqueId)
	local uid = GetUID();
	
	if uid == 0 or uid == nil or cardUniqueId == nil then
		return ;
	end;
	
	local param = string.format("&card_unique_id=%s",cardUniqueId)
	SendReq("Equip","CardDetailShow",uid,param);		
	card_rein.ClearSelData();	
end;	

function p.GetCardInfo(cardUniqueId)
	for k,v in pairs(p.cardListInfo) do
		if v.UniqueId == cardUniqueId then
			if v.Level == 0 then
				pCardLeveInfo= SelectRowInner( T_CARD_LEVEL, "level", 1);
			else
				pCardLeveInfo= SelectRowInner( T_CARD_LEVEL, "level", v.Level);
			end
			break;
		end
	end	
end;	

--��ʾ��ص�����
function p.OnMsgCallback(result)
	
	WriteCon("OnMsgCallback");
	
end


--����ѡ�а�ť
function p.SetBtnCheckedFX( node )
    local btnNode = ConverToButton( node );
    if p.curBtnNode ~= nil then
    	p.curBtnNode:SetChecked( false );
    end
	btnNode:SetChecked( true );
	p.curBtnNode = btnNode;
	card_bag_sort.CloseUI();
end


function p.HideUI()
    if p.layer ~= nil then
        p.layer:SetVisible( false );
    end
end

--��ְҵ��ʾ����
function p.ShowCardByProfession(profType)
	WriteCon("card_intensify.ShowCardByProfession();");
	if profType == nil then
		WriteCon("ShowCardByProfession():profession Type is null");
		return;
	end 
	p.cardListByProf = p.GetCardList(profType);
		
	if p.cardListByProf == nil or #p.cardListByProf <= 0 then
		WriteCon("p.cardListByProf == nil or #p.cardListByProf <= 0");
	end
	if p.sortByRuleV ~= nil then
		p.sortByRule(p.sortByRuleV)
	else
		p.ShowCardView(p.cardListByProf);
	end
	
end

--��ȡ��ʾ�б�
function p.GetCardList(profType)
	local t = {};
	if p.cardListInfo == nil then 
		return t;
	end
	if profType == PROFESSION_TYPE_0 then
		t = p.cardListInfo;
	elseif profType == PROFESSION_TYPE_1 then 
		for k,v in pairs(p.cardListInfo) do
			if tonumber(v.Class) == 1 then
				t[#t + 1] = v;
			end
		end
	elseif profType == PROFESSION_TYPE_2 then 
		for k,v in pairs(p.cardListInfo) do
			if tonumber(v.Class) == 2 then
				t[#t + 1] = v;
			end
		end
	elseif profType == PROFESSION_TYPE_3 then 
		for k,v in pairs(p.cardListInfo) do
			if tonumber(v.Class) == 3 then
				t[#t + 1] = v;
			end
		end
	elseif profType == PROFESSION_TYPE_4 then 
		for k,v in pairs(p.cardListInfo) do
			if tonumber(v.Class) == 4 then
				t[#t + 1] = v;
			end
		end
	elseif profType == PROFESSION_TYPE_5 then 
		for k,v in pairs(p.cardListInfo) do
			if tonumber(v.Class) == 5 then
				t[#t + 1] = v;
			end
		end
	end
	return t;
end

--����������
function p.sortByRule(sortType)
	if sortType == nil or p.cardListByProf == nil then 
		return
	end
	if sortType == CARD_BAG_SORT_BY_LEVEL then
		WriteCon("========sort by level");
		table.sort(p.cardListByProf,p.sortByLevel);
	elseif sortType == CARD_BAG_SORT_BY_STAR then
		WriteCon("========sort by star");
		table.sort(p.cardListByProf,p.sortByStar);
	elseif sortType == CARD_BAG_SORT_BY_TIME then
		WriteCon("========sort by time");
		table.sort(p.cardListByProf,p.sortByTime);
	end
	p.ShowCardView(p.cardListByProf);
end

--���ȼ�����
function p.sortByLevel(a,b)
	return tonumber(a.Level) < tonumber(b.Level);
end
--���Ǽ�����
function p.sortByStar(a,b)
	return tonumber(a.Rare) < tonumber(b.Rare);
end
--��ʱ������
function p.sortByTime(a,b)
	return tonumber(a.Time) < tonumber(b.Time);
end

function p.HideUI()
    if p.layer ~= nil then
        p.layer:SetVisible( false );
    end
end

function p.CloseUI()
    if p.layer ~= nil then
        p.layer:LazyClose();
        p.layer = nil;
		p.cardListInfo = nil;
		p.curBtnNode = nil;
		p.sortBtnMark = MARK_OFF;
		p.sortByRuleV = nil;
		p.BatchSellMark = MARK_OFF;
		--p.selectList = {};
		--p.teamList = {};
		--p.selectCardId = {};
		--p.baseCardInfo = nil;
		--p.consumeMoney = 0;
		--p.selectNum = 0;
		p.baseCardInfo = nil;
        --card_bag_mgr.ClearData();
		p.cardListByProf = {};
		--p.userMoney = 0;
		
    end
end

function p.ClearData()
	--p.selectNum = 0;
	--p.selectCardId = {};
	p.cardListInfo = nil;
	p.cardListByProf = {};
end