scriptName DailySpellListMCM extends SKI_ConfigBase

DailySpellList property SpellListMod auto

event OnConfigInit()
    ModName = "Daily Spell List"
endEvent

event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)


    AddHeaderOption("How long before spell list can be reset")
    AddSliderOption("Minimum hours", 24)
    AddEmptyOption()

    AddHeaderOption("Prompt for new spell list:")
    AddToggleOption("After sleeping (and minimum hours passed)", true)
    AddToggleOption("After waiting (and minimum hours passed)", true)
    AddToggleOption("After fast travel (and minimum hours passed)", true)
    AddEmptyOption()

    SetCursorPosition(1)

    AddHeaderOption("Spells Without Restrictions")
    AddMenuOption("Select spells", "CHOOSE SPELL")
endEvent
