--------------------------------------------------------------
-- FileName: 	dlg_drama.lua
-- author:		
-- purpose:		剧情界面
--------------------------------------------------------------

dlg_drama = {}
local p = dlg_drama;
local ui = ui_dlg_drama;

p.layer = nil;

p.contentNode = nil;
p.npcNameNode = nil;
p.bgPicNode   = nil;
p.npcPicNodeL = nil;
p.npcPicNodeM = nil;
p.npcPicNodeR = nil;

p.contentStr = nil;     --当前对话内容
p.contentStrLn = nil;   --当前对话内容长度
p.contentIndex = nil;   --当前说话的索引，用于特效
p.timerId = nil;        --定时器ID
p.isActivity = false;
p.fontSize = 20;

p.storyId = nil;
p.openViewType =nil;
p.viewId = nil;
p.teamId = nil;
p.rewardData = {};
local act_zoom = "engine_cmb.zoom_in_out"; --呼吸效果

local DIR_LEFT = 1;--图片在左
local DIR_RIGHT = 2;--图片在右
--显示UI
function p.ShowUI( storyId,openViewType,viewId,teamId,rewardList)
											--参数 openViewType 详见 after_drama_data.lua
    if storyId == nil or openViewType == nil or viewId == nil then
    	return;
    else
       p.storyId = tonumber(storyId);	
	   p.openViewType = tonumber(openViewType);
	   p.viewId = tonumber(viewId);
	   p.teamId = tonumber(teamId) or 1;
	   p.rewardData = rewardList or {}
    end
	
	dlg_menu:HideUI();

	p.isActivity = true;
    if p.layer ~= nil then
		p.layer:SetVisible( true );
		drama_mgr.LoadDramaInfo();
		return;
	end
	
	local layer = createNDUIDialog();
    if layer == nil then
        return false;
    end
	
	dlg_userinfo.HideUI();
	layer:Init();	
	GetUIRoot():AddChild(layer);
    LoadUI("dlg_drama.xui", layer, nil);
	
	p.layer = layer;
	p.Init();
	p.SetDelegate();
	drama_mgr.LoadDramaInfo();
end

--初始化控件
function p.Init()
    --p.AddMaskImage();
    p.contentNode = GetColorLabel( p.layer, ui.ID_CTRL_COLOR_LABEL_TEXT );
	p.contentNode:SetHorzAlign( 0 );
	p.contentNode:SetVertAlign( 1 );
	p.contentNode:SetIsUseMutiColor(false);
    p.npcNameNode = GetLabel( p.layer, ui.ID_CTRL_TEXT_NPC_NAME );
    p.bgPicNode = GetImage( p.layer,ui.ID_CTRL_PICTURE_BG );
    
    p.npcPicNodeL = GetImage( p.layer,ui.ID_CTRL_PICTURE_L );
    p.npcPicNodeM = GetImage( p.layer,ui.ID_CTRL_PICTURE_M );
    p.npcPicNodeR = GetImage( p.layer,ui.ID_CTRL_PICTURE_R );
    
    --local contentBg = GetImage( p.layer,ui.ID_CTRL_PICTURE_CONTENT_BG );
    --contentBg:SetPicture( GetPictureByAni("drama.content_bg", 0) );
end

--增加蒙版：未使用
function p.AddMaskImage()
	local maskNode = GetImage( p.layer,ui.ID_CTRL_PICTURE_MASK );
	maskNode:SetPicture( GetPictureByAni("drama.mask", 0) );
end

--设置事件
function p.SetDelegate()
    --下一个对话
    local btn = GetButton(p.layer,ui.ID_CTRL_BUTTON_CLICK);
	btn:SetVisible( false );	
    btn:SetLuaDelegate(p.BtnOnclick);

    --跳过剧情
    btn = GetButton(p.layer,ui.ID_CTRL_BUTTON_SKIP);
	--GetUIRoot():SwapParent(btn,100000);
    btn:SetLuaDelegate(p.OnPassDrama);
	
	btn = GetButton(p.layer,ui.ID_CTRL_BUTTON_38);
    btn:SetLuaDelegate(p.BtnOnclick);
    
    --下一个对话：全屏
    btn = GetButton(p.layer,ui.ID_CTRL_BUTTON_BG);
    btn:SetLuaDelegate(p.BtnOnclick);
end

function p.OnPassDrama(uiNode, uiEventType, param)
    if IsClickEvent( uiEventType ) then
		WriteCon("Drama Over!!!");
		if p.timerId ~= nil then
			KillTimer( p.timerId );
			p.timerId = nil;
		end
			
		p.isActivity = false;
		p.CloseUI();
		drama_mgr.ClearData();
		after_drama.DoAfterDrama();
	end
end

--事件处理
function p.BtnOnclick(uiNode, uiEventType, param)
    local tag = uiNode:GetTag();
    if IsClickEvent( uiEventType ) then
    
        --下一个剧情对话
        if ( ui.ID_CTRL_BUTTON_38 == tag) then
            if p.timerId ~= nil then
            	KillTimer( p.timerId );
            	p.timerId = nil;
            end
            drama_mgr.NextDramaInfo();
            
        --跳过剧情    
        elseif ( ui.ID_CTRL_BUTTON_SKIP == tag ) then  
			WriteCon("Drama Over!!!");
			if p.timerId ~= nil then
                KillTimer( p.timerId );
                p.timerId = nil;
            end
			
            p.isActivity = false;
			p.CloseUI();
			drama_mgr.ClearData();
			after_drama.DoAfterDrama();
            --p.CloseUI();
        end
    end
end

