local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local goldAmount
local itemAmount

local ItemTile = Class(Widget, function(self, invitem,owner,screen)
    Widget._ctor(self, "ItemTile")
	self.item = invitem -- can be nil
	self.owner = owner
	self.screen = screen
	self.goldAmount = 1
	self.itemAmount = 1
	

	if invitem == "emptySpace" then
		self:Hide()
		--Do emptySpace stuff
		return
	end
	
	-- NOT SURE WAHT YOU WANT HERE
	if invitem.components.inventoryitem == nil then
		print("NO INVENTORY ITEM COMPONENT"..tostring(invitem.prefab), invitem, owner)
		return
	end
	
--	self.bg = self:AddChild(Image())
--	self.bg:SetTexture(HUD_ATLAS, "inv_slot_spoiled.tex")
--	self.bg:Hide()
--	self.bg:SetClickable(false)
--	

	--print(self.screen)
	if self.screen:isSelling() then

	self.spoilage = self:AddChild(UIAnim())
	self.spoilage:GetAnimState():SetBank("spoiled_meter")
	self.spoilage:GetAnimState():SetBuild("spoiled_meter")
	self.spoilage:Show()
	self.spoilage:GetAnimState():SetPercent("anim", 0)
	end
--    self.spoilage:Hide()
--    self.spoilage:SetClickable(false)
	
	self.image = self:AddChild(Image(invitem.components.inventoryitem:GetAtlas(), invitem.components.inventoryitem:GetImage()))
	
    --self.image:SetClickable(false)
	
--    local owner = self.item.components.inventoryitem.owner
--    
--    if self.item.prefab == "spoiled_food" or (self.item.components.edible and self.item.components.perishable) then
--		self.bg:Show( )
--	end
--	
--	if self.item.components.perishable and self.item.components.edible then
--		self.spoilage:Show()
--	end
--
--    self.inst:ListenForEvent("imagechange", function() 
--        self.image:SetTexture(invitem.components.inventoryitem:GetAtlas(), invitem.components.inventoryitem:GetImage())
--    end, invitem)
--    
--    self.inst:ListenForEvent("stacksizechange",
--            function(inst, data)
--                if invitem.components.stackable then
--                
--					if data.src_pos then
--						local dest_pos = self:GetWorldPosition()
--						local im = Image(invitem.components.inventoryitem:GetAtlas(), invitem.components.inventoryitem:GetImage())
--						im:MoveTo(data.src_pos, dest_pos, .3, function() 
--							self:SetQuantity(invitem.components.stackable:StackSize())
--							self:ScaleTo(2, 1, .25)
--							im:Kill() end)
--					else
--	                    self:SetQuantity(invitem.components.stackable:StackSize())
--						self:ScaleTo(2, 1, .25)
--					end
--                end
--            end, invitem)
--
--
--    if invitem.components.stackable then
--        self:SetQuantity(invitem.components.stackable:StackSize())
--    end
--
--    self.inst:ListenForEvent("percentusedchange",
--            function(inst, data)
--                self:SetPercent(data.percent)
--            end, invitem)
--    self.inst:ListenForEvent("perishchange",
--            function(inst, data)
--                self:SetPerishPercent(data.percent)
--            end, invitem)
--
--    if invitem.components.fueled then
--        self:SetPercent(invitem.components.fueled:GetPercent())
--    end
--
--    if invitem.components.finiteuses then
--        self:SetPercent(invitem.components.finiteuses:GetPercent())
--    end
--
--    if invitem.components.perishable then
--        self:SetPerishPercent(invitem.components.perishable:GetPercent())
--    end
--    
--    
--    if invitem.components.armor then
--        self:SetPercent(invitem.components.armor:GetPercent())
--    end
	
	
	local itemData = (GetModConfigData(invitem.prefab, KnownModIndex:GetModActualName("Pigman Marketplace"))) or "noTrade"

	if itemData ~= "noTrade" then
		 self.goldAmount, self.itemAmount = string.match(itemData, '(%d+)Gfor(%d+)')
	end
	
	print("Item: "..invitem.prefab.." Cost: "..self.goldAmount.." For "..self.itemAmount)
	
	self:SetQuantity(self.itemAmount)
end)

function ItemTile:OnControl(control, down)
    self:UpdateTooltip()
    return false
end

function ItemTile:UpdateTooltip()
	local str = self:GetDescriptionString()
	self:SetTooltip(str)
end

function ItemTile:GetDescriptionString()
    local str = nil
    local in_equip_slot = self.item and self.item.components.equippable and self.item.components.equippable:IsEquipped()

	
	local active_item = self.owner.components.inventory:GetActiveItem()
    if self.item and self.item.components.inventoryitem then

        local adjective = self.item:GetAdjective()
        
        if adjective then
            str = adjective .. " " .. self.item:GetDisplayName()
        else
            str = self.item:GetDisplayName()
        end

