
rookie_mask = {};
local p = rookie_mask;

p.background = nil;
p.layer = nil;
p.maskLayer = nil;
p.faceImage = nil;
p.colorLabel = nil;
p.step = 0;
p.substep = 0;
p.contentStr = "";
p.contentStrLn = 0;
p.contentIndex = 1;
p.timerId = nil;
p.textList = nil;

p.onCallFlag = false;

local uiList = {
	[3]={
		[2]= ui_learning_3_2,
		[3]= ui_learning_3_3,
		[4]= ui_learning_3_4,
		[5]= ui_learning_3_5,
		[6]= ui_learning_3_6,
		[7]= ui_learning_3_7,
		[8]= ui_learning_3_8,
		[9]= ui_learning_3_9,
		[10]= ui_learning_3_10,
		[11]= ui_learning_3_11,
		[12]= ui_learning_3_12,
		[13]= ui_learning_3_13,
		[14]= ui_learning_3_14,
	},
	[4] ={
		[2] = ui_learning_4_2,
		[3] = ui_learning_4_3,
		[4] = ui_learning_4_4,
		[5] = ui_learning_4_5,
		[6] = ui_learning_4_6,
		},
	[5]={
		[2]= ui_learning_5_2,
		[3]= ui_learning_5_3,
		[4]= ui_learning_5_4,
		[5]= ui_learning_5_5,
		[6]= ui_learning_5_6,
		[8]= ui_learning_5_8,
		[9]= ui_learning_5_9,
		[10]= ui_learning_5_10,
		[11]= ui_learning_5_11,
		[12]= ui_learning_5_12,
		[13]= ui_learning_5_13,
		[14]= ui_learning_5_14,
		[15]= ui_learning_5_15,
		[16]= ui_learning_5_16,
		[17]= ui_learning_5_17,
		[18]= ui_learning_5_18,
		[19]= ui_learning_5_19,
		[20]= ui_learning_5_20,
		[21]= ui_learning_5_21,
		[22]= ui_learning_5_22,
		[23]= ui_learning_5_23,
	},	
	[6] ={
		[2] = ui_learning_6_2,
		[3] = ui_learning_6_3,
		[4] = ui_learning_6_4,
		[5] = ui_learning_6_5,
		[6] = ui_learning_6_6,
		[7] = ui_learning_6_7,
		[8] = ui_learning_6_8,
		[9] = ui_learning_6_9,
		[10] = ui_learning_6_10,
		[11] = ui_learning_6_11,
		[12] = ui_learning_6_12,
		[13] = ui_learning_6_13,
		},
	[7] ={
		[2] = ui_learning_7_2,
		[3] = ui_learning_7_3,
		[4] = ui_learning_7_4,
		[5] = ui_learning_7_5,
		},
	[8] = {
		[2] = ui_learning_8_2,
	},
	[9] = {
		[2] = ui_learning_9_2,
		[3] = ui_learning_9_3,
		[4] = ui_learning_9_4,
		[5] = ui_learning_9_5,
		[6] = ui_learning_9_6,
		[7] = ui_learning_9_7,
		[8] = ui_learning_9_8,
	},
	
	[11] = {
		[2] = ui_learning_11_2,
		[3] = ui_learning_11_3,
		[4] = ui_learning_11_4,
		[5] = ui_learning_11_5,
		[6] = ui_learning_11_6,
	},
	[12] = {
		[2] = ui_learning_12_2,
		[3] = ui_learning_12_3,
		[4] = ui_learning_12_4,
		[5] = ui_learning_12_5,
		[6] = ui_learning_12_6,
		[7] = ui_learning_12_7,
		[8] = ui_learning_12_8,
	},
	[14] = {
		[2] = ui_learning_14_2,
		[3] = ui_learning_14_3,
		[4] = ui_learning_14_4,
		[5] = ui_learning_14_5,
		[6] = ui_learning_14_6,
		[7] = ui_learning_14_7,
		[8] = ui_learning_14_8,
		[9] = ui_learning_14_9,	
	},
};

local ui = ui_learning;

function p.ShowUI( step, substep )
	p.step = step;
	p.substep = substep;
	
	if p.layer ~= nil and p.maskLayer ~= nil then
		p.maskLayer:SetVisible( true );
		p.layer:SetVisible( true );
		p.ShowRookieText();
		return;
	end

	local maskLayer = createNDUIDialog();
	if maskLayer == nil then
		return false;
	end
	maskLayer:NoMask();
	maskLayer:Init();
	maskLayer:SetSwallowTouch( true );
	maskLayer:SetFrameRectFull();

	p.maskLayer = maskLayer;
	LoadUI( "learning_"..step.."_"..substep..".xui", maskLayer, nil );
	GetUIRoot():AddChildZ( maskLayer, 999999 );

	local layer = createNDUIDialog();
	if layer == nil then
		return false;
	end
	layer:NoMask();            
	layer:Init();
	layer:SetSwallowTouch( false );
	layer:SetFrameRectFull();
	
	LoadUI( "learning.xui", layer, nil );
	GetUIRoot():AddChildZ( layer, 999999 );
	p.layer = layer;
	
	p.InitControllers();
	
	p.ShowRookieText();
