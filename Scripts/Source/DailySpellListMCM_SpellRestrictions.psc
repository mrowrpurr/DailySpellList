scriptName DailySpellListMCM_SpellRestrictions
{'Spell Restrictions' page of the Mod Configuration Menu}

function Render(DailySpellListMCM mcm) global
    mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
    LeftColumn(mcm)
    mcm.SetCursorPosition(1)
    RightColumn(mcm)
endFunction

function LeftColumn(DailySpellListMCM mcm) global
    mcm.AddHeaderOption("Spells that can be cast without restriction")
    mcm.oid_SelectNoRestrictionSpells = mcm.AddMenuOption("Select spells", "CHOOSE SPELL")

    int i = 0
    while i < mcm.SpellListMod.UnrestrictedSpells.Length && i < (64 - 9) ; Right column has 64 items, minus the 9 used
        int oid = mcm.AddTextOption("", mcm.SpellListMod.UnrestrictedSpells[i].GetName())
        if mcm.UnrestrictedSpellOptionIDs
            mcm.UnrestrictedSpellOptionIDs = Utility.ResizeIntArray(mcm.UnrestrictedSpellOptionIDs, mcm.UnrestrictedSpellOptionIDs.Length + 1)
            mcm.UnrestrictedSpellOptionIDs[mcm.UnrestrictedSpellOptionIDs.Length - 1] = oid
        else
            mcm.UnrestrictedSpellOptionIDs = new int[1]
            mcm.UnrestrictedSpellOptionIDs[0] = oid
        endIf
        i += 1
    endWhile
endFunction

function RightColumn(DailySpellListMCM mcm) global
    mcm.AddHeaderOption("Manually added custom spells to restrict")
    mcm.oid_SelectCustomRestrictionSpells = mcm.AddMenuOption("Select spells", "CHOOSE SPELL")

    int i = 0
    while i < mcm.CustomRestrictedSpells.Length && i < (64 - 9) ; Right column has 64 items, minus the 9 used
        int oid = mcm.AddTextOption("", mcm.CustomRestrictedSpells[i].GetName())
        if mcm.CustomRestrictedSpellOptionIDs
            mcm.CustomRestrictedSpellOptionIDs = Utility.ResizeIntArray(mcm.CustomRestrictedSpellOptionIDs, mcm.CustomRestrictedSpellOptionIDs.Length + 1)
            mcm.CustomRestrictedSpellOptionIDs[mcm.CustomRestrictedSpellOptionIDs.Length - 1] = oid
        else
            mcm.CustomRestrictedSpellOptionIDs = new int[1]
            mcm.CustomRestrictedSpellOptionIDs[0] = oid
        endIf
        i += 1
    endWhile
endFunction
