require "prefabutil"
local screen
local pigHouses = 0
local PIGHOUSERADIUS = 100    

STRINGS.NAMES.MARKETPLACE = "Marketplace"
STRINGS.RECIPE_DESC.MARKETPLACE = "The pigman market!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MARKETPLACE = "Should I say hi?"

local assets=
{
	Asset("ANIM", "anim/pig_king.zip"),
	Asset("SOUND", "sound/pig.fsb"),
}

local slotpos = {}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
	end
end


local prefabs = 
{
	"goldnugget",
}

local function OnGetItemFromPlayer(inst, giver, item)
 --print("get item from player")
end

local function onopen(inst)
	local player = GetPlayer()
	updatePigHouses(inst)
	--print("Pig Houses : "..pigHouses)
	if (pigHouses >=  tonumber(GetModConfigData("pigHouse", KnownModIndex:GetModActualName("Pigman Marketplace")))) then
		screen = MarketScreen(player)
		TheFrontEnd:PushScreen(screen)
	else if pigHouses == 0 then
				player.components.talker:Say("I think he needs friends.")
			else
				player.components.talker:Say("I think he needs more friends.")
		end
	end
	--stuff when chest is being opened
end



local function onclose(inst)
	if screen == nil then
	
	else
	screen:Accept()
	end
	-- stuff when chest is being closed
end



local function cantakeitem(inst, item, slot)
	return false;
	-- return item.prefab == "goldnugget"
end


local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.components.container:DropEverything()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function onhit(inst, worker)
	inst.components.container:Close()
end

function updatePigHouses(inst)
	pigHouses = 0
		local pt = Vector3(inst.Transform:GetWorldPosition())
		local entities = TheSim:FindEntities(pt.x,pt.y,pt.z, PIGHOUSERADIUS)
		--print("Number of Entities"..#entities)
		for k,v in pairs(entities) do
			if v.prefab == "pighouse" then
				pigHouses = pigHouses + 1
			end
		end
end

local function fn(Sim)
    
	local inst = CreateEntity()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetPriority( 5 )
	minimap:SetIcon( "pigking.png" )
	minimap:SetPriority( 1 )

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize( 10, 5 )
    
    MakeObstaclePhysics(inst, 1.5)
    --inst.Transform:SetScale(1.5,1.5,1.5)
    
    inst:AddTag("structure")
    inst.AnimState:SetBank("Pig_King")
    inst.AnimState:SetBuild("Pig_King")
    inst.AnimState:PlayAnimation("idle", true)
    
    inst:AddComponent("inspectable")

	inst:AddComponent("container")

	inst.components.container:SetNumSlots(#slotpos)
	
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
		
	inst.components.container.widgetslotpos = slotpos
	
	-- will need to change this for when the buying mechanic is in
	
	
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.side_align_tip = 160	
	inst.components.container.acceptsstacks = true
	inst.components.container.type = "market"
	inst.components.container.itemtestfn = cantakeitem
	inst.components.container.widgetpos = Vector3(-40000,0,0)
	
	


	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit) 
	
	if IsDLCEnabled(REIGN_OF_GIANTS) == "enabled" then 
		MakeLargeBurnable(inst, nil, nil, true)
		MakeLargePropagator(inst)

		inst.OnSave = onsave 
		inst.OnLoad = onload
	end
	
	
	
	inst:ListenForEvent( "nighttime", function(global, data)  
        inst.AnimState:PlayAnimation("sleep_pre")
        inst.AnimState:PushAnimation("sleep_loop", true)    
    end, GetWorld())
    
	inst:ListenForEvent( "daytime", function(global, data)
        inst.AnimState:PlayAnimation("sleep_pst")
        inst.AnimState:PushAnimation("idle", true)    
    end, GetWorld())
    
	
	
	
    return inst
end

return Prefab( "common/objects/marketplace", fn, assets, prefabs),
MakePlacer("common/objects/marketplace_placer", "marketplace", "marketplace", "idle")
	