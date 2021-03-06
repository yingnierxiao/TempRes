w_battle_machinemgr = {}
local p = w_battle_machinemgr;

p.targetHeroMachineLst = {}; --受击者状态机列表
p.targetEnemyMachineLst = {}; --受击者状态机列表

p.atkMachineLst = {}; 
p.atkEnemyMachineLst = {};

p.heroBuffMachineLst = {};
p.enemyBuffMachineLst = {};

p.id = 0;


--受击者状态机管理,每个受击者状态机以受击开始,以死亡,或复活站立结束
function p.init()
	p.targetHeroMachineLst = {}; 
	p.targetEnemyMachineLst = {};
	p.atkMachineLst = {}; 
    p.atkEnemyMachineLst = {};
	
	p.heroBuffMachineLst = {};
	p.enemyBuffMachineLst = {};
    --受击者状态机,默认的状态都是结束,所以不用判断是否存在
	for pos=1,6 do
		local lTargetHeroMachine = w_battle_target_statemachine:new();
		lTargetHeroMachine:init(pos,W_BATTLE_HERO);
		p.targetHeroMachineLst[pos] = lTargetHeroMachine;
		
		local lTargetEnemyMachine = w_battle_target_statemachine:new();
		lTargetEnemyMachine:init(pos,W_BATTLE_ENEMY);
		p.targetEnemyMachineLst[pos] = lTargetEnemyMachine;
	end;
