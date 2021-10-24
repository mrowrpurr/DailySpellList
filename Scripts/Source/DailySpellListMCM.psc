scriptName DailySpellListMCM extends SKI_ConfigBase

DailySpellList property SpellListMod auto

int oid_MinimumHours

int oid_PromptAfterSleep
int oid_PromptAfterWait
int oid_PromptAfterFastTravel

int oid_SpellPoints_Novice
int oid_SpellPoints_Apprentice
int oid_SpellPoints_Adept
int oid_SpellPoints_Expert
int oid_SpellPoints_Master

int oid_LevelUpDisplayInfo

int oid_MinimumMagicka
int oid_SpellPointsPerMagickaIncrease

int oid_SelectNoRestrictionSpells

event OnConfigInit()
    ModName = "Daily Spell List"
endEvent

event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("How long before spell list can be reset")
    oid_MinimumHours = AddSliderOption("Minimum hours", 24)
    AddEmptyOption()

    AddHeaderOption("When to prompt for meditation")
    oid_PromptAfterSleep = AddToggleOption("After sleeping (and minimum hours passed)", true)
    oid_PromptAfterWait = AddToggleOption("After waiting (and minimum hours passed)", true)
    oid_PromptAfterFastTravel = AddToggleOption("After fast travel (and minimum hours passed)", true)
    AddEmptyOption()

    AddHeaderOption("Spell Points Required Per Spell Level")
    oid_SpellPoints_Novice = AddSliderOption("Novice", 1)
    oid_SpellPoints_Apprentice = AddSliderOption("Apprentice", 2)
    oid_SpellPoints_Adept = AddSliderOption("Adept", 3)
    oid_SpellPoints_Expert = AddSliderOption("Expert", 4)
    oid_SpellPoints_Master = AddSliderOption("Master", 5)

    SetCursorPosition(1)

    AddHeaderOption("Level Up Display")
    oid_LevelUpDisplayInfo = AddToggleOption("Display Spell Point Info on Level-Up", true)
    AddEmptyOption()

    AddHeaderOption("Spell Point Magicka Requirements")
    oid_MinimumMagicka = AddSliderOption("Minimum Magicka required to cast spells", 90)
    oid_SpellPointsPerMagickaIncrease = AddSliderOption("Spell Points obtained per Magicka increase", 1)
    AddEmptyOption()

    AddHeaderOption("Spells that can be cast without restriction")
    oid_SelectNoRestrictionSpells = AddMenuOption("Select spells", "CHOOSE SPELL")
endEvent

event OnOptionHighlight(int optionId)
    if optionId == oid_MinimumHours
        SetInfoText("The minimum number of hours you must wait until you can meditate again after meditating")
    elseIf optionId == oid_PromptAfterSleep
        SetInfoText("If selected, you will be prompted to meditate on your spell list after you wake up (if the minimum number of hours have passed)")
    elseIf optionId == oid_PromptAfterWait
        SetInfoText("If selected, you will be prompted to meditate on your spell list after you wait (if the minimum number of hours have passed)")
    elseIf optionId == oid_PromptAfterFastTravel
        SetInfoText("If selected, you will be prompted to meditate on your spell list after you fast travel (if the minimum number of hours have passed)")
    elseIf optionId == oid_SpellPoints_Novice
        SetInfoText("Sets the number of spell points required to cast a Novice spell")
    elseIf optionId == oid_SpellPoints_Apprentice
        SetInfoText("Sets the number of spell points required to cast an Apprentice spell")
    elseIf optionId == oid_SpellPoints_Adept
        SetInfoText("Sets the number of spell points required to cast an Adept spell")
    elseIf optionId == oid_SpellPoints_Expert
        SetInfoText("Sets the number of spell points required to cast an Expert spell")
    elseIf optionId == oid_SpellPoints_Master
        SetInfoText("Sets the number of spell points required to cast a Master spell")
    elseIf optionId == oid_LevelUpDisplayInfo
        SetInfoText("When checked, whenever you increase your Magicka score when leveling up, you will be shown a message with your new total available spell points")
    elseIf optionId == oid_MinimumMagicka
        SetInfoText("The minimum amount of Magicka required to be eligible for gaining spell points. For example: by default, this is 90. This means that you have 1 spell point once your Magicka is 100. You may want to adjust this if you configure your starting character to have less than 100 starting Magicka.")
    elseIf optionId == oid_SpellPointsPerMagickaIncrease
        SetInfoText("Sets the number of spell points which are added for every 10x Magicka points")
    elseIf optionId == oid_SelectNoRestrictionSpells
        SetInfoText("Use to add spells which Daily Spell List ignores and will not be restricted")
    endIf
endEvent
