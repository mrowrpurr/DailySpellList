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
Message property DailySpellList_NotEnoughPoints auto
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

int function GetRemainingHoursBeforeCanMeditateAgain()
    int currentGameHoursPassed   = GetTotalHoursPassed()
    int lastMeditationGameTime   = DailySpellList_LastMeditationHour.Value as int
    int minimumHoursRequired     = DailySpellList_MinHours.Value as int
    int hoursSinceLastMeditation = currentGameHoursPassed - lastMeditationGameTime
    if hoursSinceLastMeditation >= minimumHoursRequired
        return 0
    else
        return minimumHoursRequired - hoursSinceLastMeditation
    endIf
endFunction

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
        string level = GetSpellLevel(theSpell)

        if level == "Novice"
            if UnpreparedSpells_Novice.Find(theSpell) == -1 && PreparedSpells_Novice.Find(theSpell) == -1 
                PlayerRef.RemoveSpell(theSpell)
                if ! UnpreparedSpells_Novice
                    UnpreparedSpells_Novice = new Form[1]
                    UnpreparedSpells_Novice[0] = theSpell
                else
                    UnpreparedSpells_Novice = Utility.ResizeFormArray(UnpreparedSpells_Novice, UnpreparedSpells_Novice.Length + 1)
                    UnpreparedSpells_Novice[UnpreparedSpells_Novice.Length - 1] = theSpell
                endIf
            endIf
        elseIf level == "Apprentice"
            if UnpreparedSpells_Apprentice.Find(theSpell) == -1 && PreparedSpells_Apprentice.Find(theSpell) == -1 
                PlayerRef.RemoveSpell(theSpell)
                if ! UnpreparedSpells_Apprentice
                    UnpreparedSpells_Apprentice = new Form[1]
                    UnpreparedSpells_Apprentice[0] = theSpell
                else
                    UnpreparedSpells_Apprentice = Utility.ResizeFormArray(UnpreparedSpells_Apprentice, UnpreparedSpells_Apprentice.Length + 1)
                    UnpreparedSpells_Apprentice[UnpreparedSpells_Apprentice.Length - 1] = theSpell
                endIf
            endIf

        elseIf level == "Adept"
            if UnpreparedSpells_Adept.Find(theSpell) == -1 && PreparedSpells_Adept.Find(theSpell) == -1 
                PlayerRef.RemoveSpell(theSpell)
                if ! UnpreparedSpells_Adept
                    UnpreparedSpells_Adept = new Form[1]
                    UnpreparedSpells_Adept[0] = theSpell
                else
                    UnpreparedSpells_Adept = Utility.ResizeFormArray(UnpreparedSpells_Adept, UnpreparedSpells_Adept.Length + 1)
                    UnpreparedSpells_Adept[UnpreparedSpells_Adept.Length - 1] = theSpell
                endIf
            endIf

        elseIf level == "Expert"
            if UnpreparedSpells_Expert.Find(theSpell) == -1 && PreparedSpells_Expert.Find(theSpell) == -1
                PlayerRef.RemoveSpell(theSpell)
                if ! UnpreparedSpells_Expert
                    UnpreparedSpells_Expert = new Form[1]
                    UnpreparedSpells_Expert[0] = theSpell
                else
                    UnpreparedSpells_Expert = Utility.ResizeFormArray(UnpreparedSpells_Expert, UnpreparedSpells_Expert.Length + 1)
                    UnpreparedSpells_Expert[UnpreparedSpells_Expert.Length - 1] = theSpell
                endIf
            endIf

        elseIf level == "Master"
            if UnpreparedSpells_Master.Find(theSpell) == -1 && PreparedSpells_Master.Find(theSpell) == -1
                PlayerRef.RemoveSpell(theSpell)
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
    int remainingHours = GetRemainingHoursBeforeCanMeditateAgain()
    if remainingHours > 0
        Debug.MessageBox("You need to wait " + remainingHours + " hour(s) before you can meditate on your spells.")
    else
        if BeginMeditationPrompt()
            IsCurrentlyMeditating = true
            if ! PlayerSpellsLoaded
                PlayerSpellsLoaded = true
            endIf
            ShowSpellSelectionList()
        endIf
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

