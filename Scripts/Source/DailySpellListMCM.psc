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

    AddHeaderOption("Spell Points Required Per Spell Level")
    AddSliderOption("Novice", 1)
    AddSliderOption("Apprentice", 2)
    AddSliderOption("Adept", 3)
    AddSliderOption("Expert", 4)
    AddSliderOption("Master", 5)
    AddEmptyOption()

    AddHeaderOption("Spell Options")
    AddToggleOption("Restrict Racial Spells", true)
    AddEmptyOption()

    AddHeaderOption("Spell Points Obtained Per 10x Magicka")
    AddSliderOption("Minimum Magicka required to cast spells", 100)
    AddSliderOption("Spell Points Obtained Per Magicka Increase", 1)
    AddSliderOption("Magicka Increase Size", 1)

    SetCursorPosition(1)

    AddHeaderOption("Spells Without Restrictions")
    AddMenuOption("Select spells", "CHOOSE SPELL")
endEvent
