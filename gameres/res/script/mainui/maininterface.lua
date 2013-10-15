
maininterface = {}
local p = maininterface;

p.layer = nil;
p.adList = {}

local ui = ui_main_interface

function p.ShowUI()
	if p.layer ~= nil then
		p.layer:SetVisible( true );
		dlg_userinfo2.ShowUI();
		local achievementList = GetListBoxVert( p.layer, ui.ID_CTRL_VERTICAL_LIST_8);
		achievementList:SetVisible(true);
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
	LoadUI("main_interface.xui", layer, nil);
    
	p.layer = layer;
	p.SetDelegate(layer);
	
	dlg_userinfo2.ShowUI();
	p.ShowAchievementList();
end

--设置广告内容
function p.ShowAchievementList()
	local achievementList = GetListBoxVert( p.layer, ui.ID_CTRL_VERTICAL_LIST_8);	
	for i=1, 4 do
		local view = createNDUIXView();
		view:Init();
		LoadUI("main_actANDad.xui", view, nil);
		local bg = GetUiNode(view, ui_main_actandad.ID_CTRL_CTRL_BUTTON_24);
		view:SetViewSize( CCSizeMake(bg:GetFrameSize().w, bg:GetFrameSize().h+5.0));
		
		--礼包
		local btn = GetButton(view, ui_main_actandad.ID_CTRL_CTRL_BUTTON_24);
		btn:SetLuaDelegate(p.OnClickAD);

		achievementList:AddView( view );
	end
end

--设置按钮
function p.SetBtn(btn)
	btn:SetLuaDelegate(p.OnBtnClick);
	--btn:AddActionEffect( "ui_cmb.mainui_btn_scale" );
end

function p.SetDelegate(layer)
	--礼包
	local gift = GetButton(layer, ui.ID_CTRL_MAIN_BUTTON_GIFT);
	p.SetBtn(gift);
	
	--进入世界地
	local enterMap = GetButton(layer, ui.ID_CTRL_TEMP_BUTTON_MAP);
	p.SetBtn(enterMap);
	
	local bgBtn = GetButton(layer, ui.ID_CTRL_MIAN_BUTTON_DOWN);
	p.SetBtn(bgBtn);
end

function p.OnBtnClick(uiNode, uiEventType, param)
	if IsClickEvent( uiEventType ) then
	    local tag = uiNode:GetTag();
		if ui.ID_CTRL_MAIN_BUTTON_GIFT == tag then
			WriteCon("**礼包**");

			p.CloseAllPanel();
		elseif ui.ID_CTRL_TEMP_BUTTON_MAP == tag then
			p.HideUI();	
			p.CloseAllPanel();

			game_main.EnterWorldMap();
		elseif ui.ID_CTRL_MIAN_BUTTON_DOWN == tag then
			p.CloseAllPanel();
			dlg_menu.CloseUI();
		end
	end
end

--关闭子面板
function p.CloseAllPanel()
	dlg_userinfo.CloseUI();
	--dlg_menu.CloseUI();
end

--隐藏UI
function p.HideUI()
	if p.layer ~= nil then
		p.layer:SetVisible( false );
		local achievementList = GetListBoxVert( p.layer, ui.ID_CTRL_VERTICAL_LIST_8);
		achievementList:SetVisible( false );
	end
end

--关闭UI
function p.CloseUI()
	if p.layer ~= nil then
	    p.layer:LazyClose();
        p.layer = nil;
		--p.adList = nil;
    end
end

--重新显示菜单按钮
function p.ShowMenuBtn()
	local menu = GetButton(p.layer, ui.ID_CTRL_MAIN_BUTTON_MEMU);
	if menu then
		menu:SetVisible(true);
	end
end

function p.OnClickAD()
	WriteCon("**=======AD=======**");
end
