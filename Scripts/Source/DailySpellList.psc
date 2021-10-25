scriptName DailySpellList extends Quest

Actor property PlayerRef auto
DailySpellList_Player property DailySpellList_PlayerReferenceAlias auto
GlobalVariable property DailySpellList_MinHours auto
GlobalVariable property DailySpellList_SleepPrompt auto
GlobalVariable property DailySpellList_WaitPrompt auto
GlobalVariable property DailySpellList_TravelPrompt auto
GlobalVariable property DailySpellList_LevelUpDisplay auto
GlobalVariable property DailySpellList_LastMeditationHour auto
GlobalVariable property DailySpellList_PointsRequired_Novice auto
GlobalVariable property DailySpellList_PointsRequired_Apprentice auto
GlobalVariable property DailySpellList_PointsRequired_Adept auto
GlobalVariable property DailySpellList_PointsRequired_Expert auto
GlobalVariable property DailySpellList_PointsRequired_Master auto
GlobalVariable property DailySpellList_PointsEarnedInterval auto
GlobalVariable property DailySpellList_PointsEarnedValue auto
GlobalVariable property DailySpellList_MinSpellCastingMagicka auto
GlobalVariable property DailySpellList_CanCancelMeditation auto
GlobalVariable property DailySpellList_CanBeginMeditation auto
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
Form[] property UnpreparedSpells_Novice auto
Form[] property UnpreparedSpells_Apprentice auto
Form[] property UnpreparedSpells_Adept auto
Form[] property UnpreparedSpells_Expert auto
Form[] property UnpreparedSpells_Master auto
Form[] PreparedSpells_Novice
Form[] PreparedSpells_Apprentice
Form[] PreparedSpells_Adept
Form[] PreparedSpells_Expert
Form[] PreparedSpells_Master
Form[] property UnrestrictedSpells auto
Form property DailySpellList_MessageText_BaseForm auto
Spell property Candlelight auto

bool HasPlayerMeditated
bool PlayerSpellsLoaded
int  SpellPointsUsed
bool IsCurrentlyMeditating
EquipSlot VoiceEquipSlot

event OnInit()
    VoiceEquipSlot = Game.GetForm(0x25bee) as EquipSlot
    UnrestrictedSpells = new Form[1]
    UnrestrictedSpells[0] = Candlelight
    LoadAllPlayerSpellsAsUnprepared()
endEvent

bool property CanPrepareNewSpellList
    bool function get()
        if ! HasPlayerMeditated
            return true
        endIf
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

function DisplayLevelUpInfo(int magickaAdded)
    int totalAvailablePoints = GetTotalAvailableSpellPoints()
    if totalAvailablePoints > 0
        string text = ""
        int pointsPerTenAddedMagicka = DailySpellList_PointsEarnedValue.Value as int
        int totalPointsAdded = (magickaAdded / 10) * pointsPerTenAddedMagicka
        if totalPointsAdded == 1
            text += "Added 1 spell point\n\n" + \
                "You now have a total of " + totalAvailablePoints + " spell points"
        else
            text += "Added " + totalPointsAdded + " spell points\n\n" + \
                "You now have a total of " + totalAvailablePoints + " spell points"
        endIf
        Debug.MessageBox(text)
    endIf
endFunction

bool function DoesSpellCostPoints(Spell theSpell)
    if ! theSpell.GetPerk()
        return false
    endIf
    if theSpell.GetEquipType() == VoiceEquipSlot
        return false
    endIf
    if IsSpellWithoutRestriction(theSpell)
        return false
    endIf
    return true
endFunction

bool function PlayerHasAnyUnpreparedSpells()
    return UnpreparedSpells_Novice.Length     > 0 || \
           UnpreparedSpells_Apprentice.Length > 0 || \
           UnpreparedSpells_Adept.Length      > 0 || \
           UnpreparedSpells_Expert.Length     > 0 || \
           UnpreparedSpells_Master.Length     > 0
endFunction

