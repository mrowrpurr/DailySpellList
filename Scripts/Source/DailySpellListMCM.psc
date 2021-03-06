scriptName DailySpellListMCM extends SKI_ConfigBase

DailySpellList property SpellListMod auto

int property oid_MinimumHours auto
int property oid_PromptAfterSleep auto
int property oid_PromptAfterWait auto
int property oid_PromptAfterFastTravel auto
int property oid_SpellPoints_Novice auto
int property oid_SpellPoints_Apprentice auto
int property oid_SpellPoints_Adept auto
int property oid_SpellPoints_Expert auto
int property oid_SpellPoints_Master auto
int property oid_LevelUpDisplayInfo auto
int property oid_MinimumMagicka auto
int property oid_SpellPointsPerMagickaIncrease auto
int property oid_MagickaIncreaseSize auto
int property oid_SelectNoRestrictionSpells auto
int property oid_SelectCustomRestrictionSpells auto
Form[] property CurrentUnpreparedSpellList auto
Form[] property CurrentUnmanagedSpellList auto
int[] property UnrestrictedSpellOptionIDs auto
int[] property CustomRestrictedSpellOptionIDs auto

event OnConfigInit()
    ModName = "Daily Spell List"
    Pages = new string[2]
    Pages[0] = "Settings"
    Pages[1] = "Spell Restrictions"
endEvent

event OnPageReset(string page)
    if page == "Spell Restrictions"
        DailySpellListMCM_SpellRestrictions.Render(self)
    else
        RenderSettingsPage()
    endIf
endEvent

function RenderSettingsPage()
    UnrestrictedSpellOptionIDs = new int[1]

    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("How long before spell list can be reset")
    oid_MinimumHours = AddSliderOption("Minimum hours", SpellListMod.DailySpellList_MinHours.Value as int)
    AddEmptyOption()

    AddHeaderOption("When to prompt for meditation")
    oid_PromptAfterSleep = AddToggleOption("After sleeping (and minimum hours passed)", SpellListMod.DailySpellList_SleepPrompt.Value > 0)
    oid_PromptAfterWait = AddToggleOption("After waiting (and minimum hours passed)", SpellListMod.DailySpellList_WaitPrompt.Value > 0)
    oid_PromptAfterFastTravel = AddToggleOption("After fast travel (and minimum hours passed)", SpellListMod.DailySpellList_TravelPrompt.Value > 0)
    AddEmptyOption()

    AddHeaderOption("Spell Points Required Per Spell Level")
    oid_SpellPoints_Novice = AddSliderOption("Novice", SpellListMod.DailySpellList_PointsRequired_Novice.Value)
    oid_SpellPoints_Apprentice = AddSliderOption("Apprentice", SpellListMod.DailySpellList_PointsRequired_Apprentice.Value)
    oid_SpellPoints_Adept = AddSliderOption("Adept", SpellListMod.DailySpellList_PointsRequired_Adept.Value)
    oid_SpellPoints_Expert = AddSliderOption("Expert", SpellListMod.DailySpellList_PointsRequired_Expert.Value)
    oid_SpellPoints_Master = AddSliderOption("Master", SpellListMod.DailySpellList_PointsRequired_Master.Value)

    SetCursorPosition(1)

    AddHeaderOption("Level Up Display")
    oid_LevelUpDisplayInfo = AddToggleOption("Display Spell Point Info on Level-Up", true)
    AddEmptyOption()

    AddHeaderOption("Spell Point Magicka Requirements")
    oid_MinimumMagicka = AddSliderOption("Minimum Magicka required to cast spells", SpellListMod.DailySpellList_MinSpellCastingMagicka.Value)
    oid_MagickaIncreaseSize = AddSliderOption("Magicka points which count as an increase", SpellListMod.DailySpellList_PointsEarnedInterval.Value)
    oid_SpellPointsPerMagickaIncrease = AddSliderOption("Spell Points obtained per Magicka increase", SpellListMod.DailySpellList_PointsEarnedValue.Value)
    AddEmptyOption()
endFunction

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
        SetInfoText("Sets the number of spell points which are added for every Magicka increase")
    elseIf optionId == oid_SelectNoRestrictionSpells
        SetInfoText("Use to add spells which Daily Spell List ignores and will not be restricted")
    elseIf optionId == oid_MagickaIncreaseSize
        SetInfoText("Sets the amount of Magicka which count as an increase in Magicka and result in more spell points being added. Provided for mods which increase Magicka in increments other than 10.")
    endIf
endEvent