--内容对话特效
function p.DoEffectContent()
    if p.contentNode == nil then
    	return ;
    end
	
	local strText = GetSubStringUtf8( p.contentStr, p.contentIndex );
	--WriteCon(strText);
	p.contentNode:SetText(strText);

	p.contentIndex = p.contentIndex + 1;
	if p.contentIndex > p.contentStrLn and p.timerId ~= nil then
		KillTimer( p.timerId );
		p.timerId = nil;
		
		local btn = GetButton(p.layer,ui.ID_CTRL_BUTTON_CLICK);
		btn:SetVisible( true );
	end
end

--更新场景：NPC以及对话内容等
function p.ResetUI( dramaInfo )
    p.AddSilentNpcEffect();
	local bgPic = GetPictureByAni( "drama.bg_"..dramaInfo.picBg, 0);
    p.bgPicNode:SetPicture( bgPic );
    
	local name = dramaInfo.npcName;
	if tonumber(name) ~= nil and tonumber(name) == 0 then
		name = " ";
	end
	if string.find( name, "主角") then
		name = msg_cache.msg_player.Name or dramaInfo.npcName;
	end

    p.npcNameNode:SetText( name );
    
    --对话内容
    p.contentStr = dramaInfo.talkText;
	p.fontSize = dramaInfo.fontSize;
    p.contentStrLn = GetCharCountUtf8 ( p.contentStr );
    p.contentIndex = 1;
    if p.contentStr ~= nil and p.contentStrLn > 1 then

		if tonumber(dramaInfo.speak_id) == 99999 then
			p.contentNode:SetFontColor(ccc4(0,176,80,255));
		else
			p.contentNode:SetFontColor(ccc4(255,255,255,255));
		end
		
		p.contentNode:SetFontSize(p.fontSize);
		p.contentNode:AddActionEffect("ui.ccshake");
		
		local btn = GetButton(p.layer,ui.ID_CTRL_BUTTON_CLICK);
		btn:SetVisible( false );
	
    	p.timerId = SetTimer( p.DoEffectContent, 0.04f );
    end

    --NPC图片以特效更新：左边NPC
    if tonumber( dramaInfo.picLeft ) ~= nil and tonumber( dramaInfo.picLeft ) ~= 0 then
		for i = 0, 2, 1 do
			local npcid = tonumber( dramaInfo.picLeft ) == 99999 and msg_cache.msg_player.Face or dramaInfo.picLeft;
			local ani = GetAni( "drama."..npcid .. "_" .. i );
			if ani ~= nil then
				bgPic = GetPictureByAni( "drama."..npcid .. "_" .. i, 0);
				bgPic:SetReverse( i == DIR_LEFT );--图片在左，卡牌本身朝向左则翻转图片
				p.npcPicNodeL:SetVisible( true );
				p.npcPicNodeL:SetPicture( bgPic );
				if tonumber( dramaInfo.npcIdTalk ) == tonumber( dramaInfo.picLeft ) then
					p.AddNpcEffect( p.npcPicNodeL );
				end
				break;
			end
		end
    else
		p.npcPicNodeL:SetVisible( false );
	end

     --NPC图片以特效更新：右边NPC
    if tonumber( dramaInfo.picRight ) ~= nil and tonumber( dramaInfo.picRight ) ~= 0 then
		for i = 0, 2, 1 do
			local npcid = tonumber( dramaInfo.picRight ) == 99999 and msg_cache.msg_player.Face or dramaInfo.picRight;
			local ani = GetAni( "drama."..npcid .. "_" .. i );
			if ani ~= nil then
				bgPic = GetPictureByAni( "drama."..npcid .. "_" .. i, 0);
				bgPic:SetReverse( i == DIR_RIGHT );--图片在右，卡牌本身朝向右则翻转图片
				p.npcPicNodeR:SetVisible( true );
				p.npcPicNodeR:SetPicture( bgPic );
				if tonumber( dramaInfo.npcIdTalk ) == tonumber( dramaInfo.picRight ) then
					p.AddNpcEffect( p.npcPicNodeR );
				end
				break;
			end
		end
    else
		p.npcPicNodeR:SetVisible( false );
	end
end

--添加Npc特效
function p.AddNpcEffect( npcNode )
    npcNode:SetScale(1.01f);
    npcNode:SetMaskColor(ccc4(255,255,255,255));
	
	if not npcNode:FindActionEffect( act_zoom ) then
		npcNode:AddActionEffect( act_zoom );
	end
end

--清除NPC的当前特效：即不是当前说话NPC的默认效果
function p.AddSilentNpcEffect()
    p.npcPicNodeL:SetMaskColor(ccc4(160,160,160,255));
	p.npcPicNodeM:SetMaskColor(ccc4(160,160,160,255));
	p.npcPicNodeR:SetMaskColor(ccc4(160,160,160,255));
	
	p.npcPicNodeL:DelActionEffect( act_zoom );
	p.npcPicNodeM:DelActionEffect( act_zoom );
	p.npcPicNodeR:DelActionEffect( act_zoom );
end

--隐藏UI
function p.HideUI()
	if p.layer ~= nil then
	    p.isActivity = false;
		p.layer:SetVisible( false );
	end
end

--关闭UI
function p.CloseUI()
    if p.layer ~= nil then
		p.layer:SetVisible(false);
        p.layer:LazyClose();
    	p.layer = nil;
        p.contentNode = nil;
        p.npcNameNode = nil;
        p.bgPicNode   = nil;
        p.npcPicNodeL = nil;
        p.npcPicNodeM = nil;
        p.npcPicNodeR = nil;
        
        p.contentStr = nil;     
        p.contentStrLn = nil;   
        p.contentIndex = nil; 
        
        p.timerId = nil;
        p.isActivity = false;
    end
end

function p.IsActivity()
	return p.isActivity;
end

