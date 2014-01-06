w_battle_PVEStateMachine = {}
local p = w_battle_PVEStateMachine;
		  
--PVE��һ��ս����״̬��


--������ʵ��
function p:new()	
	o = {}
	setmetatable( o, self );
	self.__index = self;
	o:ctor();
	return o;
end

--���캯��
function p:ctor()
	self.IsEnd = false;
	self.IsAtkTurnEnd = false;	
	self.IsTarTurnEnd = false;
	
	self.atkId = 0;
	self.id = 0;	
	self.targerId = 0;
	self.atkCampType = 0;
	self.tarCampType = 0;
	self.atkType = 0; 
	self.damage = 0;
	self.isCrit = false;
	self.isJoinAtk = false;
	self.atkplayerNode = 0;
	self.IsRevive = false;

	local batch = battle_show.GetNewBatch(); 
	--self.seqStar = batch:AddParallelSequence(); --ս����ʼ�Ĳ��ж���;
	self.seqStar = battle_show.GetDefaultParallelSequence();
	self.seqAtk = batch:AddParallelSequence();
    self.seqTarget = batch:AddParallelSequence(); 
	--self.seqBullet = batch:AddSerialSequence();	
	
end



function p:init(id,atkFighter,atkCampType,tarFighter, atkCampType,damage,isCrit,isJoinAtk)
	--self.seqStar = seqStar;
	self.atkId = atkFighter:GetId();
	self.id = id;	
	self.targerId = tarFighter:GetId();
	self.atkCampType = atkCampType;
	self.tarCampType = tarCampType;
	self.atkType = atkFighter:GetAtkType(); 
	self.damage = damage;
	self.isCrit = isCrit;
	self.isJoinAtk = isJoinAtk;
	self.atkplayerNode = atkFighter:GetPlayerNode();

    --�����������λ��
    self.originPos = self.atkplayerNode:GetCenterPos();

    --����Ŀ���λ��
    self.enemyPos = tarFighter:GetFrontPos(self.atkplayerNode);	

	
	self:start();

end;

function p:start()
	local atkFighter = self:getAtkFighter();
	local tarFighter = self:getTarFighter();
    local latkType = self.atkType;
    local playerNode = self.atkplayerNode;
			
	if latkType == W_BATTLE_DISTANCE_NoArcher then  --��ս�չ�
	
		local distance = tonumber( SelectCellMatch( T_CHAR_RES, "card_id", atkFighter.cardId, "distance" ) );
       
    
		--�����������λ��
		local originPos = playerNode:GetCenterPos();

		--�ܻ�Ŀ���λ��
		local enemyPos = tarFighter:GetFrontPos(playerNode);

		
		--��������
		--local cmdAtkBegin = createCommandInstant_Misc():SetZOrderAtTop( playerNode, true );
		--self.seqStar:AddCommand( cmdAtkBegin );

		--WriteCon("atk move! id="..tostring(atkFighter:GetId()));
		--�򹥻�Ŀ���ƶ�
		local cmdMove = OnlyMoveTo(atkFighter, originPos, enemyPos, self.seqStar);
		
		--self.seqAtk = batch:AddParallelSequence();
		--�л�������״̬
		local cmdAtk = atkFighter:cmdLua( "atk_startAtk",   self.id,"", self.seqAtk );
		self.seqAtk:SetWaitEnd(cmdMove);
		
		
		local cmdHurt = tarFighter:cmdLua("tar_hurt",        self.id,"", self.seqTarget);
		self.seqTarget:SetWaitEnd( cmdMove );
		
		
	elseif self.atkType == W_BATTLE_DISTANCE_Archer then  --Զ�̹���
	    local isBullet = tonumber( SelectCellMatch( T_CHAR_RES, "card_id", atkFighter.cardId, "is_bullet" ) );
		local bulletAni;
		if isBullet == N_BATTLE_BULLET_1 then --�е���
			local cmdAtk = createCommandPlayer():Atk( 0.3, playerNode, "" );
			self.seqAtk:AddCommand( cmdAtk ); --��������
			
			local atkSound = SelectCell( T_CARD_ATK_SOUND, atkFighter.cardId, "atk_sound" );	
			--�ܻ�����
			if atkSound ~= nil then
				local cmdAtkMusic = createCommandSoundMusicVideo():PlaySoundByName( atkSound );
				self.seqAtk:AddCommand( cmdAtkMusic );
			end			
			
			local bulletAni = "n_bullet."..tostring( atkFighter.cardId );
			
			local deg = atkFighter:GetAngleByFighter( tarFighter );
			local bullet = w_bullet:new();
			bullet:AddToBattleLayer();
			bullet:SetEffectAni( bulletAni );
						
			bullet:GetNode():SetRotationDeg( deg );
			local bullet1 = bullet:cmdSetVisible( true, self.seqAtk );
			bulletend = bullet:cmdShoot( atkFighter, tarFighter, self.seqAtk, false );
			local bullet3 = bullet:cmdSetVisible( false, self.seqAtk );
			--seqBullet:SetWaitEnd( cmdAtk );
			
			--�л�������״̬
			atkFighter:cmdLua( "atk_startAtk",  self.id,  "", self.seqAtk );

			tarFighter:cmdLua("tar_hurt",        self.id, "", self.seqTarget);
			self.seqTarget:SetWaitEnd( cmdAtk );
			
		else  --û����
			local cmdAtk = createCommandPlayer():Atk( 0.3, playerNode, "" );
			self.seqAtk:AddCommand( cmdAtk ); --��������
			
			local atkSound = SelectCell( T_CARD_ATK_SOUND, atkFighter.cardId, "atk_sound" );	
			--�ܻ�����
			if atkSound ~= nil then
				local cmdAtkMusic = createCommandSoundMusicVideo():PlaySoundByName( atkSound );
				self.seqAtk:AddCommand( cmdAtkMusic );
			end
			
			atkFighter:cmdLua( "atk_startAtk",   self.id,"", self.seqAtk );
			
			tarFighter:cmdLua("tar_hurt",  self.id, "", self.seqTarget);
			self.seqTarget:SetWaitEnd( cmdAtk );
		end

	end
	
