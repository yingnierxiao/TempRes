

--全局配置

--物品大类配置
G_ITEMTYPE_MATERIAL		= 1;		--材料、药水
G_ITEMTYPE_CARD			= 2;		--卡牌
G_ITEMTYPE_EQUIP		= 3;		--装备
G_ITEMTYPE_MONEY		= 4;		--金币
G_ITEMTYPE_SOUL			= 5;		--蓝魂
G_ITEMTYPE_EMONEY		= 6;		--代币
G_ITEMTYPE_GIFT			= 7;		--礼包
G_ITEMTYPE_TREASURE		= 8;		--宝箱
G_ITEMTYPE_EXTRA		= 9;		--其他
G_ITEMTYPE_SHOP			= 10;		--商城物品

function GetItemName( nID, nType )
	if nType == G_ITEMTYPE_MATERIAL then
		return SelectCell( T_MATERIAL, nID, "name" ) or "";
	elseif nType == G_ITEMTYPE_CARD then
		return SelectCell( T_CARD, nID, "name" ) or "";
	elseif nType == G_ITEMTYPE_EQUIP then
		return SelectCell( T_EQUIP, nID, "name" ) or "";
	elseif nType == G_ITEMTYPE_MONEY then
		return SelectCell( T_MONEY, 2, "name" );
	elseif nType == G_ITEMTYPE_SOUL then
		return SelectCell( T_MONEY, 3, "name" );
	elseif nType == G_ITEMTYPE_EMONEY then
		return SelectCell( T_MONEY, 1, "name" );
	elseif nType == G_ITEMTYPE_GIFT then
		return SelectCell( T_ITEM, nID, "name" ) or "";
	elseif nType == G_ITEMTYPE_TREASURE then
		return SelectCell( T_ITEM, nID, "name" ) or "";
	elseif nType == G_ITEMTYPE_EXTRA then
		
	elseif nType == G_ITEMTYPE_SHOP then
		return SelectCell( T_ITEM, nID, "name" ) or "";
	end
	return "";
end

function GetItemPic( nID, nType )
	local path = nil;
	if nType == G_ITEMTYPE_MATERIAL then
		path = SelectCell( T_MATERIAL, nID, "item_pic" );
	elseif nType == G_ITEMTYPE_CARD then
		path = SelectRowInner( T_CHAR_RES, "card_id", nID, "head_pic" );
	elseif nType == G_ITEMTYPE_EQUIP then
		path = SelectCell( T_EQUIP, nID, "item_pic" );
	elseif nType == G_ITEMTYPE_MONEY then
		path = SelectCell( T_MONEY, 2, "item_pic" );
	elseif nType == G_ITEMTYPE_SOUL then
		path = SelectCell( T_MONEY, 3, "item_pic" );
	elseif nType == G_ITEMTYPE_EMONEY then
		path = SelectCell( T_MONEY, 1, "item_pic" );
	elseif nType == G_ITEMTYPE_GIFT then
		path = SelectCell( T_ITEM, nID, "item_pic" );
	elseif nType == G_ITEMTYPE_TREASURE then
		path = SelectCell( T_ITEM, nID, "item_pic" );
	elseif nType == G_ITEMTYPE_EXTRA then
		
	elseif nType == G_ITEMTYPE_SHOP then
		path = SelectCell( T_ITEM, nID, "item_pic" );
	end
	if path ~= nil then
		return GetPictureByAni( path, 0 );
	end
	return nil;
end