--        if active_item then 
--            
--            if not in_equip_slot then
--                str = str .. "\n" .. STRINGS.LMB .. ": " .. STRINGS.SWAP
--            end 
--            
--            local actions = GetPlayer().components.playeractionpicker:GetUseItemActions(self.item, active_item, true)
--            if actions then
--                str = str.."\n" .. STRINGS.RMB .. ": " .. actions[1]:GetActionString()
--            end
--        else
--            
--            --self.namedisp:SetHAlign(ANCHOR_LEFT)
--            local owner = self.item.components.inventoryitem and self.item.components.inventoryitem.owner
--            local actionpicker = owner and owner.components.playeractionpicker or GetPlayer().components.playeractionpicker
--            local inventory = owner and owner.components.inventory or GetPlayer().components.inventory
--            if owner and inventory and actionpicker then
--            
--                if TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) then
--                    str = str .. "\n" .. STRINGS.LMB .. ": " .. STRINGS.INSPECTMOD
--                elseif TheInput:IsControlPressed(CONTROL_FORCE_TRADE) then
--                    str = str .. "\n" .. STRINGS.LMB .. ": " .. ( (TheInput:IsControlPressed(CONTROL_FORCE_STACK) and self.item.components.stackable) and (STRINGS.STACKMOD .. " " ..STRINGS.TRADEMOD) or STRINGS.TRADEMOD)
--                elseif TheInput:IsControlPressed(CONTROL_FORCE_STACK) and self.item.components.stackable then
--                    str = str .. "\n" .. STRINGS.LMB .. ": " .. STRINGS.STACKMOD
--                end
--
--                local actions = nil
--                if inventory:GetActiveItem() then
--                    actions = actionpicker:GetUseItemActions(self.item, inventory:GetActiveItem(), true)
--                end
--                
--                if not actions then
--                    actions = actionpicker:GetInventoryActions(self.item)
--                end
--                
--                if actions then
--                    str = str.."\n" .. STRINGS.RMB .. ": " .. actions[1]:GetActionString()
--                end
--
--            end
--        end
    end
	--print(goldAmount)
	if self.screen:isSelling() then
		if self.goldAmount == "1" then
			str = str.." (Costs "..self.goldAmount.." Gold Nugget)"
		else
			str = str.." (Costs "..self.goldAmount.." Gold Nuggets)"
		end
		return str or ""
    else
		local sellValue = self.goldAmount*tonumber(GetModConfigData("sellValue", KnownModIndex:GetModActualName("Pigman Marketplace")))
		if tonumber(sellValue) == 1 then
			str = str.." (Sells for "..sellValue.." Gold Nugget)"
		else

			if math.floor(sellValue) == 0 then
				str = str.." (Sells for "..((sellValue-math.floor(sellValue))/0.25).." Gold Fragments.)"
			else
				if ((sellValue-math.floor(sellValue))/0.25) == 0 then
					str = str.." (Sells for "..math.floor(sellValue).." Gold Nuggets.)"
				else
					str = str.." (Sells for "..math.floor(sellValue).." Gold Nuggets, "..((sellValue-math.floor(sellValue))/0.25).." Gold Fragments.)"
				end
			end	
		end
		return str or ""
	end
end

function ItemTile:GoldToString(goldNumber)

end

function ItemTile:OnGainFocus()
    self:UpdateTooltip()
end

function ItemTile:SetQuantity(quantity)
--	print("Quantity function called")
	
		if not self.quantity then
			self.quantity = self:AddChild(Text(NUMBERFONT, 42))
			self.quantity:SetPosition(2,16,0)
		end
	self.quantity:SetString(tostring(quantity))
	
end

function ItemTile:SetPerishPercent(percent)
	if self.item.components.perishable then
		self.spoilage:GetAnimState():SetPercent("anim", 1-self.item.components.perishable:GetPercent())
	end
end

function ItemTile:SetPercent(percent)
    --if not self.item.components.stackable then
        
	if not self.percent then
		self.percent = self:AddChild(Text(NUMBERFONT, 42))
		self.percent:SetPosition(5,-32+15,0)
	end
    local val_to_show = percent*100
    if val_to_show > 0 and val_to_show < 1 then
        val_to_show = 1
    end
	self.percent:SetString(string.format("%2.0f%%", val_to_show))
        
    --end
end

--[[
function ItemTile:CancelDrag()
    self:StopFollowMouse()
    
    if self.item.prefab == "spoiled_food" or (self.item.components.edible and self.item.components.perishable) then
		self.bg:Show( )
	end
	
	if self.item.components.perishable and self.item.components.edible then
		self.spoilage:Show()
	end
	
	self.image:SetClickable(true)

    
end
--]]

function ItemTile:StartDrag()
    --self:SetScale(1,1,1)
    self.spoilage:Hide()
    self.bg:Hide( )
    self.image:SetClickable(false)
end



return ItemTile