end


function p:atk_startAtk()  --����
	local atkFighter = self:getAtkFighter();

	if self.atkType == W_BATTLE_DISTANCE_NoArcher then  --��ս�չ�
		local batch = battle_show.GetNewBatch(); 
		self.seqAtk = batch:AddParallelSequence();
		--self.seqAtk = batch:AddSerialSequence();
		--�������˶���
		local cmdAtk = createCommandPlayer():Atk( 0.3, self.atkplayerNode, "" );
		self.seqAtk:AddCommand( cmdAtk );	
		
--[[
		local atkSound = SelectCell( T_CARD_ATK_SOUND, atkFighter.cardId, "atk_sound" );	
		--�ܻ�����
		if atkSound ~= nil then
			local cmdAtkMusic = createCommandSoundMusicVideo():PlaySoundByName( atkSound );
			self.seqAtk:AddCommand( cmdAtkMusic );
		end
	]]--	
	end;
	
	--�������������ܻ�����
	atkFighter:cmdLua( "atk_end",  self.id, "", self.seqAtk ); 
	
end

function p:atk_end()
	local atkFighter = self:getAtkFighter();
	local tarFighter = self:getTarFighter();


    --�ܻ����Ѫ,���õȵ�Ѫ�������
	--local cmd11 = tarFighter:cmdLua( "fighter_damage",   self.id,"", self.seqTarget );	
	tarFighter:SubShowLife(self.damage); --��Ѫ����,����ʾ��Ѫ������
	local cmd4 = createCommandPlayer():Standby( 0.01, self.atkplayerNode, "" );
	self.seqAtk:AddCommand( cmd4 );
	
    --����������	
	if self.atkType == W_BATTLE_DISTANCE_NoArcher then  --��ս�չ�
		
		    --���վ������

        --����ԭ����λ��
        local cmd5 = OnlyMoveTo(atkFighter, self.enemyPos, self.originPos, self.seqAtk);
    
