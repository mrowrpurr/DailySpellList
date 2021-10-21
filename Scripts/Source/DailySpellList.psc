scriptName DailySpellList extends Quest

Actor property PlayerRef auto
GlobalVariable property DailySpellList_MinHours auto
GlobalVariable property DailySpellList_SleepPrompt auto
GlobalVariable property DailySpellList_WaitPrompt auto
GlobalVariable property DailySpellList_TravelPrompt auto
GlobalVariable property DailySpellList_LastMeditationHour auto
GlobalVariable property DailySpellList_PointsRequired_Novice auto
GlobalVariable property DailySpellList_PointsRequired_Apprentice auto
GlobalVariable property DailySpellList_PointsRequired_Adept auto
GlobalVariable property DailySpellList_PointsRequired_Expert auto
GlobalVariable property DailySpellList_PointsRequired_Master auto
GlobalVariable property DailySpellList_PointsEarnedInterval auto
GlobalVariable property DailySpellList_PointsEarnedValue auto
GlobalVariable property DailySpellList_MinSpellCastingMagicka auto
GlobalVariable property GameDaysPassed auto
GlobalVariable property GameHour auto

EquipSlot VoiceEquipSlot

event OnInit()
    VoiceEquipSlot = Game.GetForm(0x25bee) as EquipSlot
endEvent

bool property CanPrepareNewSpellList
    bool function get()
        int currentGameHoursPassed = GetTotalHoursPassed()
        int lastMeditationGameTime = DailySpellList_LastMeditationHour.Value as int
        int minimumHoursRequired   = DailySpellList_MinHours.Value as int
        return lastMeditationGameTime == 0 || ((currentGameHoursPassed - lastMeditationGameTime) >= minimumHoursRequired)
    endFunction
endProperty

int function GetTotalHoursPassed()
    return ((GameDaysPassed.Value as int) * 24) + (GameHour.Value as int)
endFunction

Form[] property PlayerRaceSpells
    Form[] function get()
        Race playerRace  = PlayerRef.GetRace()
        int spellCount   = playerRace.GetSpellCount()
        Form[] theSpells = Utility.CreateFormArray(spellCount)
        int i            = 0
        while i < spellCount
            theSpells[i] = playerRace.GetNthSpell(i)
            i += 1
        endWhile
        return theSpells
    endFunction
endProperty

Form[] property PlayerBaseSpells
    Form[] function get()
        ActorBase playerBase  = PlayerRef.GetActorBase()
        int spellCount        = playerBase.GetSpellCount()
        Form[] theSpells      = Utility.CreateFormArray(spellCount)
        int i                 = 0
        while i < spellCount
            theSpells[i] = playerBase.GetNthSpell(i)
            i += 1
        endWhile
        return theSpells
    endFunction
endProperty

bool function DoesSpellCostPoints(Spell theSpell)
    if ! theSpell.GetPerk()
        return false
    endIf
    if theSpell.GetEquipType() == VoiceEquipSlot
        return false
    endIf
    if IsCantrip(theSpell)
        return false
    endIf
    if PlayerRaceSpells.Find(theSpell) > -1
        return false
    endIf
    if PlayerBaseSpells.Find(theSpell) > -1
        return false
    endIf
    return true
endFunction

bool function IsCantrip(Spell theSpell)
    ; TODO ;
endFunction

function MeditateOnSpellList()
    if CanPrepareNewSpellList
        ShowSpellSelectionList()
    else
        ShowSpellSelectionList() ; <--- for testing
        ; Debug.MessageBox("You need to wait XXX hours........")
        ; return
    endIf
endFunction

function ShowSpellSelectionList()
    UIListMenu list = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    list.AddEntryItem("[Prepared Spells]")
    list.AddEntryItem("(x points available)")
    list.AddEntryItem(" ")
    list.AddEntryItem("[Available Spells]")

    ; Voice is 

    int spellCount = PlayerRef.GetSpellCount()
    int i = 0
    while i < spellCount
        Spell theSpell = PlayerRef.GetNthSpell(i)
        if DoesSpellCostPoints(theSpell)
            list.AddEntryItem(theSpell.GetName())
        endIf
        i += 1
    endWhile

    list.OpenMenu()

    ; "[Prepared Spells]"
    ; "(5 points remaining)"
    ; "xxx [Novice]"
    ; "xxx [Novice]"
    ; "xxx [Novice]"
    ; "xxx [Adept]"
    ; "xxx [Adept]"
    ; "xxx [Expert]"
    ; "xxx [Master]"

    ; "[Unprepared]"
    ; "Flames"
endFunction