event OnOptionSliderOpen(int optionId)
    if optionId == oid_MinimumHours
        SetSliderDialogRange(0, 24 * 7)
        SetSliderDialogStartValue(SpellListMod.DailySpellList_MinHours.Value)
    elseIf optionId == oid_MinimumMagicka
        SetSliderDialogRange(0, 500)
        SetSliderDialogStartValue(SpellListMod.DailySpellList_MinSpellCastingMagicka.Value)
    elseIf optionId == oid_SpellPointsPerMagickaIncrease
        SetSliderDialogRange(1, 100)
        SetSliderDialogStartValue(SpellListMod.DailySpellList_PointsEarnedValue.Value)
    elseIf optionId == oid_MagickaIncreaseSize
        SetSliderDialogRange(1, 100)
        SetSliderDialogStartValue(SpellListMod.DailySpellList_PointsEarnedInterval.Value)
    else
        SetSliderDialogRange(0, 100)
        if optionId == oid_SpellPoints_Novice
            SetSliderDialogStartValue(SpellListMod.DailySpellList_PointsRequired_Novice.Value)
        elseIf optionId == oid_SpellPoints_Apprentice
            SetSliderDialogStartValue(SpellListMod.DailySpellList_PointsRequired_Apprentice.Value)
        elseIf optionId == oid_SpellPoints_Adept
            SetSliderDialogStartValue(SpellListMod.DailySpellList_PointsRequired_Adept.Value)
        elseIf optionId == oid_SpellPoints_Expert
            SetSliderDialogStartValue(SpellListMod.DailySpellList_PointsRequired_Expert.Value)
        elseIf optionId == oid_SpellPoints_Master
            SetSliderDialogStartValue(SpellListMod.DailySpellList_PointsRequired_Master.Value)
        endIf
    endIf
endEvent

event OnOptionSliderAccept(int optionId, float value)
    SetSliderOptionValue(optionId, value)
    if optionId == oid_MinimumHours
        SpellListMod.DailySpellList_MinHours.Value = value
    elseIf optionId == oid_SpellPoints_Novice
        SpellListMod.DailySpellList_PointsRequired_Novice.Value = value
    elseIf optionId == oid_SpellPoints_Apprentice
        SpellListMod.DailySpellList_PointsRequired_Apprentice.Value = value
    elseIf optionId == oid_SpellPoints_Adept
        SpellListMod.DailySpellList_PointsRequired_Adept.Value = value
    elseIf optionId == oid_SpellPoints_Expert
        SpellListMod.DailySpellList_PointsRequired_Expert.Value = value
    elseIf optionId == oid_SpellPoints_Master
        SpellListMod.DailySpellList_PointsRequired_Master.Value = value
    elseIf optionId == oid_MinimumMagicka
        SpellListMod.DailySpellList_MinSpellCastingMagicka.Value = value
    elseIf optionId == oid_SpellPointsPerMagickaIncrease
        SpellListMod.DailySpellList_PointsEarnedValue.Value = value
    elseIf optionId == oid_MagickaIncreaseSize
        SpellListMod.DailySpellList_PointsEarnedInterval.Value = value
    endIf
endEvent

event OnOptionSelect(int optionId)
    if optionId == oid_PromptAfterSleep
        if SpellListMod.DailySpellList_SleepPrompt.Value > 0
            SpellListMod.DailySpellList_SleepPrompt.Value = 0
            SetToggleOptionValue(optionId, false)
        else
            SpellListMod.DailySpellList_SleepPrompt.Value = 1
            SetToggleOptionValue(optionId, true)
            SpellListMod.DailySpellList_PlayerReferenceAlias.ListenForSleep()
        endIf
    elseIf optionId == oid_PromptAfterWait
        if SpellListMod.DailySpellList_WaitPrompt.Value > 0
            SpellListMod.DailySpellList_WaitPrompt.Value = 0
            SetToggleOptionValue(optionId, false)
            SpellListMod.DailySpellList_PlayerReferenceAlias.StopListeningForWait()
        else
            SpellListMod.DailySpellList_WaitPrompt.Value = 1
            SetToggleOptionValue(optionId, true)
            SpellListMod.DailySpellList_PlayerReferenceAlias.ListenForWait()
        endIf
    elseIf optionId == oid_PromptAfterFastTravel
        if SpellListMod.DailySpellList_TravelPrompt.Value > 0
            SpellListMod.DailySpellList_TravelPrompt.Value = 0
            SetToggleOptionValue(optionId, false)
        else
            SpellListMod.DailySpellList_TravelPrompt.Value = 1
            SetToggleOptionValue(optionId, true)
        endIf
    elseIf optionId == oid_LevelUpDisplayInfo
        if SpellListMod.DailySpellList_LevelUpDisplay.Value > 0
            SpellListMod.DailySpellList_LevelUpDisplay.Value = 0
            SetToggleOptionValue(optionId, false)
        else
            SpellListMod.DailySpellList_LevelUpDisplay.Value = 1
            SetToggleOptionValue(optionId, true)
        endIf
    else
        int unrestrictedOptionIdIndex = UnrestrictedSpellOptionIDs.Find(optionId)
        if unrestrictedOptionIdIndex > -1
            Form theSpell = SpellListMod.UnrestrictedSpells[unrestrictedOptionIdIndex - 1]
            if ShowMessage("Are you sure you would like to remove " + theSpell.GetName() + " as an unrestricted spell?")
                SpellListMod.UnrestrictedSpells = SpellListMod.RemoveElement(SpellListMod.UnrestrictedSpells, theSpell)
                if SpellListMod.PlayerRef.HasSpell(theSpell as Spell)
                    SpellListMod.AddUnlearnedSpell(theSpell as Spell)
                endIf
                ForcePageReset()
            endIf
        endIf
    endIf
