country_main = {};
local p = country_main;
local ui = ui_country;

p.layer = nil;
local uiNodeT = {}

function p.ShowUI()
	if p.layer ~= nil then
		p.layer:SetVisible( true );
		return;
	end
	
	local layer = createNDUILayer();
	if layer == nil then
		return false;
	end
	
	layer:Init();
	layer:SetSwallowTouch(true);
	layer:SetFrameRectFull();
	
	GetUIRoot():AddChild(layer);

	LoadUI( "country.xui" , layer, nil );
	
	p.layer = layer;
	
	--设置代理
	p.SetDelegate();
	
	--初始化控件
	p.InitController();
	
end

function p.InitController()
	--名字
	uiNodeT.textNameT = {}
	uiNodeT.textNameT[1] = "生产屋LV:";
	uiNodeT.textNameT[2] = "装备屋LV:";
	uiNodeT.textNameT[3] = "融合屋LV:";
	uiNodeT.textNameT[4] = "住宅LV:";
	uiNodeT.textNameT[5] = "材料仓库LV:";
	uiNodeT.textNameT[6] = "河流LV:";
	uiNodeT.textNameT[7] = "农田LV:";
	uiNodeT.textNameT[8] = "矿山LV:";
	uiNodeT.textNameT[9] = "森林LV:";
	--名字，等级
	local produceName = GetLabel(p.layer, ui.ID_CTRL_TEXT_PRODUCE_LV);
	local equipName = GetLabel(p.layer, ui.ID_CTRL_TEXT_EQUIP_LV);
	local mergeName = GetLabel(p.layer, ui.ID_CTRL_TEXT_MERGE_LV);
	local homeName = GetLabel(p.layer, ui.ID_CTRL_TEXT_HOME_LV);
	local storeName = GetLabel(p.layer, ui.ID_CTRL_TEXT_STORE_LV);
	uiNodeT.headT = {}
	uiNodeT.headT[1] = produceName;
	uiNodeT.headT[2] = equipName;
	uiNodeT.headT[3] = mergeName;
	uiNodeT.headT[4] = homeName;
	uiNodeT.headT[5] = storeName;
	--名字框
	local headBoxBoxProduce = GetImage(p.layer, ui.ID_CTRL_PIC_PRODUCE_HEAD_BG);
	local headBoxBoxEquit = GetImage(p.layer, ui.ID_CTRL_PIC_EQUIP_HEAD_BG);
	local headBoxBoxMerge = GetImage(p.layer, ui.ID_CTRL_PIC_MERGE_HEAD_BG);
	local headBoxBoxHome = GetImage(p.layer, ui.ID_CTRL_PIC_HOME_HEAD_BG);
	local headBoxBoxStore = GetImage(p.layer, ui.ID_CTRL_PIC_STORE_HEAD_BG);
	uiNodeT.headBoxT = {}
	uiNodeT.headBoxT[1] = headBoxBoxProduce;
	uiNodeT.headBoxT[2] = headBoxBoxEquit;
	uiNodeT.headBoxT[3] = headBoxBoxMerge;
	uiNodeT.headBoxT[4] = headBoxBoxHome;
	uiNodeT.headBoxT[5] = headBoxBoxStore;
	--倒计时背景
	local timeBgProduce = GetImage(p.layer, ui.ID_CTRL_PIC_PRODUCE_ITEM_BG);
	local timeBgEquit = GetImage(p.layer, ui.ID_CTRL_PIC_EQUIP_ITEM_BG);
	local timeBgMerge = GetImage(p.layer, ui.ID_CTRL_PIC_MERGE_TIME_BG);
	local timeBgHome = GetImage(p.layer, ui.ID_CTRL_PIC_HOME_ITEM_BG);
	local timeBgStore = GetImage(p.layer, ui.ID_CTRL_PIC_STORE_ITEM_BG);
	uiNodeT.timeBgT = {}
	uiNodeT.timeBgT[1] = timeBgProduce;
	uiNodeT.timeBgT[2] = timeBgEquit;
	uiNodeT.timeBgT[3] = timeBgMerge;
	uiNodeT.timeBgT[4] = timeBgHome;
	uiNodeT.timeBgT[5] = timeBgStore;
	--倒计时文本
	local produceTime = GetLabel(p.layer, ui.ID_CTRL_TEXT_PRODUCE_ITEM);
	local equipTime = GetLabel(p.layer, ui.ID_CTRL_TEXT_EQUIP_TIME);
	local mergeTime = GetLabel(p.layer, ui.ID_CTRL_TEXT_MERGE_TIME);
	local homeTime = GetLabel(p.layer, ui.ID_CTRL_TEXT_HOME_TIME);
	local storeTime = GetLabel(p.layer, ui.ID_CTRL_TEXT_STORE_TIME);
	uiNodeT.timeTextT = {}
	uiNodeT.timeTextT[1] = produceTime;
	uiNodeT.timeTextT[2] = equipTime;
	uiNodeT.timeTextT[3] = mergeTime;
	uiNodeT.timeTextT[4] = homeTime;
	uiNodeT.timeTextT[5] = storeTime;
	--倒计时条
	local produceBar = GetExp( p.layer, ui.ID_CTRL_EXP_PRODUCE );
	local equipBar = GetExp( p.layer, ui.ID_CTRL_EXP_EQUIP );
	local mergeBar = GetExp( p.layer, ui.ID_CTRL_EXP_MERGE );
	local homeBar = GetExp( p.layer, ui.ID_CTRL_EXP_HOME );
	local storeBar = GetExp( p.layer, ui.ID_CTRL_EXP_STORE );
	uiNodeT.timeBar = {}
	uiNodeT.timeBar[1] = produceBar;
	uiNodeT.timeBar[2] = equipBar;
	uiNodeT.timeBar[3] = mergeBar;
	uiNodeT.timeBar[4] = homeBar;
	uiNodeT.timeBar[5] = storeBar;
	time_bar.ShowTimeBar(produceBar,0,30,20)
	--请求数据
	local uid = GetUID();
	local param = "";
	SendReq("Build","GetUserBuilds",uid,param);
