PrefabFiles = {"marketplace"}
		-- Code from TMI Items
	
		GLOBAL.require 'screens.tmiscreen'
		GetPlayer = GLOBAL.GetPlayer
		IsHUDPaused = GLOBAL.IsPaused
		TheInput = GLOBAL.TheInput
		TheFrontEnd = GLOBAL.TheFrontEnd
		TheSim = GLOBAL.TheSim
		
		
	


		
		-- TMI Code Ends Here
		
		--Allows the config options to be read anywhere this environment is loaded (Isn't working)
		--GLOBAL.package.loaded["marketplace.modenv"] = env
		
		STRINGS = GLOBAL.STRINGS
        RECIPETABS = GLOBAL.RECIPETABS
        Recipe = GLOBAL.Recipe
        Ingredient = GLOBAL.Ingredient
        TECH = GLOBAL.TECH

        STRINGS.NAMES.MARKETPLACE = "Marketplace"
		
        STRINGS.RECIPE_DESC.MARKETPLACE = "The pigman market!"
		
        STRINGS.CHARACTERS.GENERIC.DESCRIBE.MARKETPLACE = "Should I say hi?"
		
	
		local config_CraftingDifficulty  = GetModConfigData("recipeDifficulty")
		
		if config_CraftingDifficulty == "diffCheaty" then
		
		local marketplace = Recipe("marketplace",{ Ingredient("cutgrass", 1)},
		RECIPETABS.TOWN, TECH.NONE,"marketplace_placer")
		
		-- Cheaty recipe
		
			else if config_CraftingDifficulty == "diffEasy" then
		
		
				local marketplace = Recipe("marketplace",{ Ingredient("boards", 12),Ingredient("cutStone",9),Ingredient("pigSkin",12)},
				RECIPETABS.TOWN, TECH.NONE,"marketplace_placer")
		
				--this recipe for easy
			
				else 
				
				local marketplace = Recipe("marketplace",{ Ingredient("boards", 24),Ingredient("cutStone",18),Ingredient("pigSkin",24),Ingredient("goldNugget",10)},
				RECIPETABS.TOWN, TECH.NONE,"marketplace_placer")
				
				-- this recipe for hard
			end
		end