Form[] function TryToPrepareSpellAndReturnNewArray(Spell theSpell, Form[] unpreparedSpellArray)
    if HasEnoughPointsAvailableToPrepareSpell(theSpell)
        PrepareSpell(theSpell)
        return RemoveElement(unpreparedSpellArray, theSpell)
    else
        DailySpellList_NotEnoughPoints.Show()
        return unpreparedSpellArray
    endIf
endFunction

Form[] function RemoveElement(Form[] theArray, Form theForm)
    Form[] newArray
    if theArray.Length == 1
        return newArray
    endIf
    newArray = Utility.CreateFormArray(theArray.Length - 1)
    int existingArrayIndex = 0
    int existingArrayIndexToSkip = theArray.Find(theForm)
    int newArrayIndex = 0
    while existingArrayIndex < theArray.Length
        if existingArrayIndex != existingArrayIndexToSkip
            newArray[newArrayIndex] = theArray[existingArrayIndex]
            newArrayIndex += 1
        endIf
        existingArrayIndex += 1
    endWhile
    return newArray
endFunction

Form[] function AddElement(Form[] theArray, Form theForm)
    if theArray
        theArray = Utility.ResizeFormArray(theArray, theArray.Length + 1)
        theArray[theArray.Length - 1] = theForm
    else
        theArray = new Form[1]
        theArray[0] = theForm
    endIf
    return theArray
endFunction

bool function IsSpellPrepared(Spell theSpell)
    return PreparedSpells_Novice.Find(theSpell)     > -1 || \
           PreparedSpells_Apprentice.Find(theSpell) > -1 || \
           PreparedSpells_Adept.Find(theSpell)      > -1 || \
           PreparedSpells_Expert.Find(theSpell)     > -1 || \
           PreparedSpells_Master.Find(theSpell)     > -1
endFunction

function PrepareSpell(Spell theSpell)
    string level = GetSpellLevel(theSpell)
    if level == "Novice"
        PreparedSpells_Novice = Utility.ResizeFormArray(PreparedSpells_Novice, PreparedSpells_Novice.Length + 1)
        PreparedSpells_Novice[PreparedSpells_Novice.Length - 1] = theSpell
        SpellPointsUsed += DailySpellList_PointsRequired_Novice.Value as int
    elseIf level == "Apprentice"
        PreparedSpells_Apprentice = Utility.ResizeFormArray(PreparedSpells_Apprentice, PreparedSpells_Apprentice.Length + 1)
        PreparedSpells_Apprentice[PreparedSpells_Apprentice.Length - 1] = theSpell
        SpellPointsUsed += DailySpellList_PointsRequired_Apprentice.Value as int
    elseIf level == "Adept"
        PreparedSpells_Adept = Utility.ResizeFormArray(PreparedSpells_Adept, PreparedSpells_Adept.Length + 1)
        PreparedSpells_Adept[PreparedSpells_Adept.Length - 1] = theSpell
        SpellPointsUsed += DailySpellList_PointsRequired_Adept.Value as int
    elseIf level == "Expert"
        PreparedSpells_Expert = Utility.ResizeFormArray(PreparedSpells_Expert, PreparedSpells_Expert.Length + 1)
        PreparedSpells_Expert[PreparedSpells_Expert.Length - 1] = theSpell
        SpellPointsUsed += DailySpellList_PointsRequired_Expert.Value as int
    elseIf level == "Master"
        PreparedSpells_Master = Utility.ResizeFormArray(PreparedSpells_Master, PreparedSpells_Master.Length + 1)
        PreparedSpells_Master[PreparedSpells_Master.Length - 1] = theSpell
        SpellPointsUsed += DailySpellList_PointsRequired_Master.Value as int
    endIf
    PlayerRef.AddSpell(theSpell, abVerbose = false)
endFunction

bool function HasEnoughPointsAvailableToPrepareSpell(Spell theSpell)
    return GetCurrentRemainingSpellPoints() >= GetPointsRequiredForSpell(theSpell)
endFunction

int function GetPointsRequiredForSpell(Spell theSpell)
    string level = GetSpellLevel(theSpell)
    if level == "Novice"
        return DailySpellList_PointsRequired_Novice.Value as int
    elseIf level == "Apprentice"
        return DailySpellList_PointsRequired_Apprentice.Value as int
    elseIf level == "Adept"
        return DailySpellList_PointsRequired_Adept.Value as int
    elseIf level == "Expert"
        return DailySpellList_PointsRequired_Expert.Value as int
    elseIf level == "Master"
        return DailySpellList_PointsRequired_Master.Value as int
    endIf
