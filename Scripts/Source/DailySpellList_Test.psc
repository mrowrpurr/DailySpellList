scriptName DailySpellList_Test extends ActiveMagicEffect  

event OnEffectStart(Actor target, Actor caster)
    DailySpellList modQuest = Game.GetFormFromFile(0x800, "DailySpellList.esp") as DailySpellList
    modQuest.OpenSpellPreparationMenu()
endEvent