end

function p.ShowCountry(backData)
	if backData.result == false then
		dlg_msgbox.ShowOK("错误提示","玩家数据错误。",nil,p.layer);
		return;
	end
	local buildInfo = backData.builds;
	if buildInfo == nil then
		dlg_msgbox.ShowOK("错误提示","无村庄数据",nil,p.layer);
		return
	end
	--是否有新开启的建筑
	local openViewT = backData.openani;
	local openViewNum = 0;	
	if openViewT ~= nil then
		for k,v in pairs(openViewT) do
			openViewNum = openViewNum + 1;
		end
	end
	if openViewNum > 0 then
		WriteCon("openViewNum == "..openViewNum);
		--p.showNewBuild(openViewT)
	else
		p.showCountryBuild(buildInfo)
	end
end

function p.showCountryBuild(buildInfo)
	WriteCon("showCountryBuild");

	--local buildNum = 0;
	-- for k,v in pairs(buildInfo) do 
		-- buildNum = buildNum + 1;
	-- end
	for i = 1, 9 do
		--显示名字，等级
		if buildInfo["B"..i] then
			local headText = uiNodeT.textNameT[i]..(buildInfo["B"..i].build_level);
			if uiNodeT.headT[i] then
				uiNodeT.headT[i]:SetText(headText);
			end
			--显示名字框
			uiNodeT.headBoxT[i]:SetPicture( GetPictureByAni("common_ui.countNameBox", 0));
			--是否在升级
			if tonumber(buildInfo["B"..i].is_upgrade) == 1 then
				uiNodeT.timeBgT[i]:SetPicture( GetPictureByAni("common_ui.levelBg", 0));
				local Countdown = buildInfo["B"..i].upgrade_time;
			end
		end
	end
end


--打开 开放建筑界面
function p.showNewBuild(openViewT)
	WriteCon("showNewBuild");
end

function p.SetDelegate()
	--建筑按钮
	local produceBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_PRODUCE );
	produceBtn:SetLuaDelegate(p.OnBtnClick);
	local equipBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_EQUIP );
	equipBtn:SetLuaDelegate(p.OnBtnClick);
	local mergeBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_MERGE );
	mergeBtn:SetLuaDelegate(p.OnBtnClick);
	local homeBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_HOME );
	homeBtn:SetLuaDelegate(p.OnBtnClick);
	local storeBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_STORE );
	storeBtn:SetLuaDelegate(p.OnBtnClick);
	local riverBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_RIVER );
	riverBtn:SetLuaDelegate(p.OnBtnClick);
	local fieldBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_FIELD );
	fieldBtn:SetLuaDelegate(p.OnBtnClick);
	local mountainBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_MOUNTAIN );
	mountainBtn:SetLuaDelegate(p.OnBtnClick);
	local treeBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_TREE );
	treeBtn:SetLuaDelegate(p.OnBtnClick);

	uiNodeT.buildBtnT = {}
	uiNodeT.buildBtnT[1] = produceBtn;
	uiNodeT.buildBtnT[2] = equipBtn;
	uiNodeT.buildBtnT[3] = mergeBtn;
	uiNodeT.buildBtnT[4] = homeBtn;
	uiNodeT.buildBtnT[5] = storeBtn;
	uiNodeT.buildBtnT[6] = riverBtn;
	uiNodeT.buildBtnT[7] = fieldBtn;
	uiNodeT.buildBtnT[8] = mountainBtn;
	uiNodeT.buildBtnT[9] = treeBtn;
	
	--返回
	local returnBtn = GetButton( p.layer, ui.ID_CTRL_BUTTON_RETURN );
	returnBtn:SetLuaDelegate(p.OnBtnClick);
end

function p.OnBtnClick(uiNode,uiEventType,param)
	if IsClickEvent(uiEventType) then
		local tag = uiNode:GetTag();
		if (ui.ID_CTRL_BUTTON_RETURN == tag) then
			WriteCon("return");
			p.CloseUI();
			maininterface.BecomeFirstUI();
			maininterface.CloseAllPanel();
		end
	end
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
	end
end
