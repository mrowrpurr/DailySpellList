scriptName DailySpellList_MeditateEffect extends ActiveMagicEffect  

DailySpellList property SpellListMod auto

event OnEffectStart(Actor target, Actor caster)
    SpellListMod.CheckForNewPlayerSpells()
    SpellListMod.MeditateOnSpellList(castUsingSpell = true)
endEvent