end

function p.InitControllers()
	p.faceImage = GetImage( p.layer, ui.ID_CTRL_PICTURE_51 );
	p.colorLabel = GetColorLabel( p.layer, ui.ID_CTRL_COLOR_LABEL_52 );
	
	p.colorLabel:SetHorzAlign( 0 );
	p.colorLabel:SetVertAlign( 1 );
	p.colorLabel:SetIsUseMutiColor(false);

	local index = 1;
	local list = uiList[p.step] or {};	
	local maskUI = list[p.substep] or {};
	while maskUI["ID_CTRL_BUTTON_CALLBACK_"..index] do
		local btn = GetButton( p.maskLayer, maskUI["ID_CTRL_BUTTON_CALLBACK_"..index] );
		btn:SetLuaDelegate( p.OnTouchHightLight );
		btn:SetId( index );
		if p.step == 5 and p.substep == 20 then
			btn:SetEnableSwapDrag(true);
			--btn:SetEnableDrag( true );
		end
		index = index + 1;
	end
	
	local configInfo = SelectRowList( T_ROOKIE_GUIDE, "guide_id", p.step );
	local path = nil;
	if configInfo ~= nil and #configInfo > 0 then
		for i = 1, #configInfo do
			local data = configInfo[i];
			if tonumber(data.talk_id) == p.substep then
				path = data.arrow_res;
				break;
			end
		end
	end
	
	index = 1;
	while maskUI["ID_CTRL_PICTURE_TOUCH_"..index] do
		local image = GetImage( p.maskLayer, maskUI["ID_CTRL_PICTURE_TOUCH_"..index] );
		if image then
			image:SetPicture( nil );
			if path then
				--image:AddFgEffect( "common_ui.rookie_touch" );
				image:AddFgEffect( path );
			end
		end
		index = index + 1;
	end
end

--设置高亮按钮位置
function p.ShowRookieText()
	p.textList = SelectRowList( T_ROOKIE_GUIDE, "guide_id", p.step );

	p.contentStr = "";
	local picData = nil;
	if p.textList ~= nil and #p.textList > 0 then
		for i = 1, #p.textList do
			local data = p.textList[i] or {};
			if tonumber( data.talk_id ) == p.substep then
				p.contentStr = data.talk_text;
				picData = GetPictureByAni( data.head_pic, 0 );
				break;
			end
		end
	end
	
	if string.len(p.contentStr) <= 0 then
		p.layer:SetVisible( false );
		return;
	end
	
	p.faceImage:SetPicture( picData );
	
	p.contentStrLn = GetCharCountUtf8( p.contentStr );	
	p.contentIndex = 1;

	if p.timerId ~= nil then
		KillTimer( p.timerId );
		p.timerId = nil;
	end
	
	p.timerId = SetTimer( p.DoEffectContent, 0.04f );
end

function p.OnTouchHightLight( uiNode, uiEventType, param )
	--通信中无法操作
	if p.onCallFlag then
		return;
	end
	
	WriteConWarning( "step:"..p.step.."substep:"..p.substep );

	if not ((p.step == 5) and (w_battle_guid.substep == 20)) then	--除了这步其它都通过点击触发
		if IsClickEvent( uiEventType ) then
			local id = uiNode:GetId();
			if (p.step ~= nil) and (p.substep ~= nil) and (p.step ~= 0) then
				rookie_main.MaskTouchCallBack( p.step, p.substep, id );
			end;
		end
	else
		if IsDragUp(uiEventType) then
			local id = uiNode:GetId();
			rookie_main.MaskTouchCallBack( p.step, p.substep, id );
		end
	end
end

function p.DoEffectContent()
	if p.colorLabel == nil then
    	return ;
    end

	local strText = GetSubStringUtf8( p.contentStr, p.contentIndex );
	p.colorLabel:SetText(strText);

	p.contentIndex = p.contentIndex + 1;
	if p.contentIndex > p.contentStrLn and p.timerId ~= nil then
		KillTimer( p.timerId );
		p.timerId = nil;
	end
end

function p.ShowTextAtOnce()
	if p.colorLabel == nil then
    	return ;
    end
	
	local strText = p.contentStr;
	p.colorLabel:SetText( strText );
	
	p.contentIndex = 1;
	if p.timerId ~= nil then
		KillTimer( p.timerId );
		p.timerId = nil;
	end
end

function p.CloseUI()
	if p.layer ~= nil then
		p.layer:LazyClose();
		p.layer = nil;
		p.faceImage = nil;
		p.colorLabel = nil;
		p.step = 0;
		p.contentStr = "";
		p.contentStrLn = 0;
		if p.timerId ~= nil then
			KillTimer( p.timerId );
			p.timerId = nil;
		end
		p.contentIndex = 1;
		p.textList = nil;
	end
	
	if p.maskLayer ~= nil then
		p.maskLayer:LazyClose();
		p.maskLayer = nil;
	end
end

function p.HideUI()
	if p.layer ~= nil then
		p.layer:SetVisible( false );
	end
	
	if p.maskLayer ~= nil then
		p.maskLayer:SetVisible( false );
	end
end