bool function PlayerHasAnyPreparedSpells()
    return PreparedSpells_Novice.Length     > 0 || \
           PreparedSpells_Apprentice.Length > 0 || \
           PreparedSpells_Adept.Length      > 0 || \
           PreparedSpells_Expert.Length     > 0 || \
           PreparedSpells_Master.Length     > 0
endFunction

bool function IsSpellWithoutRestriction(Spell theSpell)
    return UnrestrictedSpells.Find(theSpell) > -1
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

Form[] function GetAllUnpreparedSpells()
    Form[] theSpells

    int i = 0
    while i < UnpreparedSpells_Novice.Length
        if theSpells
            theSpells = Utility.ResizeFormArray(theSpells, theSpells.Length + 1)
            theSpells[theSpells.Length - 1] = UnpreparedSpells_Novice[i]
        else
            theSpells = new Form[1]
            theSpells[0] = UnpreparedSpells_Novice[i]
        endIf
        i += 1
    endWhile

    i = 0
    while i < UnpreparedSpells_Apprentice.Length
        if theSpells
            theSpells = Utility.ResizeFormArray(theSpells, theSpells.Length + 1)
            theSpells[theSpells.Length - 1] = UnpreparedSpells_Apprentice[i]
        else
            theSpells = new Form[1]
            theSpells[0] = UnpreparedSpells_Apprentice[i]
        endIf
        i += 1
    endWhile

    i = 0
    while i < UnpreparedSpells_Adept.Length
        if theSpells
            theSpells = Utility.ResizeFormArray(theSpells, theSpells.Length + 1)
            theSpells[theSpells.Length - 1] = UnpreparedSpells_Adept[i]
        else
            theSpells = new Form[1]
            theSpells[0] = UnpreparedSpells_Adept[i]
        endIf
        i += 1
    endWhile

    i = 0
    while i < UnpreparedSpells_Expert.Length
        if theSpells
            theSpells = Utility.ResizeFormArray(theSpells, theSpells.Length + 1)
            theSpells[theSpells.Length - 1] = UnpreparedSpells_Expert[i]
        else
            theSpells = new Form[1]
            theSpells[0] = UnpreparedSpells_Expert[i]
        endIf
        i += 1
    endWhile

    i = 0
    while i < UnpreparedSpells_Master.Length
        if theSpells
            theSpells = Utility.ResizeFormArray(theSpells, theSpells.Length + 1)
            theSpells[theSpells.Length - 1] = UnpreparedSpells_Master[i]
        else
            theSpells = new Form[1]
            theSpells[0] = UnpreparedSpells_Master[i]
        endIf
        i += 1
    endWhile
    
    return theSpells
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

function MeditateOnSpellList(bool castUsingSpell = false)
    if ! PlayerHasAnyUnpreparedSpells() && ! PlayerHasAnyPreparedSpells()
        if castUsingSpell
            Debug.MessageBox("You do not have any spells\nwhich can be meditated on")
        endIf
        return
    endIf

    string text
    int remainingHours = GetRemainingHoursBeforeCanMeditateAgain()
    if remainingHours > 0 && HasPlayerMeditated
        DailySpellList_CanBeginMeditation.Value = 0
        if remainingHours == 1
            text = "You need to wait 1 hour until you can meditate\n\nWould you like to view your spell list?"
        else
            text = "You need to wait " + remainingHours + " hours until you can meditate\n\nWould you like to view your spell list?"
        endIf
    else
        text = "Would you like to begin meditation\nor view your spell list?"
        DailySpellList_CanBeginMeditation.Value = 1
    endIf

    SetMessageText(text)

    DailySpellList_CanCancelMeditation.Value = 1 ; Turn this off after performing a meditation action

    int beginMeditation = 0
    int viewSpellList = 1
    int result = DailySpellList_BeginMeditation.Show()
    if result == beginMeditation
        IsCurrentlyMeditating = true
        if ! PlayerSpellsLoaded
            PlayerSpellsLoaded = true
        endIf
        ShowSpellSelectionList()
    elseIf result == viewSpellList
        ShowSpellSelectionList(readonly = true)
    endIf
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
        DailySpellList_CanCancelMeditation.Value = 0
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

