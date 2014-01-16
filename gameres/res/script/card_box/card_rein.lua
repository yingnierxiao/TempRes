card_rein = {}
local p = card_rein;
p.layer = nil;
p.baseCardInfo = nil;

p.cardListInfo = nil;
p.selectNum = 0;
p.consumeMoney = 0;
p.selectCardId = {};
p.userMoney = 0;
p.addExp = 0;
p.nowExp = 0;

local ui = ui_card_rein;

function p.ShowUI(card_info)
	
	if p.layer ~= nil then 
		p.layer:SetVisible(true);
		if card_info~= nil then
			p.InitUI(card_info);
		end
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
    LoadDlg("card_rein.xui", layer, nil);

    p.layer = layer;
    p.SetDelegate(layer);	
	p.InitUI(card_info);
end

function p.SetCardData(card_info)
	if p.layer ~= nil then 
		p.ShowUI(card_info);
		return;
	end	
end;	

function p.GetRefreshCardUI()
	if p.baseCardInfo ~= nil then
		card_intensify2.OnSendCardDetail(tostring(p.baseCardInfo.UniqueID))
	end
end;

function p.getCardListInfo()
	return p.cardListInfo;
end;	

function p.setCardListInfo(cardListInfo)
	p.cardListInfo = cardListInfo;
end;	

function p.SetUserMoney(userMoney)
	p.userMoney	 = userMoney;
end;	


function p.copyTab(ori_tab)
    if (type(ori_tab) ~= "table") then  
        return nil  
    end  
	
    local new_tab = {}  
    for i,v in pairs(ori_tab) do  
        local vtyp = type(v)  
        if (vtyp == "table") then  
            new_tab[i] = p.copyTab(v)  
        elseif (vtyp == "thread") then  
            new_tab[i] = v  
        elseif (vtyp == "userdata") then  
            new_tab[i] = v  
        else  
            new_tab[i] = v  
        end  
    end  
    return new_tab 
end