--		local cmdBackRset = createCommandEffect():AddActionEffect( 0, tarFighter:GetPlayerNode(), "lancer.target_hurt_back_reset" );
--		self.seqAtk:AddCommand( cmdBackRset ); 
		
		--local cmdClearPic = atkFighter:cmdLua( "ClearAllFighterPic",  0, self.id, seqAtk );
	end;

	--��ʶ�������Ĺ��������
	atkFighter:cmdLua( "atk_standby",  self.id, "", self.seqAtk ); 


	--�ܻ�������
	--�ܻ�������һ	
	tarFighter:BeHitDec(atkFighter:GetId()); 
	
	self:tar_hurtEnd();


end

function p:fighter_damage()
	local atkFighter = self:getAtkFighter();
	local tarFighter = self:getTarFighter();
	
end;


function p:atk_standby()
   	local atkFighter = self:getTarFighter();
	atkFighter:standby();
    --atkFighrer.turnRound = false;	--��ʶ��������;
	self:atkTurnEnd();
	
end;

function p:tar_hurt()


	local atkFighter = self:getAtkFighter();
	local targerFighter = self:getTarFighter();


    if targerFighter.IsHurt == false then
		targerFighter.IsHurt = true;  --��ʶ�ܻ���
		--�ܻ���������һ��
		local cmdHurt = createCommandPlayer():Hurt( 0, targerFighter:GetNode(), "" );
		self.seqTarget:AddCommand( cmdHurd );

	    --�ܻ��������޲�
		--local cmdHurtAll = createCommandPlayer():Hurt( 0, targerFighter:GetNode(), "" );
		--self.seqTarget:AddCommand( cmdHurtAll );

        
	end;
	
end;

--����
function p:reward()
	local targerFighter = self:getTarFighter();	
	local tmpList = { {E_DROP_MONEY, 1, targerFighter.Position},
					  {E_DROP_BLUESOUL , 2, targerFighter.Position},
					  {E_DROP_HPBALL , 3, targerFighter.Position},
					  {E_DROP_SPBALL , 4, targerFighter.Position}
					}
	w_battle_pve.MonsterDrop(tmpList)
	
end;

function p:tar_hurtEnd()
	local atkFighter = self:getAtkFighter();
	local targerFighter = self:getTarFighter();	
	
	if targerFighter:GetHitTimes() == 0 then --�ܻ�����Ϊ0ʱ
		targerFighter.IsHurt = false;
	    if targerFighter.showlife > 0 then  --������,��������վ��	
			targerFighter:standby();
			self:targerTurnEnd();  --�ܻ������̽���
		elseif targerFighter.showlife <= 0 then
            if self.CanRevive == true then  --�ɸ���
				targerFighter.isDead = false;
				targerFighter.canRevive = false;
				
				targerFighter:standby();

				local cmdf = createCommandEffect():AddActionEffect( 0.01, targerFighter:GetNode(), "lancer_cmb.revive" );
				self.seqTarget:AddCommand( cmdf );
				local cmdC = createCommandEffect():AddActionEffect( 0.01, targerFighter.m_kShadow, "lancer_cmb.revive" );
				self.seqTarget:AddCommand( cmdC );		
				
				local batch = battle_show.GetNewBatch();
				local seqDie	= batch:AddParallelSequence();
				local cmdRevive = targerFighter:cmdLua("tar_ReviveEnd",  self.id, "", seqDie);
				self.seqRevive:SetWaitEnd( cmdC ); 
			else	--������
				--�ж��Ƿ�Ҫ�л�����Ŀ��
				targerFighter:Die();  --��ʶ����
				if w_battle_mgr.LockEnemy == true then
					if(w_battle_mgr.PVEEnemyID == targerFighter:GetId()) then  --��ǰ�����Ĺ��������ڱ������Ĺ���
						if w_battle_mgr.enemyCamp:GetNotDeadFighterCount() > 0 then --�ɻ�������
							w_battle_mgr.PVEEnemyID = w_battle_mgr.enemyCamp:GetFirstNotDeadFighterID(targerFighter:GetId()); --����ID��Ļ�Ĺ���Ŀ��
							--p.LockEnemy = false  --ֻҪѡ������һֱ��������������
						else  --û�л��ŵĹ����ѡ
						   w_battle_mgr.isCanSelFighter = false;
						end
					end;
				else
					--�����������Ĺ���,��ѡ���ҷ���Աʱ������˹����ѡ��,���账��
				end;			
				self:reward(); --��ý���
				
				
				local cmdf = createCommandEffect():AddActionEffect( 0.01, targerFighter.m_kShadow, "lancer_cmb.die" );
				self.seqTarget:AddCommand( cmdf );
				local cmdC = createCommandEffect():AddActionEffect( 0.01, targerFighter:GetNode(), "lancer_cmb.die" );
				self.seqTarget:AddCommand( cmdC );				
				local batch = battle_show.GetNewBatch(); 
				local seqDie	= batch:AddParallelSequence();
				local cmdDieEnd = targerFighter:cmdLua("tar_dieEnd",  self.id,"", seqDie);
				seqDie:SetWaitEnd( cmdC ); 
			end;
		end;
	else --�����������˴��,���ι�����������ܻ����̾ͽ�����
		self:targerTurnEnd();  --�ܻ������̽���
	end;