endFunction

function ShowSpellSelectionList()
    UIListMenu list = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    list.AddEntryItem("[Prepared Spells]")
    list.AddEntryItem("(" + GetCurrentRemainingSpellPoints() + " points available)")
    AddSpellsToList(list, PreparedSpells_Novice, "Novice")
    AddSpellsToList(list, PreparedSpells_Apprentice, "Apprentice")
    AddSpellsToList(list, PreparedSpells_Adept, "Adept")
    AddSpellsToList(list, PreparedSpells_Expert, "Expert")
    AddSpellsToList(list, PreparedSpells_Master, "Master")
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
        int currentIndex = 2 ; The two header lines in the list of prepared

        if selection < (currentIndex + PreparedSpells_Novice.Length)
            Spell theSpell = PreparedSpells_Novice[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Novice = AddElement(UnpreparedSpells_Novice, theSpell)
            PreparedSpells_Novice = RemoveElement(PreparedSpells_Novice, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Novice.Length

        if selection < (currentIndex + PreparedSpells_Apprentice.Length)
            Spell theSpell = PreparedSpells_Apprentice[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Apprentice = AddElement(UnpreparedSpells_Apprentice, theSpell)
            PreparedSpells_Apprentice = RemoveElement(PreparedSpells_Apprentice, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Apprentice.Length

        if selection < (currentIndex + PreparedSpells_Adept.Length)
            Spell theSpell = PreparedSpells_Adept[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Adept = AddElement(UnpreparedSpells_Adept, theSpell)
            PreparedSpells_Adept = RemoveElement(PreparedSpells_Adept, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Adept.Length

        if selection < (currentIndex + PreparedSpells_Expert.Length)
            Spell theSpell = PreparedSpells_Expert[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Expert = AddElement(UnpreparedSpells_Expert, theSpell)
            PreparedSpells_Expert = RemoveElement(PreparedSpells_Expert, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Expert.Length

        if selection < (currentIndex + PreparedSpells_Master.Length)
            Spell theSpell = PreparedSpells_Master[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Master = AddElement(UnpreparedSpells_Master, theSpell)
            PreparedSpells_Master = RemoveElement(PreparedSpells_Master, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Master.Length

        currentIndex += 2 ; The header and empty space in the list for unprepared

        if selection < (currentIndex + UnpreparedSpells_Novice.Length)
            Spell theSpell = UnpreparedSpells_Novice[selection - currentIndex] as Spell
            UnpreparedSpells_Novice = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Novice)
            PlayerRef.AddSpell(theSpell, abVerbose = false)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += UnpreparedSpells_Novice.Length

        if selection < (currentIndex + UnpreparedSpells_Apprentice.Length)
            Spell theSpell = UnpreparedSpells_Apprentice[selection - currentIndex] as Spell
            UnpreparedSpells_Apprentice = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Apprentice)
            PlayerRef.AddSpell(theSpell, abVerbose = false)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += UnpreparedSpells_Apprentice.Length

        if selection < (currentIndex + UnpreparedSpells_Adept.Length)
            Spell theSpell = UnpreparedSpells_Adept[selection - currentIndex] as Spell
            UnpreparedSpells_Adept = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Adept)
            PlayerRef.AddSpell(theSpell, abVerbose = false)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += UnpreparedSpells_Adept.Length

        if selection < (currentIndex + UnpreparedSpells_Expert.Length)
            Spell theSpell = UnpreparedSpells_Expert[selection - currentIndex] as Spell
            UnpreparedSpells_Expert = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Expert)
            PlayerRef.AddSpell(theSpell, abVerbose = false)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += UnpreparedSpells_Expert.Length

        if selection < (currentIndex + UnpreparedSpells_Master.Length)
            Spell theSpell = UnpreparedSpells_Master[selection - currentIndex] as Spell
            UnpreparedSpells_Master = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Master)
            PlayerRef.AddSpell(theSpell, abVerbose = false)
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += UnpreparedSpells_Master.Length
    endIf
endFunction

function AddSpellsToList(UIListMenu list, Form[] spells, string level)
    int i = 0
    while i < spells.Length
        list.AddEntryItem(spells[i].GetName() + " [" + level + "]" + \
            " (" + GetPointsRequiredForSpell(spells[i] as Spell) + ")")
        i += 1
    endWhile
endFunction