function p.InitUI(card_info)
	
	if card_info ~= nil then
		if card_info.UniqueID ~= nil then
			card_info.UniqueId = tonumber(card_info.UniqueID); --属性缺少
		else
			card_info.UniqueID = tostring(card_info.UniqueId)
		end;
	end;
	p.baseCardInfo = p.copyTab(card_info);  --表的COPY
	p.InitAllCardInfo(); --初始化所有卡牌
	p.ShowCardCost();
	local dontimg = GetImage(p.layer, ui.ID_CTRL_PICTURE_186);
	local txtlab = GetLabel(p.layer, ui.ID_CTRL_TEXT_416);
	if card_info == nil then --挡板的设置
		
		dontimg:SetPicture(GetPictureByAni("ui.ui_bg",0));
	else
			
		dontimg:SetVisible(false);
		
		txtlab:SetText("");
		card_intensify2.CloseUI();	
		--头像 CTRL_PICTURE_231			CTRL_BUTTON_MAIN	 GetPictureByAni("w_battle.intensify_"..lcardId,0) 
		local lCardResRowInfo= SelectRowInner( T_CHAR_RES, "card_id", card_info.CardID); --从表中获取卡牌详细信息			
		local lHeadPic = GetImage(p.layer, ui.ID_CTRL_PICTURE_231);	
		lHeadPic:SetPicture(GetPictureByAni("w_battle.intensify_"..card_info.CardID,0));
			
		--名字 CTRL_TEXT_252
		local lCardRowInfo= SelectRowInner( T_CARD, "id", card_info.CardID); --从表中获取卡牌详细信息					
		local lTextName = GetLabel(p.layer, ui.ID_CTRL_TEXT_252);
		lTextName:SetText(tostring(lCardRowInfo.name));
		
		--当前经验值更新
		p.nowExp = tonumber(card_info.Exp);
		
		--等级 ID_CTRL_TEXT_LEVEL		
		local lTextLev = GetLabel(p.layer, ui.ID_CTRL_TEXT_LEVEL);
		local llevel = card_info.Level;
		lTextLev:SetText( tostring(card_info.Level) );

		--当前的经验值条 ID_CTRL_EXP_CARDEXP
		local lCardLeveInfo= SelectRowInner( T_CARD_LEVEL, "level", card_info.Level);
		local lCardExp = GetExp(p.layer, ui.ID_CTRL_EXP_CARDEXP);
		lCardExp:SetTotal(tonumber(lCardLeveInfo.exp));
		lCardExp:SetProcess(tonumber(card_info.Exp));
		lCardExp:SetNoText();
			
		--经验值 ID_CTRL_TEXT_EXP
		local lTextExp = GetLabel(p.layer, ui.ID_CTRL_TEXT_EXP);
		lTextExp:SetText(tostring(card_info.Exp).."/"..tostring(lCardLeveInfo.exp));

		--生命值 ID_CTRL_TEXT_HP
		local lTextHP = GetLabel(p.layer, ui.ID_CTRL_TEXT_HP);
		lTextHP:SetText(tostring(card_info.Hp));
		WriteCon("HP = "..card_info.Hp);
		--攻击值 ID_CTRL_TEXT_ATTACK
		local lTextAttack = GetLabel(p.layer, ui.ID_CTRL_TEXT_ATTACK);
		lTextAttack:SetText(tostring(card_info.Attack));		
		
		--防御值 ID_CTRL_TEXT_DEFENCE
		local lTextDeffnce = GetLabel(p.layer, ui.ID_CTRL_TEXT_DEFENCE);
		lTextDeffnce:SetText(tostring(card_info.Defence));		
		
		--队伍 ID_CTRL_PICTURE_TEAM
		local lPicTeam = GetImage(p.layer, ui.ID_CTRL_PICTURE_TEAM);
		if tonumber(card_info.Team_marks) == 1 then
			lPicTeam:SetVisible(true);				
			lPicTeam:SetPicture( GetPictureByAni("common_ui.teamName", 0) );
		elseif tonumber(card_info.Team_marks) == 2 then
			lPicTeam:SetVisible(true);				
			lPicTeam:SetPicture( GetPictureByAni("common_ui.teamName", 1) );
		elseif tonumber(card_info.Team_marks) == 3 then
			lPicTeam:SetVisible(true);				
			lPicTeam:SetPicture( GetPictureByAni("common_ui.teamName", 2) );
		else
			lPicTeam:SetVisible( false );
		end		
		
		--速度 ID_CTRL_TEXT_247
		local lTextSpeed = GetLabel(p.layer, ui.ID_CTRL_TEXT_247);
		lTextSpeed:SetText(tostring(card_info.Speed));		
		
	end
end	

function p.setSelCardList(cardIDList)
	p.ClearSelData();
	
	local lCount=0;
	for k,v in pairs(cardIDList) do
		local lUniqueId = v;
		local lNum = #(p.cardListInfo)
		for i=1,lNum do
		   local lcardInfo = p.cardListInfo[i];
		   if lUniqueId == lcardInfo.UniqueId then
				lCount = lCount + 1;
				p.SetCardInfo(lCount,lcardInfo);
				break;
		   end;
		end
	end
	
	p.ShowCardCost();
end;	

function p.ShowCardCost()
	
	local cardCount = GetLabel(p.layer,ui.ID_CTRL_TEXT_30);
	cardCount:SetText(tostring(p.addExp)); 
	
	local cardMoney = GetLabel(p.layer,ui.ID_CTRL_TEXT_32);
	cardMoney:SetText(tostring(p.consumeMoney)); 
	
	local moneyLab = GetLabel(p.layer,ui.ID_CTRL_TEXT_31);
	moneyLab:SetText(tostring(p.userMoney));	
	
	if tonumber(p.userMoney) < tonumber(p.consumeMoney) then
		--local moneyLab = GetLabel(p.layer,ui.ID_CTRL_TEXT_31);
		moneyLab:SetFontColor(ccc4(255,0,0,255));
    else	
		moneyLab:SetFontColor(ccc4(255,255,255,255));
	end		
end;	

