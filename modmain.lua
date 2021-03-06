PrefabFiles = {"marketplace","goldfragment"}

Assets = {
	Asset("ATLAS","images/inventoryimages/goldfragment.xml"),
	Asset("IMAGE","images/inventoryimages/goldfragment.tex"),
}

		-- Code from TMI Items
	
		GLOBAL.require 'screens.marketscreen'
		IsHUDPaused = GLOBAL.IsPaused
		TheInput = GLOBAL.TheInput
		TheFrontEnd = GLOBAL.TheFrontEnd
		TheSim = GLOBAL.TheSim



		
		-- TMI Code Ends Here
		

		
		STRINGS = GLOBAL.STRINGS
        RECIPETABS = GLOBAL.RECIPETABS
        Recipe = GLOBAL.Recipe
        Ingredient = GLOBAL.Ingredient
        TECH = GLOBAL.TECH

		STRINGS.NAMES.GOLDNUGGET = "Gold Nugget"
		STRINGS.RECIPE_DESC.GOLDNUGGET = "Shiny!"
		

		local goldfragment = GLOBAL.Recipe("goldfragment",{ Ingredient("goldnugget", 1)},                     
        RECIPETABS.REFINE, TECH.NONE,nil,nil,nil,4)
        goldfragment.atlas = "images/inventoryimages/goldfragment.xml"
		goldfragment.texture = "images/inventoryimages/goldfragment.tex"

		
		local goldnugget = GLOBAL.Recipe("goldnugget",{ Ingredient("goldfragment", 4)},                     
        RECIPETABS.REFINE, TECH.NONE)
		--goldfragment.atlas = "images/inventoryimages/goldfragment.xml"
		
		
		local config_CraftingDifficulty  = GetModConfigData("recipeDifficulty")
		
		if config_CraftingDifficulty == "diffCheaty" then
		
		local marketplace = Recipe("marketplace",{ Ingredient("cutgrass", 1)},
		RECIPETABS.TOWN, TECH.NONE,"marketplace_placer")
		
		-- Cheaty recipe (used for debug)
		
			else if config_CraftingDifficulty == "diffEasy" then
		
		
				local marketplace = Recipe("marketplace",{ Ingredient("boards", 6),Ingredient("cutStone",4),Ingredient("pigSkin",6)},
				RECIPETABS.TOWN,TECH.SCIENCE_TWO,"marketplace_placer")
		
				--this recipe for easy
			
				else if config_CraftingDifficulty == "diffMedium" then
				
				local marketplace = Recipe("marketplace",{ Ingredient("boards", 12),Ingredient("cutStone",9),Ingredient("pigSkin",12)},
				RECIPETABS.TOWN,TECH.SCIENCE_TWO,"marketplace_placer")
				
				-- this recipe for medium
				
				else
				
					local marketplace = Recipe("marketplace",{ Ingredient("boards", 24),Ingredient("cutStone",18),Ingredient("pigSkin",24),Ingredient("goldNugget",10)},
					RECIPETABS.TOWN,TECH.SCIENCE_TWO,"marketplace_placer")
				
					-- this recipe for hard
				end
			end
		end