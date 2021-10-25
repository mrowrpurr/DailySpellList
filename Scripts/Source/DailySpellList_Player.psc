scriptName DailySpellList_Player extends ReferenceAlias

DailySpellList property SpellListMod auto

int  CurrentPlayerMagicka
bool JustFinishedSleeping = false

event OnInit()
    SpellListMod = GetOwningQuest() as DailySpellList
    SpellListMod.DailySpellList_PlayerReferenceAlias = self
    ListenForEvents()
endEvent

event OnPlayerLoadGame()
    ListenForEvents()
endEvent

function ListenForEvents()
    ListenForSleep()
    ListenForWait()
    ListenForNewSpellLearned()
    ListenForLevelUp()
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

function StopListeningForWait()
    UnregisterForMenu("Sleep/Wait Menu")
endFunction

function ListenForNewSpellLearned()
    PO3_Events_Alias.RegisterForSpellLearned(self)
endFunction

function ListenForLevelUp()
    if SpellListMod.DailySpellList_LevelUpDisplay.Value > 0
        PO3_Events_Alias.RegisterForLevelIncrease(self)
    endIf
endFunction

function StopListeningForLevelUp()
    PO3_Events_Alias.UnregisterForLevelIncrease(self)
endFunction

event OnSleepStop(bool interrupted)
    JustFinishedSleeping = true
    if SpellListMod.DailySpellList_SleepPrompt.Value > 0 && SpellListMod.CanPrepareNewSpellList
        SpellListMod.MeditateOnSpellList()
    endIf
endEvent

event OnPlayerFastTravelEnd(float travelTime)
    if SpellListMod.DailySpellList_TravelPrompt.Value > 0 && SpellListMod.CanPrepareNewSpellList
        Utility.Wait(1.0)
        SpellListMod.MeditateOnSpellList()
    endIf
endEvent

event OnMenuClose(string menuName)
    if menuName == "Sleep/Wait Menu" && SpellListMod.DailySpellList_WaitPrompt.Value > 0 && SpellListMod.CanPrepareNewSpellList
        if ! JustFinishedSleeping
            SpellListMod.MeditateOnSpellList()
        endIf
        JustFinishedSleeping = false
    elseIf menuName == "LevelUp Menu"
        UnregisterForMenu("LevelUp Menu")
        int newMagicka = GetActorReference().GetBaseActorValue("Magicka") as int
        if newMagicka > CurrentPlayerMagicka
            int totalMagickaAdded = newMagicka - CurrentPlayerMagicka
            CurrentPlayerMagicka = newMagicka
            SpellListMod.DisplayLevelUpInfo(totalMagickaAdded)
        endIf
    endIf
endEvent

event OnSpellLearned(Spell theSpell)
    SpellListMod.AddUnlearnedSpell(theSpell)
endEvent

event OnLevelIncrease(int theLevel)
    if SpellListMod.DailySpellList_LevelUpDisplay.Value > 0
        CurrentPlayerMagicka = GetActorReference().GetBaseActorValue("Magicka") as int
        RegisterForMenu("LevelUp Menu")
    endIf
endEvent

event OnObjectEquipped(Form theObject, ObjectReference theObjectInstance)
    Spell theSpell = theObject as Spell
    if theSpell && SpellListMod.DoesSpellCostPoints(theSpell)
        if ! SpellListMod.IsSpellPrepared(theSpell)
            GetActorReference().UnequipSpell(theSpell, 0)
            GetActorReference().UnequipSpell(theSpell, 1)
            GetActorReference().RemoveSpell(theSpell)
            Debug.MessageBox(theSpell.GetName() + " is not currently prepared")
        endIf
    endIf
endEvent
