--------------------------------------------------------------
-- FileName:    dlg_beast_main.lua
-- author:      crj,2013/11/12
-- purpose:     �ٻ���������
--------------------------------------------------------------

dlg_beast_main = {};
local p = dlg_beast_main;

p.layer = nil;

local ui = ui_beast_mainui;

--��ʾUI
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
    layer:Init();
    GetUIRoot():AddDlg( layer );
    LoadDlg ("beast_mainui.xui" , layer , nil );

	p.layer = layer;
    p.SetDelegate();
	
    --��������
    beast_mgr.LoadData( p.layer );
	
end

--����ί��
function p.SetDelegate()
	local btn = GetButton( p.layer, ui.ID_CTRL_BUTTON_BACK);
	btn:SetLuaDelegate( p.OnBtnClick );
end

--��ť����
function p.OnBtnClick( uiNode, uiEventType, param )
	local tag = uiNode:GetTag();
	if IsClickEvent( uiEventType ) then
		if ui.ID_CTRL_BUTTON_BACK == tag then
			--�˳�UI
			p.CloseUI();
			beast_mgr.ClearData();
		end
	end
end

function p.RefreshUI( source )
	local numLabel = GetLabel( p.layer, ui.ID_CTRL_TEXT_NUM );
	if numLabel then
		numLabel:SetText( string.format("%d/%d", table.getn(source.pet), source.pet_bag ) );
	end
	
	p.ShowBeastList( source.pet );
end

--��ʾ�ٻ����б�
function p.ShowBeastList( petList )
	local list = GetListBoxVert( p.layer ,ui_beast_mainui.ID_CTRL_VERTICAL_LIST_7);
    list:ClearView();
    
    if petList == nil or #petList <= 0 then
        WriteCon("ShowBeastList():petList is null");
        return ;
    end
	
	local lenth = #petList;
	
	for i = 1, lenth do
		local view = createNDUIXView();
        view:Init();
		
        LoadUI( "beast_main_list.xui", view, nil );
        local bg = GetUiNode( view, ui_beast_main_list.ID_CTRL_PICTURE_LISTBG );
        view:SetViewSize( bg:GetFrameSize());

		p.ShowBeastInfo( view, petList[i] );
		
		list:AddView( view );
	end
end

--���õ����ٻ�����ͼ
function p.ShowBeastInfo( view, pet )
	if view == nil or pet == nil then
		WriteCon("data error");
		return;
	end
	
	view:SetId( pet.pet_id );
	
	local levLabel = GetLabel( view, ui_beast_main_list.ID_CTRL_TEXT_12 );
	if levLabel then
		levLabel:SetText( string.format("Lv %d", pet.level) );
	end
	
	local hpLabel = GetLabel( view, ui_beast_main_list.ID_CTRL_TEXT_HP2 );
	if hpLabel then
		hpLabel:SetText( pet.hp );
	end
	
	local spLabel = GetLabel( view, ui_beast_main_list.ID_CTRL_TEXT_22 );
	if spLabel then
		spLabel:SetText( pet.sp );
	end
	
	local atkLabel = GetLabel( view, ui_beast_main_list.ID_CTRL_TEXT_ATTACK2 );
	if atkLabel then
		atkLabel:SetText( pet.atk );
	end
	
	--������ʾ������type��csv����
	local nameLevel = GetLabel( view, ui_beast_main_list.ID_CTRL_TEXT_14 );
	if nameLevel then
		--nameLevel:SetText( ... );
	end
	
	local attrLabel = GetLabel( view, ui_beast_main_list.ID_CTRL_TEXT_ELEMENT );
	if attrLabel then
		--attrLabel:SetText( ... );
	end
	
	--������ť
	local trainBtn = GetButton( view, ui_beast_main_list.ID_CTRL_BUTTON_INCUBATE );
	trainBtn.SetLuaDelegate( p.OnListBtnClick );
	
	--��ս��ť
	local fightBtn = GetButton( view, ui_beast_main_list.ID_CTRL_BUTTON_FIGHT );
	fightBtn:SetLuaDelegate( p.OnListBtnClick );
	fightBtn:SetChecked( beast_mgr.CheckIsFightPet( pet.pet_id ) );
end

--�ٻ����б����Ӱ�ť�ص�
function p.OnListBtnClick( uiNode, uiEventType, param )
	local node = uiNode:GetParent();
	local tag = uiNode:GetTag();
	if IsClickEvent( uiEventType ) then
		if ui_beast_main_list.ID_CTRL_BUTTON_INCUBATE == tag then
			WriteCon("**===============��ʾ����===============**");
			--��ʾ�������棬����ͨ��node:GetId()����ȡ��Ҫ��ʾ��һ���ٻ��޵���������
						
			
		elseif ui_beast_main_list.ID_CTRL_BUTTON_FIGHT == tag then
			WriteCon("**===============ѡ���ս===============**");
			
			beast_mgr.SetFight( node );
		end
	end
end

--ˢ�³�ս��ť
function p.SetFightBtnCheck( node, flag )
	if node == nil then
		return;
	end	
	
	--��ս��ť
	local fightBtn = GetButton( view, ui_beast_main_list.ID_CTRL_BUTTON_FIGHT );
	if fightBtn then
		fightBtn:SetChecked( flag );
	end
end

--����UI
function p.HideUI()
	if p.layer ~= nil then
		p.layer:SetVisible( false );
	end
end

--�ر�UI
function p.CloseUI()
	if p.layer ~= nil then
		p.layer:lazyClose();
		p.layer = nil;
	end
end