end;

function p:tar_ReviveEnd()
	fighter:GetNode():ClearAllAniEffect();
    fighter.buffList = {};		
	self:targerTurnEnd();	
end;

function p:tar_dieEnd()
	self:targerTurnEnd();
end;

function p:atkTurnEnd()
	self.IsAtkTurnEnd = true;
	self:CheckEnd();
end;

function p:targerTurnEnd()
	self.IsTarTurnEnd = true;
	self:CheckEnd();
end;

function p:CheckEnd()
	if (self.IsAtkTurnEnd == true) and (self.IsTarTurnEnd == true) then
		self.IsEnd = true;
		w_battle_PVEStaMachMgr:delStateMachine(self.id);
		local atkFighter = self:getAtkFighter();
		atkFighter.IsTurnEnd = true;
		
		if self.atkCampType == W_BATTLE_HERO then	
			if w_battle_mgr.enemyCamp:isAllDead() == false then
				w_battle_mgr.CheckHeroTurnEnd();	
			else
				w_battle_mgr.StepOver(true);
			end
			
		else
			if w_battle_mgr.heroCamp:isAllDead() == false then
				w_battle_mgr.CheckEnemyTurnEnd();
			else
				w_battle_mgr.StepOver(false);
			end		
		end;
		
		self = nil;		
	end
end;


--[[
function p:atk_hurt()    	
	local batch = battle_show.GetNewBatch(); 
	local seqAtk    = batch:AddSerialSequence();
    local seqTarget = batch:AddSerialSequence();
		
	local atkFighter = self:getAtkFighter();	
	
	--show������ֵ����,ƮѪ
	atkFighter:atk_damage(self.damage);
    	

	
	--cmdAtk:SetDelay(0.2f); --���ù����ӳ�
     local playerNode = self.atkplayerNode;
    
	
    --	
	
    --���վ������
    local cmd4 = createCommandPlayer():Standby( 0.01, playerNode, "" );
    seqAtk:AddCommand( cmd4 );
    

    --����ԭ����λ��
    local cmd5 = JumpMoveTo(atkFighter, enemyPos, originPos, seqAtk, false);

    

    
    local cmdAtkEnd = createCommandInstant_Misc():SetZOrderAtTop( atkFighter:GetNode(), false );
    seqAtk:AddCommand( cmdAtkEnd );
    
	--��������������, ����˳�д�����1,��Ϊ0ʱ,�ж��Ƿ����վ����������.
	--��cmd����ִ��ѹ��seqAtk˳��ִ��
	atkFighter:cmdLua( "atk_hurt",  targetFighter:GetId(), "", seqAtk );

end
]]--
function p:getFighter(pId,pCampType)
	local lFighter = nil;
	if pCampType == W_BATTLE_HERO then
		lFighter = w_battle_mgr.heroCamp:FindFighter(pId);
	else
		lFighter = w_battle_mgr.enemyCamp:FindFighter(pId);
	end
	return lFighter;
end;

function p:getAtkFighter()
	return self:getFighter(self.atkId, self.atkCampType);
end;

function p:getTarFighter()
	return self:getFighter(self.targerId, self.tarCampType);
end;
