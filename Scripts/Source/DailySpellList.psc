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
Message property DailySpellList_BeginMeditation auto
Message property DailySpellList_EndMeditation auto
Perk property AlterationNovice00 auto
Perk property AlterationApprentice25 auto
Perk property AlterationAdept50 auto
Perk property AlterationExpert75 auto
Perk property AlterationMaster100 auto
Perk property ConjurationNovice00 auto
Perk property ConjurationApprentice25 auto
Perk property ConjurationAdept50 auto
Perk property ConjurationExpert75 auto
Perk property ConjurationMaster100 auto
Perk property DestructionNovice00 auto
Perk property DestructionApprentice25 auto
Perk property DestructionAdept50 auto
Perk property DestructionExpert75 auto
Perk property DestructionMaster100 auto
Perk property IllusionNovice00 auto
Perk property IllusionApprentice25 auto
Perk property IllusionAdept50 auto
Perk property IllusionExpert75 auto
Perk property IllusionMaster100 auto
Perk property RestorationNovice00 auto
Perk property RestorationApprentice25 auto
Perk property RestorationAdept50 auto
Perk property RestorationExpert75 auto
Perk property RestorationMaster100 auto

bool IsCurrentlyMeditating
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
        if BeginMeditationPrompt()
            IsCurrentlyMeditating = true
            ShowSpellSelectionList()
        endIf
    else
        ShowSpellSelectionList()
        Debug.MessageBox("You need to wait XXX hours........")
    endIf
endFunction

bool function BeginMeditationPrompt()
    return DailySpellList_BeginMeditation.Show() == 0
endFunction

bool function EndMeditationPrompt()
    return DailySpellList_EndMeditation.Show() == 0
endFunction

string function GetSpellLevel(Spell theSpell)
    Perk thePerk = theSpell.GetPerk()
    if thePerk == AlterationNovice00 || thePerk == ConjurationNovice00 || thePerk == DestructionNovice00 || thePerk == IllusionNovice00 || thePerk == RestorationNovice00
        return "Novice"
    elseIf thePerk == AlterationApprentice25 || thePerk == ConjurationApprentice25 || thePerk == DestructionApprentice25 || thePerk == IllusionApprentice25 || thePerk == RestorationApprentice25
        return "Apprentice"
    elseIf thePerk == AlterationAdept50 || thePerk == ConjurationAdept50 || thePerk == DestructionAdept50 || thePerk == IllusionAdept50 || thePerk == RestorationAdept50
        return "Adept"
    elseIf thePerk == AlterationExpert75 || thePerk == ConjurationExpert75 || thePerk == DestructionExpert75 || thePerk == IllusionExpert75 || thePerk == RestorationExpert75
        return "Expert"
    elseIf thePerk == AlterationMaster100 || thePerk == ConjurationMaster100 || thePerk == DestructionMaster100 || thePerk == IllusionMaster100 || thePerk == RestorationMaster100
        return "Master"
    endIf
endFunction

function ShowSpellSelectionList()
    UIListMenu list = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    list.AddEntryItem("[Prepared Spells]")
    list.AddEntryItem("(x points available)")
    list.AddEntryItem(" ")
    list.AddEntryItem("[Available Spells]")

    int spellCount = PlayerRef.GetSpellCount()
    int i = 0
    while i < spellCount
        Spell theSpell = PlayerRef.GetNthSpell(i)
        if DoesSpellCostPoints(theSpell)
            list.AddEntryItem(theSpell.GetName() + " [" + GetSpellLevel(theSpell) + "]")
        endIf
        i += 1
    endWhile

    list.OpenMenu()

    int selection = list.GetResultInt()

    if selection == -1
        if EndMeditationPrompt()
            IsCurrentlyMeditating = false
            DailySpellList_LastMeditationHour.Value = GetTotalHoursPassed()
        else
            ShowSpellSelectionList()
        endIf
    else
        ShowSpellSelectionList()
    endIf

    ; "[Prepared Spells]"
    ; "(5 points remaining)"
    ; "xxx [Novice]"
    ; "xxx [Novice]"
endFunction
