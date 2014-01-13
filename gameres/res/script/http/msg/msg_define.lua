--------------------------------------------------------------
-- FileName: 	msg_define.lua
-- author:		zhangwq, 2013/07/12
-- purpose:		消息id段定义
--------------------------------------------------------------

MSG_GENERAL_ERROR		= 21;

--角色(100)
MSG_PLAYER_LOGIN 		= 101;
MSG_PLAYER				= 102;
MSG_CREATE_PLAYER		= 103;
MSG_WATCH_PLAYER        = 104;

MSG_PLAYER_UPDATE		= 119;--角色信息更新

MSG_SERVER_LIST 		= 120;

MSG_PLAYER_HANDSHAKE	= 121;
MSG_PLAYER_CREATEROLE	= 122;
MSG_PLAYER_USERINFO		= 123;

--任务
MSG_STAGE_LIST			= 130;
MSG_QUEST_LIST			= 131;
MSG_CHAPTER_LIST		= 132;
MSG_TEAM_ITEM			= 133;
MSG_BATTLE_ITEM			= 134;

--村庄
MSG_COUNT_DATA			= 140;
MSG_COUNTRY_UPBUILD 	= 141;

--地图(200)
MSG_MAP_START 			= 200;
MSG_TRAVEL_INFO			= 201;
MSG_TRAVEL_ITEM			= 202;
MSG_WORLD_INFO			= 203;
MSG_TRAVEL_EXPLORE		= 204;
MSG_MISSION_ROLL        = 205;
MSG_TRAVEL_BATTLE		= 206;

--副本地图(260)
MSG_DUNGEON_START		= 260;
MSG_DUNGEON             = 261;
MSG_DUNGEON_EXPLORE     = 262;
MSG_DUNGEON_PROGRESS    = 263;

--任务(300)
MSG_TASK_START 			= 300;

--卡组(400)
MSG_CARD_BAG			= 400;
MSG_CARD_SELL			= 401
--MSG_CARDBOX_START 		= 400;
--MSG_CARDBOX_USER_CARDS  = 401;
MSG_CARDBOX_INTENSIFY   = 402;
MSG_CARDBOX_EVOLUTION   = 403;
MSG_CARDBOX_DEPOT       = 404;
MSG_DEPOT_STORE         = 405;
MSG_DEPOT_TAKEOUT       = 406;
MSG_CARD_EQUIP			= 407;
MSG_CHANGE_EQUIP_RESULT	= 408;
MSG_CARD_FUSE_ITEM		= 409;
MSG_CARD_FUSE_RESULT	= 410;

--背包(500)
MSG_PACK_BOX			= 501
MSG_PACK_EQUIP_SELL  	= 502;
MSG_PACK_ITEM			= 503
MSG_ITEM_HEAL			= 510
MSG_ITEM_QUICK			= 511
MSG_ITEM_STORAGE		= 512
MSG_ITEM_GIFT			= 513
MSG_ITEM_TREASURE		= 514


MSG_EQUIP_START 		= 500;
--MSG_EQUIP_BACK_PACK     = 501;
--MSG_EQUIP_SELL_ITEM     = 502;
MSG_EQUIP_LIST			= 505;
MSG_EQUIP_UPGRADE_RESULT= 506;

--战斗(600)
MSG_BATTLE				= 600;
MSG_BATTLE_PVE   		= 601;
MSG_BATTLE_RESULT		= 602;

--切磋(800)
MSG_QIE_CHUO_START 		= 800;

--联赛(900)
MSG_LEAGUE_MATCH_START 	= 900;

--好友(1000)
MSG_FRIEND_START		= 1000;
MSG_FRIEND_LIST         = 1001;
MSG_FRIEND_APPLY_LIST   = 1002;
MSG_FRIEND_RECOMMEND_LIST   = 1003;
MSG_FRIEND_ACTION_RESULT    = 1004;
MSG_FRIEND_CHAT_LOG         = 1005;
MSG_FRIEND_SERCH_RESULT     = 1006;
MSG_FRIEND_SEND_CHAT_RESULT = 1007

--交易(1100)
MSG_TRADE_START 		= 1100;

--道馆（公会）(1200)
MSG_PARTY_START 		= 1200;

--商城(1300)
MSG_SHOP_START 			= 1300;
MSG_SHOP_ITEM           = 1301;
MSG_SHOP_BUY_RESULT     = 1302;

--引导(1400)
MSG_GUIDE_START 		= 1400;

--其他(1500)
MSG_MISC_START 			= 1500;
MSG_MISC_BILLBOARD      = 1501;
MSG_MISC_ERR		    = 1502;
MSG_MISC_MAINUI 		= 1503;
MSG_MISC_DRAMA			= 1504; --剧情

--队伍(1600)
MSG_TEAM_START          = 1600;
MSG_TEAM_LIST           = 1601;
MSG_TEAM_UPDATE         = 1602;
MSG_TEAM_MODIFY			= 1603;

--角色技能卡包(1700)
MSG_USER_SKILL_CARDBOX  = 1700;

--技能碎片(1800)
MSG_SKILLPIECE_START	= 1800;
MSG_SKILLPIECE          = 1801;
MSG_SKILLPIECE_RESULT   = 1802;
MSG_USER_SKILL          = 1803;
MSG_USER_SKILL_INTENSIFY = 1804;

--扭蛋(1900)
MSG_GACHA_START         = 1900;
MSG_GACHA               = 1901;
MSG_GACHA_RESULT        = 1902;

--图鉴(2000)
MSG_COLLECT_START       = 2000;    

--成就(2100)
MSG_ACHIEVEMENT_START    = 2100;
MSG_ACHIEVEMENT          = 2101;

--邮件系统-发送邮件
MSG_MAIL_SEND_MSG		= 2201
MSG_MAIL_GET_MSGS 		= 2202
MSG_MAIL_DEL_MSG		= 2203
MSG_MAIL_GET_MSG_DETAIL = 2204
MSG_MAIL_GET_REWARD		= 2205


--召唤兽(2300)
--MSG_PET_START			= 2300;
MSG_PET_GETPETDATA		= 2300;--获取用户召唤兽信息
MSG_PET_TRAINPET		= 2301;--召唤兽培养
MSG_PET_SELLPET			= 2302;--召唤兽出售
MSG_PET_CALLPET			= 2303;--召唤兽出战\收回
--MSG_PET_END				= 2399;

--卡牌
MSG_CARD_ROLE_DETAIL			= 2401; --卡牌角色详细
MSG_CARD_EQUIPMENT_DETAIL		= 2402; --卡版装备详细
MSG_CARD_EQUIPMENT_INSTALL		= 2403; --卡版装备安装
MSG_CARD_EQUIPMENT_UNINSTALL	= 2404; --卡版装备卸下
MSG_CARD_EQUIPMENT_UPGRADE		= 2405; --卡版装备升级
MSG_CARD_EQUIPMENT_LIST			= 2406; --卡版装备列表

MSG_COLLECT_LIST			= 2600;--可采集次数，在村落数据中已发
MSG_COLLECT_PICK			= 2601;--采集
MSG_COLLECT_SYNTHESIS		= 2602;--合成
MSG_COLLECT_SELL			= 2603;--出售
MSG_COLLECT_MATERIALLIST	= 2604;--材料列表