--[[
	local camp = nil;
	if w_battle_mgr.atkCampType == W_BATTLE_HERO then
		camp = w_battle_mgr.heroCamp;
	else
		camp = w_battle_mgr.enemyCamp;
	end
	]]
	for k,v in ipairs(w_battle_mgr.heroCamp.fighters) do
		local lAtkMachine = w_battle_atk_statemachine:new();
		lAtkMachine.id = v.Position;
		p.atkMachineLst[#p.atkMachineLst + 1] = lAtkMachine;
		
		local lBuffMachine = w_battle_buff_statemachine:new();
		lBuffMachine:init(v,W_BATTLE_HERO);
		p.heroBuffMachineLst[#p.heroBuffMachineLst + 1] = lBuffMachine;
	end;
	
	for k,v in ipairs(w_battle_mgr.enemyCamp.fighters) do
		local lAtkMachine = w_battle_atk_statemachine:new();
		lAtkMachine.id = v.Position;
		p.atkEnemyMachineLst[#p.atkEnemyMachineLst + 1] = lAtkMachine;
		
		local lBuffMachine = w_battle_buff_statemachine:new();
		lBuffMachine:init(v,W_BATTLE_ENEMY);
		p.enemyBuffMachineLst[#p.enemyBuffMachineLst + 1] = lBuffMachine;
	end;
	
end;

--获得受击者状态机
function p.getTarStateMachine(camp,pos)
	local ltargetMachine = nil;
	if tonumber(camp) == W_BATTLE_HERO then
		ltargetMachine =  p.targetHeroMachineLst[pos]	
	else
		ltargetMachine = p.targetEnemyMachineLst[pos]
	end
	
	if ltargetMachine ~= nil then
		if w_battle_mgr.NeedQuit == true then --中途退出,直接结束
			ltargetMachine:targerTurnEnd();
			ltargetMachine = nil;
		end
	end	
	return ltargetMachine;
end

--获得攻击者状态机
function p.getAtkStateMachine(pos)
	local latkMachineLst =	{};
	if w_battle_mgr.atkCampType == W_BATTLE_HERO then
		latkMachineLst = p.atkMachineLst;
	else
		latkMachineLst = p.atkEnemyMachineLst;
	end;

	local latkMachine = nil;
	for k,v in ipairs(latkMachineLst) do
		if v.id == pos then
			latkMachine = v;
		end;
	end;
	
	if latkMachine ~= nil then
		if w_battle_mgr.NeedQuit == true then --中途退出,直接结束
			latkMachine:atkTurnEnd();
			latkMachine = nil;
		end
	end	
	
	return latkMachine;
end;


--判断所有受击的状态机是否都结束了
function p.checkAllTargetMachineEnd()  
	local lres = true;
	for pos=1,6 do
		local lTargetMachine = p.targetHeroMachineLst[pos];
		if lTargetMachine:IsEnd() == false then
			local lFighter = lTargetMachine.tarFighter;
			if lFighter ~= nil then
				if(lFighter:GetTargerTimes() == 0) then
					lres = false;
					break;
				end;
			end;
		end
	end
	
	for pos=1,6 do
		local lTargetMachine = p.targetEnemyMachineLst[pos];
		if lTargetMachine:IsEnd() == false then
			local lFighter = lTargetMachine.tarFighter;
			if lFighter ~= nil then
				if(lFighter:GetTargerTimes() == 0) then
					lres = false;
					break;
				end;
			end;
		end
	end	
	if lres == true then
		WriteCon("all targetMachine finish");
	end
	return lres;
end;

--判断所有攻击状态机处于行动中,若有行动中的,返回true
function p.checkAllAtkMachineHasTurn()	
	local lres = false;
	local latkMachineLst = nil;
	if w_battle_mgr.atkCampType == W_BATTLE_HERO then
		latkMachineLst = p.atkMachineLst;
	else
		latkMachineLst = p.atkEnemyMachineLst;
	end;
	
	for k,v in ipairs(latkMachineLst) do
		local lMachine = v
		if lMachine.turnState == W_BATTLE_TURN  then --行动中
			lres = true;
			break;
		end
	end
	

	return lres;
end

--判断所有攻击状态机是否有未行动的,有未行动的返回true,只有我方人员才需要此判断
function p.checkAllAtkMachineHasNotTurn()
	local lres = false;
	local latkMachineLst = nil;
	local camp = nil;
	if w_battle_mgr.atkCampType == W_BATTLE_HERO then
		latkMachineLst = p.atkMachineLst;
		camp = w_battle_mgr.heroCamp; 
	else
		latkMachineLst = p.atkEnemyMachineLst;
		camp = w_battle_mgr.EnemyCamp;
	end;
	
	for k,v in ipairs(latkMachineLst) do
		local lMachine = v
		local lheroFighter = w_battle_mgr.heroCamp:FindFighter(v.id);
		if (lheroFighter ~= nil) and (lheroFighter.nowlife > 0) then
			if lMachine.turnState == W_BATTLE_NOT_TURN  then --未行动
				lres = true;
				break;
			end
		end;
	end
	
	if lres == true then
		WriteCon("atk has not turn")
	else
		WriteCon("atk all is turn end")
	end
	
	return lres;
end
--[[
--判断所有攻击状态机是否都已未行动的,若都行动了,返回true
function p.checkAllAtkMachineIsTurnEnd()
	local lres = true;
	for k,v in ipairs(p.atkMachineLst) do
		local lMachine = v
		if lMachine.turnState == W_BATTLE_TURNEND  then --已行动
			lres = false;
			break;
		end
	end
	
	return lres;
end
]]--
function p.InitAtkTurnEnd(fightcamp)
	--for pos=1,#(p.atkMachineLst) do
	
	if fightcamp == W_BATTLE_HERO then
		camp = w_battle_mgr.heroCamp;
		latkMachineLst = p.atkMachineLst;
	else
		camp = w_battle_mgr.enemyCamp;
		latkMachineLst = p.atkEnemyMachineLst;
	end;
		
	for k,v in ipairs(latkMachineLst) do		
		local lMachine = v
		lMachine.turnState = W_BATTLE_NOT_TURN;   --未行动
		
		local lFighter = camp:FindFighter(v.id);
		if (lFighter ~= nil) then
			if lFighter.nowlife > 0 then
				if lFighter.HasTurn == false then
					lMachine.turnState = W_BATTLE_TURNEND;
				end;
				
				if lFighter.nowlife ~= lFighter.Hp then
					local str = string.format("id=%d, Hp=%d nowLife=%d",lFighter:GetId(), lFighter.Hp,lFighter.nowlife)
					WriteCon(str);
				end;
			end;
		end;
	end
end

function p.getBuffStateMachine(id)
	local buffStateMachine = nil;
	if w_battle_mgr.atkCampType == W_BATTLE_HERO then
		lBuffMachineLst = p.heroBuffMachineLst;
	else
		lBuffMachineLst = p.enemyBuffMachineLst;
	end;
  
    for k,v in ipairs(lBuffMachineLst) do
		if v.id == id then
			buffStateMachine = v;
		end
	end
	
	if buffStateMachine ~= nil then
		if w_battle_mgr.NeedQuit == true then
			buffStateMachine:BuffEnd();
			buffStateMachine = nil;
		end;
	end;
	return buffStateMachine;	
end

function p.allBuffEnd()
	local lres = true;
	if w_battle_mgr.atkCampType == W_BATTLE_HERO then
		lBuffMachineLst = p.heroBuffMachineLst;
	else
		lBuffMachineLst = p.enemyBuffMachineLst;
	end;
	
    for k,v in ipairs(lBuffMachineLst) do
		if v:IsEnd() == false then
			lres = false;
			break;
		end;
	end	
	return lres;
end

function p.starBuffStateMachine()
	if w_battle_mgr.atkCampType == W_BATTLE_HERO then
		lBuffMachineLst = p.heroBuffMachineLst;
	else
		lBuffMachineLst = p.enemyBuffMachineLst;
	end;
	
	for k,v in ipairs(lBuffMachineLst) do
		v:ready();
	end
	
	for k,v in ipairs(lBuffMachineLst) do
		v:start();
	end
	
end