endEvent

event OnOptionMenuOpen(int optionId)
    if optionId == oid_SelectNoRestrictionSpells
        CurrentUnpreparedSpellList = SpellListMod.GetPlayerManagedSpells()
        SetMenuDialogOptions(GetFormNamesAsArray(CurrentUnpreparedSpellList))
    elseIf optionId == oid_SelectCustomRestrictionSpells
        CurrentUnmanagedSpellList = SpellListMod.GetPlayerUnmanagedSpells()
        SetMenuDialogOptions(GetFormNamesAsArray(CurrentUnmanagedSpellList))
    endIf
endEvent

event OnOptionMenuAccept(int optionId, int index)
    if index == -1
        return
    endIf
    if optionId == oid_SelectNoRestrictionSpells
        Form theSpell = CurrentUnpreparedSpellList[index]
        if SpellListMod.UnrestrictedSpells
            SpellListMod.UnrestrictedSpells = Utility.ResizeFormArray(SpellListMod.UnrestrictedSpells, SpellListMod.UnrestrictedSpells.Length + 1)
            SpellListMod.UnrestrictedSpells[SpellListMod.UnrestrictedSpells.Length - 1] = theSpell
        else
            SpellListMod.UnrestrictedSpells = new Form[1]
            SpellListMod.UnrestrictedSpells[0] = theSpell
        endIf
        string spellLevel = SpellListMod.GetSpellLevel(theSpell as Spell)
        if spellLevel == "Novice"
            SpellListMod.UnpreparedSpells_Novice = SpellListMod.RemoveElement(SpellListMod.UnpreparedSpells_Novice, theSpell)
        elseIf spellLevel == "Apprentice"
            SpellListMod.UnpreparedSpells_Apprentice = SpellListMod.RemoveElement(SpellListMod.UnpreparedSpells_Apprentice, theSpell)
        elseIf spellLevel == "Adept"
            SpellListMod.UnpreparedSpells_Adept = SpellListMod.RemoveElement(SpellListMod.UnpreparedSpells_Adept, theSpell)
        elseIf spellLevel == "Expert"
            SpellListMod.UnpreparedSpells_Expert = SpellListMod.RemoveElement(SpellListMod.UnpreparedSpells_Expert, theSpell)
        elseIf spellLevel == "Master"
            SpellListMod.UnpreparedSpells_Master = SpellListMod.RemoveElement(SpellListMod.UnpreparedSpells_Master, theSpell)
        endIf
        if ! SpellListMod.PlayerRef.HasSpell(theSpell as Spell)
            SpellListMod.PlayerRef.AddSpell(theSpell as Spell, abVerbose = false)
        endIf
        ForcePageReset()
    elseIf optionId == oid_SelectCustomRestrictionSpells
        Form theSpell = CurrentUnmanagedSpellList[index]
        SpellListMod.CustomRestrictedSpells = SpellListMod.AddElement(SpellListMod.CustomRestrictedSpells, theSpell)
        string levelFromPerk = SpellListMod.GetSpellPerkLevel((theSpell as Spell).GetPerk())
        if ! levelFromPerk
            levelFromPerk = "Novice"
        endIf
        SpellListMod.AddUnlearnedSpell(theSpell as Spell, force = true, level = levelFromPerk)
        ForcePageReset()
    endIf
endEvent

string[] function GetFormNamesAsArray(Form[] theArray)
    string[] names = Utility.CreateStringArray(theArray.Length)
    int i = 0
    while i < names.Length
        names[i] = theArray[i].GetName()
        i += 1
    endWhile
    return names
endFunction

