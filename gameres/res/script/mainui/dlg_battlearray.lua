
dlg_battlearray = {};
local p = dlg_battlearray;

local ui = ui_main_battlearray_bg;
p.layer = nil;

function p.ShowUI()
	if p.layer ~= nil then
		p.layer:SetVisible( true );
		return;
	end
	
	local layer = createNDUIDialog();
	if layer == nil then
		return false;
	end
	
	layer:NoMask();
	layer:Init(layer);
	layer:SetSwallowTouch(false);
    
	GetUIRoot():AddChild(layer);
	LoadUI("main_battlearray_bg.xui", layer, nil);
    
	p.layer = layer;
	--p.SetDelegate();
end

function p.CloseUI()    
    if p.layer ~= nil then
        p.layer:LazyClose();
        p.layer = nil;
    end
end

function p.HideUI()
	if p.layer ~= nil then
        p.layer:SetVisible(false);
	end
end

function p.RefreshUI(user_team)
	if user_team == nil then
		return;
	end
	
	local list = GetListBoxHorz( p.layer, ui.ID_CTRL_LIST_13 );
	if list == nil then
		return;
	end
	list:ClearView();
	
	local view = createNDUIXView();
	view:Init();
	LoadUI( "main_battlearray.xui", view, nil );
	
	local bg = GetUiNode( view, ui_main_battlearray.ID_CTRL_PICTURE_BG );
    view:SetViewSize( bg:GetFrameSize());
	
	for i = 1, 6 do
		local id = user_team["Pos_card"..i]
		if id ~= nil and tonumber(id) ~= 0 then
			local btn = GetButton( view, ui_main_battlearray["ID_CTRL_BUTTON_ROLE_"..i] );
			if btn ~= nil then
				btn:SetImage( GetPictureByAni( SelectRowInner( T_CHAR_RES, "card_id", tostring(id), "head_pic" ), 0 ) );
				btn:SetTouchDownImage( GetPictureByAni( SelectRowInner( T_CHAR_RES, "card_id", tostring(id), "head_pic" ), 0 ) );
				btn:SetDisabledImage( GetPictureByAni( SelectRowInner( T_CHAR_RES, "card_id", tostring(id), "head_pic" ), 0 ) );
			end
		end
	end
	
	for i = 1, 2 do
		local id = user_team["Pet_card"..i];
		if id ~= nil and tonumber(id) ~= 0 then
			local btn = GetButton( view, ui_main_battlearray["ID_CTRL_BUTTON_ROLE_"..(i+6)] );
			if btn ~= nil then
				btn:SetImage( GetPictureByAni( SelectCell( T_PET_RES, tostring( id ), "face_pic" ), 0 ) );
				btn:SetTouchDownImage( GetPictureByAni( SelectCell( T_PET_RES, tostring( id ), "face_pic" ), 0 ) );
				btn:SetDisabledImage( GetPictureByAni( SelectCell( T_PET_RES, tostring( id ), "face_pic" ), 0 ) );
			end
		end
	end
	
	list:AddView( view );
end

