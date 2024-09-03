require('NPCs/MainCreationMethods');

function createTrait()
    TraitFactory.addTrait("Puppylike", getText("UI_trait_Puppylike"), -7, getText("UI_trait_Puppylikeheader")..getText("\n")..getText("UI_trait_Puppylikepoint1")..getText("\n")..getText("UI_trait_Puppylikepoint2")..getText("\n")..getText("UI_trait_Puppylikepoint3"), false, false);
end

Events.OnGameBoot.Add(createTrait)