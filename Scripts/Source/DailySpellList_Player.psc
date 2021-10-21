scriptName DailySpellList_Player extends ReferenceAlias

DailySpellList property SpellListMod auto

event OnInit()
    SpellListMod = GetOwningQuest() as DailySpellList
    ListenForEvents()
endEvent

event OnPlayerLoadGame()
    ListenForEvents()
endEvent

function ListenForEvents()
    ListenForSleep()
    ListenForWait()
    ListenForNewSpellLearned()
endFunction

function ListenForSleep()
    if SpellListMod.DailySpellList_SleepPrompt.Value > 0
        RegisterForSleep()
    endIf
endFunction

function ListenForWait()
    if SpellListMod.DailySpellList_WaitPrompt.Value > 0
        RegisterForMenu("Sleep/Wait Menu")
    endIf
endFunction

function ListenForNewSpellLearned()
    PO3_Events_Alias.RegisterForSpellLearned(self)
endFunction

event OnSleepStop(bool interrupted)
    if SpellListMod.DailySpellList_SleepPrompt.Value > 0 && SpellListMod.CanPrepareNewSpellList
        SpellListMod.MeditateOnSpellList()
    endIf
endEvent

event OnPlayerFastTravelEnd(float travelTime)
    if SpellListMod.DailySpellList_TravelPrompt.Value > 0 && SpellListMod.CanPrepareNewSpellList
        SpellListMod.MeditateOnSpellList()
    endIf
endEvent

event OnMenuClose(string menuName)
    if menuName == "Sleep/Wait Menu" && SpellListMod.DailySpellList_WaitPrompt.Value > 0 && SpellListMod.CanPrepareNewSpellList
        SpellListMod.MeditateOnSpellList()
    endIf
endEvent

; TODO TODO TODO
event OnSpellLearned(Spell theSpell)
    SpellListMod.AddUnlearnedSpell(theSpell)
endEvent
