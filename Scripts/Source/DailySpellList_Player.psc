scriptName DailySpellList_Player extends ReferenceAlias

DailySpellList property SpellListMod auto

function AddTestSpells()
    GetActorReference().AddSpell(Game.GetForm(0x7e8e5) as Spell)
    GetActorReference().AddSpell(Game.GetForm(0x35d7f) as Spell)
    GetActorReference().AddSpell(Game.GetForm(0x45f9c) as Spell)
    GetActorReference().AddSpell(Game.GetForm(0x2dd29) as Spell)
    GetActorReference().AddSpell(Game.GetForm(0x2b96b) as Spell)
endFunction

event OnInit()
    AddTestSpells()
    SpellListMod = GetOwningQuest() as DailySpellList
    ListenForEvents()
endEvent

event OnPlayerLoadGame()
    ListenForEvents()
endEvent

function ListenForEvents()
    ListenForSleep()
    ListenForWait()
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
