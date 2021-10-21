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
Form[] UnpreparedSpells_Novice
Form[] UnpreparedSpells_Apprentice
Form[] UnpreparedSpells_Adept
Form[] UnpreparedSpells_Expert
Form[] UnpreparedSpells_Master
Form[] PreparedSpells_Novice
Form[] PreparedSpells_Apprentice
Form[] PreparedSpells_Adept
Form[] PreparedSpells_Expert
Form[] PreparedSpells_Master

bool PlayerSpellsLoaded
int  SpellPointsUsed
bool IsCurrentlyMeditating
EquipSlot VoiceEquipSlot

function AddTestSpells()
    PlayerRef.AddSpell(Game.GetForm(0x7e8e5) as Spell)
    PlayerRef.AddSpell(Game.GetForm(0x35d7f) as Spell)
    PlayerRef.AddSpell(Game.GetForm(0x45f9c) as Spell)
    PlayerRef.AddSpell(Game.GetForm(0x2dd29) as Spell)
    PlayerRef.AddSpell(Game.GetForm(0x2b96b) as Spell)
endFunction

event OnInit()
    AddTestSpells()
    VoiceEquipSlot = Game.GetForm(0x25bee) as EquipSlot
    LoadAllPlayerSpellsAsUnprepared()
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

bool function DoesSpellCostPoints(Spell theSpell)
    if ! theSpell.GetPerk()
        return false
    endIf
    if theSpell.GetEquipType() == VoiceEquipSlot
        return false
    endIf
    ; if IsCantrip(theSpell)
    ;     return false
    ; endIf
    return true
endFunction

bool function IsCantrip(Spell theSpell)
    ; TODO ;
endFunction

int function GetTotalAvailableSpellPoints()
    int baseMagicka             = PlayerRef.GetBaseActorValue("Magicka")      as int
    int minMagickaRequired      = DailySpellList_MinSpellCastingMagicka.Value as int
    int pointsPerInterval       = DailySpellList_PointsEarnedValue.Value      as int
    int intervalSize            = DailySpellList_PointsEarnedInterval.Value   as int
    int amountOfMagickaOverBase = baseMagicka - minMagickaRequired

    if amountOfMagickaOverBase <= 0
        return 0
    endIf

    int spellPointIncreaseCount = (amountOfMagickaOverBase / intervalSize) as int

    return spellPointIncreaseCount * pointsPerInterval
endFunction

int function GetCurrentRemainingSpellPoints()
    return GetTotalAvailableSpellPoints() - SpellPointsUsed
endFunction

function AddUnlearnedSpell(Spell theSpell)
    if DoesSpellCostPoints(theSpell)
        PlayerRef.RemoveSpell(theSpell)
        string level = GetSpellLevel(theSpell)

        if level == "Novice"
            if UnpreparedSpells_Novice.Find(theSpell) == -1
                if ! UnpreparedSpells_Novice
                    UnpreparedSpells_Novice = new Form[1]
                    UnpreparedSpells_Novice[0] = theSpell
                else
                    UnpreparedSpells_Novice = Utility.ResizeFormArray(UnpreparedSpells_Novice, UnpreparedSpells_Novice.Length + 1)
                    UnpreparedSpells_Novice[UnpreparedSpells_Novice.Length - 1] = theSpell
                endIf
            endIf
        elseIf level == "Apprentice"
            if UnpreparedSpells_Apprentice.Find(theSpell) == -1
                if ! UnpreparedSpells_Apprentice
                    UnpreparedSpells_Apprentice = new Form[1]
                    UnpreparedSpells_Apprentice[0] = theSpell
                else
                    UnpreparedSpells_Apprentice = Utility.ResizeFormArray(UnpreparedSpells_Apprentice, UnpreparedSpells_Apprentice.Length + 1)
                    UnpreparedSpells_Apprentice[UnpreparedSpells_Apprentice.Length - 1] = theSpell
                endIf
            endIf

        elseIf level == "Adept"
            if UnpreparedSpells_Adept.Find(theSpell) == -1
                if ! UnpreparedSpells_Adept
                    UnpreparedSpells_Adept = new Form[1]
                    UnpreparedSpells_Adept[0] = theSpell
                else
                    UnpreparedSpells_Adept = Utility.ResizeFormArray(UnpreparedSpells_Adept, UnpreparedSpells_Adept.Length + 1)
                    UnpreparedSpells_Adept[UnpreparedSpells_Adept.Length - 1] = theSpell
                endIf
            endIf

        elseIf level == "Expert"
            if UnpreparedSpells_Expert.Find(theSpell) == -1
                if ! UnpreparedSpells_Expert
                    UnpreparedSpells_Expert = new Form[1]
                    UnpreparedSpells_Expert[0] = theSpell
                else
                    UnpreparedSpells_Expert = Utility.ResizeFormArray(UnpreparedSpells_Expert, UnpreparedSpells_Expert.Length + 1)
                    UnpreparedSpells_Expert[UnpreparedSpells_Expert.Length - 1] = theSpell
                endIf
            endIf

        elseIf level == "Master"
            if UnpreparedSpells_Master.Find(theSpell) == -1
                if ! UnpreparedSpells_Master
                    UnpreparedSpells_Master = new Form[1]
                    UnpreparedSpells_Master[0] = theSpell
                else
                    UnpreparedSpells_Master = Utility.ResizeFormArray(UnpreparedSpells_Master, UnpreparedSpells_Master.Length + 1)
                    UnpreparedSpells_Master[UnpreparedSpells_Master.Length - 1] = theSpell
                endIf
            endIf
        endIf
    endIf
endFunction

function LoadAllPlayerSpellsAsUnprepared()
    int spellCount = PlayerRef.GetSpellCount()
    int i = 0
    while i < spellCount
        Spell theSpell = PlayerRef.GetNthSpell(i)
        AddUnlearnedSpell(theSpell)
        i += 1
    endWhile

    ActorBase playerBase = PlayerRef.GetActorBase()
    spellCount = playerBase.GetSpellCount()
    i = 0
    while i < spellCount
        Spell theSpell = playerBase.GetNthSpell(i)
        AddUnlearnedSpell(theSpell)
        i += 1
    endWhile

    Race playerRace = PlayerRef.GetRace()
    spellCount = playerRace.GetSpellCount()
    i = 0
    while i < spellCount
        Spell theSpell = playerRace.GetNthSpell(i)
        AddUnlearnedSpell(theSpell)
        i += 1
    endWhile
endFunction

function MeditateOnSpellList()    
    if CanPrepareNewSpellList
        if BeginMeditationPrompt()
            IsCurrentlyMeditating = true
            if ! PlayerSpellsLoaded
                PlayerSpellsLoaded = true
            endIf
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
    list.AddEntryItem("(" + GetCurrentRemainingSpellPoints() + " points available)")
    list.AddEntryItem(" ")
    list.AddEntryItem("[Available Spells]")
    AddSpellsToList(list, UnpreparedSpells_Novice, "Novice")
    AddSpellsToList(list, UnpreparedSpells_Apprentice, "Apprentice")
    AddSpellsToList(list, UnpreparedSpells_Adept, "Adept")
    AddSpellsToList(list, UnpreparedSpells_Expert, "Expert")
    AddSpellsToList(list, UnpreparedSpells_Master, "Master")

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
endFunction

function AddSpellsToList(UIListMenu list, Form[] spells, string level)
    int i = 0
    while i < spells.Length
        list.AddEntryItem(spells[i].GetName() + " [" + level + "]")
        i += 1
    endWhile
endFunction