function ShowSpellSelectionList(string filter = "", bool readonly = false)
    UIListMenu list = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    Form[] AllDisplayedUnpreparedSpells
    
    list.AddEntryItem("[Prepared Spells]")
    list.AddEntryItem("(" + GetCurrentRemainingSpellPoints() + " points available)")
    AddSpellsToList(list, PreparedSpells_Novice, "Novice")
    AddSpellsToList(list, PreparedSpells_Apprentice, "Apprentice")
    AddSpellsToList(list, PreparedSpells_Adept, "Adept")
    AddSpellsToList(list, PreparedSpells_Expert, "Expert")
    AddSpellsToList(list, PreparedSpells_Master, "Master")
    list.AddEntryItem(" ")
    list.AddEntryItem("[Available Spells]")
    list.AddEntryItem("[Click To Filter Spells]")
    AllDisplayedUnpreparedSpells = AddSpellsToListAndReturnArray(AllDisplayedUnpreparedSpells, list, UnpreparedSpells_Novice, "Novice", filter)
    AllDisplayedUnpreparedSpells = AddSpellsToListAndReturnArray(AllDisplayedUnpreparedSpells, list, UnpreparedSpells_Apprentice, "Apprentice", filter)
    AllDisplayedUnpreparedSpells = AddSpellsToListAndReturnArray(AllDisplayedUnpreparedSpells, list, UnpreparedSpells_Adept, "Adept", filter)
    AllDisplayedUnpreparedSpells = AddSpellsToListAndReturnArray(AllDisplayedUnpreparedSpells, list, UnpreparedSpells_Expert, "Expert", filter)
    AllDisplayedUnpreparedSpells = AddSpellsToListAndReturnArray(AllDisplayedUnpreparedSpells, list, UnpreparedSpells_Master, "Master", filter)

    list.OpenMenu()

    int selection = list.GetResultInt()

    if selection == -1
        if readonly
            return
        endIf
        int yesEndMeditation = 0
        int noDontEndMeditation = 1
        int cancelMeditation = 2
        int result = DailySpellList_EndMeditation.Show()
        if result == yesEndMeditation
            IsCurrentlyMeditating = false
            HasPlayerMeditated = true 
            DailySpellList_LastMeditationHour.Value = GetTotalHoursPassed()   
            return        
        elseIf result == noDontEndMeditation
            ShowSpellSelectionList(readonly = readonly)
            return
        elseif result == cancelMeditation
            return
        endIf
    elseIf selection == 0 ; Header
        ShowSpellSelectionList(filter = "", readonly = readonly)
    elseIf selection == 1 ; Points Available Line
        ShowSpellSelectionList(filter = "", readonly = readonly)
    else
        int currentIndex = 2 ; The two header lines in the list of prepared

        if ! readonly && selection < (currentIndex + PreparedSpells_Novice.Length)
            Spell theSpell = PreparedSpells_Novice[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Novice = AddElement(UnpreparedSpells_Novice, theSpell)
            PreparedSpells_Novice = RemoveElement(PreparedSpells_Novice, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            DailySpellList_CanCancelMeditation.Value = 0
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Novice.Length

        if ! readonly && selection < (currentIndex + PreparedSpells_Apprentice.Length)
            Spell theSpell = PreparedSpells_Apprentice[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Apprentice = AddElement(UnpreparedSpells_Apprentice, theSpell)
            PreparedSpells_Apprentice = RemoveElement(PreparedSpells_Apprentice, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            DailySpellList_CanCancelMeditation.Value = 0
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Apprentice.Length

        if ! readonly && selection < (currentIndex + PreparedSpells_Adept.Length)
            Spell theSpell = PreparedSpells_Adept[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Adept = AddElement(UnpreparedSpells_Adept, theSpell)
            PreparedSpells_Adept = RemoveElement(PreparedSpells_Adept, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            DailySpellList_CanCancelMeditation.Value = 0
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Adept.Length

        if ! readonly && selection < (currentIndex + PreparedSpells_Expert.Length)
            Spell theSpell = PreparedSpells_Expert[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Expert = AddElement(UnpreparedSpells_Expert, theSpell)
            PreparedSpells_Expert = RemoveElement(PreparedSpells_Expert, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            DailySpellList_CanCancelMeditation.Value = 0
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Expert.Length

        if ! readonly && selection < (currentIndex + PreparedSpells_Master.Length)
            Spell theSpell = PreparedSpells_Master[selection - currentIndex] as Spell
            PlayerRef.RemoveSpell(theSpell)
            UnpreparedSpells_Master = AddElement(UnpreparedSpells_Master, theSpell)
            PreparedSpells_Master = RemoveElement(PreparedSpells_Master, theSpell)
            SpellPointsUsed -= GetPointsRequiredForSpell(theSpell)
            DailySpellList_CanCancelMeditation.Value = 0
            ShowSpellSelectionList()
            return
        endIf
        currentIndex += PreparedSpells_Master.Length

        if selection == currentIndex || selection == currentIndex + 1 ; This is the empty space or the Unprepared header
            ShowSpellSelectionList(filter = "", readonly = readonly)
            return
        endIf

        currentIndex += 2 ; The header and empty space in the list for unprepared

        ; Filter
        if selection == currentIndex
            string query = GetUserInput()
            if query
                ShowSpellSelectionList(query, readonly = readonly)
            else
                ShowSpellSelectionList(readonly = readonly)
            endIf
            return
        endIf

        currentIndex += 1 ; Filter

        int availablePoints = GetTotalAvailableSpellPoints()
        Spell theSpell      = AllDisplayedUnpreparedSpells[selection - currentIndex] as Spell
        string spellLevel   = GetSpellLevel(theSpell)

        if readonly
            return
        endIf

        if availablePoints >= GetPointsRequiredForSpell(theSpell)
            PlayerRef.AddSpell(theSpell, abVerbose = false)
        endIf

        if spellLevel == "Novice"
            UnpreparedSpells_Novice = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Novice)
        elseIf spellLevel == "Apprentice"
            UnpreparedSpells_Apprentice = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Apprentice)
        elseIf spellLevel == "Adept"
            UnpreparedSpells_Adept = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Adept)
        elseIf spellLevel == "Expert"
            UnpreparedSpells_Expert = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Expert)
        elseIf spellLevel == "Master"
            UnpreparedSpells_Master = TryToPrepareSpellAndReturnNewArray(theSpell, UnpreparedSpells_Master)
        endIf

        ShowSpellSelectionList(readonly = readonly)
        return
    endIf
endFunction

function ViewSpellList()
    Debug.MessageBox("TODO")
endFunction

function AddSpellsToList(UIListMenu list, Form[] spells, string level)
    int i = 0
    while i < spells.Length
        list.AddEntryItem(spells[i].GetName() + " [" + level + "]" + \
            " (" + GetPointsRequiredForSpell(spells[i] as Spell) + ")")
        i += 1
    endWhile
endFunction

Form[] function AddSpellsToListAndReturnArray(Form[] theArray, UIListMenu list, Form[] spells, string level, string filter = "")
    int i = 0
    while i < spells.Length
        Form theSpell = spells[i]
        if ! filter || StringUtil.Find(theSpell.GetName(), filter) > -1
            list.AddEntryItem(theSpell.GetName() + " [" + level + "]" + \
                " (" + GetPointsRequiredForSpell(theSpell as Spell) + ")")
            theArray = Utility.ResizeFormArray(theArray, theArray.Length + 1)
            theArray[theArray.Length - 1] = theSpell
        endIf
        i += 1
    endWhile
    return theArray
endFunction

string function GetUserInput(string defaultText = "")
    UITextEntryMenu textEntry = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    if defaultText
        textEntry.SetPropertyString("text", defaultText)
    endIf
    textEntry.OpenMenu()
    return textEntry.GetResultString()
endFunction

function SetMessageText(string text)
    DailySpellList_MessageText_BaseForm.SetName(text)
endFunction