function p.SetCardInfo(pIndex,pCardInfo)  --pIndex从1开始
	if pIndex > 10 then --正常不超过10
		return ;
	end
	local lLevelStr 	= "ID_CTRL_TEXT_CARDLEVEL"..pIndex;--等级
	local lCardPic 	= "ID_CTRL_BUTTON_CHA"..pIndex;--cardpic
	local lCardName 	= "ID_CTRL_TEXT_NAME"..pIndex;--cardpic
	
	WriteCon("SetCardInfoWS"..pIndex.."  LEVELE : "..pCardInfo.Level);
	local cardLevText = GetLabel(p.layer, ui[lLevelStr]);
	cardLevText:SetVisible(true);
	cardLevText:SetText("LV "..tostring(pCardInfo.Level));
			
	local cardButton = GetButton(p.layer, ui[lCardPic]);
	local lcardId = tonumber(pCardInfo.CardID);
	local lCardRowInfo= SelectRowInner( T_CHAR_RES, "card_id", lcardId); --从表中获取卡牌详细信息	
		
	--cardButton:SetImage( GetPictureByAni("n_battle.attack_"..lcardId,0) );
	cardButton:SetImage( GetPictureByAni("w_battle.intensify_"..lcardId,0) );
	local lCardInfo = SelectRowInner( T_CARD, "id", lcardId);
	
	local cardName = GetLabel(p.layer, ui[lCardName]);
	cardName:SetText(tostring(lCardInfo.name));
	
	p.selectNum = p.selectNum+1;
	p.selectCardId[#p.selectCardId + 1] = pCardInfo.UniqueId;
	
	local lCardLeveInfo;
	if pCardInfo.Level == 0 then
		lCardLeveInfo= SelectRowInner( T_CARD_LEVEL, "level", 1);
	else
		lCardLeveInfo= SelectRowInner( T_CARD_LEVEL, "level", pCardInfo.Level);
	end		
	p.consumeMoney = p.consumeMoney + lCardLeveInfo.feed_money + tonumber(pCardInfo.Level)*tonumber(pCardInfo.Level);	
			
	p.addExp = p.addExp + lCardInfo.feedBase_exp + lCardLeveInfo.feed_exp;
	
end;

function p.InitAllCardInfo()
		
	local i;
	for i=1,10 do
		
		local tLevel= "ID_CTRL_TEXT_CARDLEVEL"..tostring(i);--按钮
		local tName = "ID_CTRL_TEXT_NAME"..tostring(i);--装备图背景
		local lCardPic 	= "ID_CTRL_BUTTON_CHA"..tostring(i);--cardpic
		
		local cardLevText = GetLabel(p.layer, ui[tLevel]);
		cardLevText:SetVisible(false);

		local cardButton = GetButton(p.layer, ui[lCardPic]); 
		cardButton:SetImage(nil);
		
		local cardName = GetLabel(p.layer,ui[tName]);
		cardName:SetText("");
	end
	
end;	

function p.HideUI()
    if p.layer ~= nil then
        p.layer:SetVisible( false );
    end
end

function p.CloseUI()
    if p.layer ~= nil then
		card_intensify2.CloseUI();
	    p.layer:LazyClose();
        p.layer = nil;	
		p.baseCardInfo = nil;
		p.cardListInfo = nil;
		p.userMoney = 0;
		p.selectCardId = nil;
		p.consumeMoney = 0;
		p.selectNum = 0;
		p.nowExp = 0;
		p.addExp = 0;
    end
end

function p.SetDelegate(layer)
	local selBtn = GetButton(layer, ui.ID_CTRL_BUTTON_CHOOSE_BG); --设置按扭事件,注意和遮挡的按扭不一样
	selBtn:SetLuaDelegate(p.OnUIClickEvent);
	
	local selBtnBg = GetButton(layer, ui.ID_CTRL_BUTTON_CARD_CHOOSE);
	selBtnBg:SetLuaDelegate(p.OnUIClickEvent);

	local starBtn = GetButton(layer, ui.ID_CTRL_BUTTON_START);
	starBtn:SetLuaDelegate(p.OnUIClickEvent);

	local closeBtn = GetButton(layer, ui.ID_CTRL_BUTTON_RETURN);
	closeBtn:SetLuaDelegate(p.OnUIClickEvent);

	for i=1,10 do
		local lCardPic 	= "ID_CTRL_BUTTON_CHA"..tostring(i);--cardpic
		local lCardBtn = GetButton(layer, ui[lCardPic]);
		lCardBtn:SetLuaDelegate(p.OnButtonEvent);
	end
end
	
function p.OnButtonEvent(uiNode, uiEventType, param)
	WriteCon("OnUIClickEvent....");	
	if IsClickEvent(uiEventType) then
		if p.baseCardInfo ~= nil then
			local pCardRare= SelectRowInner( T_CARD_LEVEL_LIMIT, "star",p.baseCardInfo.Rare); --从表中获取卡牌详细信息	
			if tonumber( p.baseCardInfo.Level) >= tonumber(pCardRare.level_limit) then
				dlg_msgbox.ShowOK(GetStr("card_box_intensify"),tostring(p.baseCardInfo.Rare)..GetStr("card_intensify_no_level1")..tostring(pCardRare.level_limit)..GetStr("card_intensify_no_level2"),p.OnMsgCallback,p.layer);
			else
				card_intensify.ShowUI(p.baseCardInfo); 
				p.HideUI();
			end
			
		end
		
	end
end

function p.OnUIClickEvent(uiNode, uiEventType, param)
	WriteCon("OnUIClickEvent....");	
	local tag = uiNode:GetTag();
	WriteCon("tag = "..tag);
	WriteCon("ui.ID_CTRL_BUTTON_CHA1 : "..ui.ID_CTRL_BUTTON_CHA1);
	
	if IsClickEvent(uiEventType) then
		if(ui.ID_CTRL_BUTTON_RETURN == tag) then --返回
			p.CloseUI();
			dlg_menu.HideUI();
			dlg_card_attr_base.ShowUI();
		elseif(ui.ID_CTRL_BUTTON_CARD_CHOOSE == tag) or (ui.ID_CTRL_BUTTON_CHOOSE_BG == tag) then --选择卡牌
			card_intensify2.ShowUI(p.baseCardInfo);
		elseif(ui.ID_CTRL_BUTTON_START == tag) then --强化
			if tonumber(p.userMoney) < tonumber(p.consumeMoney) then
				dlg_msgbox.ShowOK(GetStr("card_caption"),GetStr("card_intensify_money"),p.OnMsgCallback,p.layer);
			else
				local param = "";
				for k,v in pairs(p.selectCardId) do
					if k == #p.selectCardId then
						param = param..tostring(v);
					else
						param = param..tostring(v)..",";
					end
				end
				if param ~= "" then
					p.OnSendReqIntensify(param);
				else
					dlg_msgbox.ShowOK(GetStr("card_caption"),GetStr("card_intensify_no_card"),p.OnMsgCallback,p.layer);
				end;
			end
			
			
		
		end;
	end
end		

function p.OnMsgCallback()
	
end

function p.OnSendReqIntensify(msg)
	local uid = GetUID();
	--uid = 10002;
	if uid ~= nil and uid > 0 then
		--模块  Action idm = 饲料卡牌unique_ID (1000125,10000123) 
		local param = string.format("&card_id=%d&idm="..msg, tonumber(p.baseCardInfo.UniqueId));
		SendReq("Card","Feedwould",uid,param);
		card_intensify_succeed.ShowUI(p.baseCardInfo);
		p.HideUI();
		p.ClearData();
	end
end

function p.ClearData()
	p.selectNum = 0;
	p.selectCardId = {};
	p.cardListInfo = nil;
	p.cardListByProf = {};
	p.InitAllCardInfo();
end

function p.ClearSelData()
	p.selectNum = 0;
	p.consumeMoney = 0;
	p.selectCardId = {};
	p.addExp = 0;
	p.InitAllCardInfo();
end

