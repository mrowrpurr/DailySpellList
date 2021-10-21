scriptName DailySpellList extends Quest

Actor property SpellStorage_AvailableSpells auto
Actor property SpellStorage_PreparedSpells auto

function OpenSpellPreparationMenu()
    UIMagicMenu magicMenu = UIExtensions.GetMenu("UIMagicMenu") as UIMagicMenu

    Spell sparks = Game.GetForm(0x2dd2a) as Spell
    Spell candlelight = Game.GetForm(0x43324) as Spell
    SpellStorage_AvailableSpells.AddSpell(sparks)
    SpellStorage_AvailableSpells.AddSpell(candlelight)

    magicMenu.SetPropertyForm("receivingActor", SpellStorage_PreparedSpells)

    RegisterForModEvent("UIMagicMenu_AddRemoveSpell", "OnAddRemoveSpell")
    magicMenu.OpenMenu(SpellStorage_AvailableSpells)

    ; UIExtensions.GetMenu("UIListMenu").OpenMenu()
    ; UI.InvokeForm("CustomMenu", "_root.Menu_mc.MagicMenu_AddSpell", value)
endFunction

event OnAddRemoveSpell(string eventName, string strArg, float fltArg, Form sender)
    ; this.inventoryLists.itemList.__get__entryList().splice(_loc2_,1);

    Spell differentSpell = Game.GetForm(0x4DEEA) as Spell

    Spell theSpell = sender as Spell

    UI.InvokeForm("CustomMenu", "_root.Menu_mc.Secondary_MagicMenu_AddSpell", differentSpell)

    ; Already Prepared, therefore MUST be clicking from the RIGHT side (of Prepared)
    if SpellStorage_PreparedSpells.HasSpell(theSpell)
        Debug.MessageBox("OUR event " + theSpell.GetName() + " FIRST BRANCH")

        SpellStorage_PreparedSpells.RemoveSpell(theSpell)
        SpellStorage_AvailableSpells.AddSpell(theSpell)

        ; MagicMenu_RemoveSpell
        ; MagicMenu_AddSpell

        ; Utility.WaitMenuMode(0.2)
        ; Debug.MessageBox("Setting Actor...")
        ; UI.InvokeForm("CustomMenu", "_root.Menu_mc.MagicMenu_SetActor", SpellStorage_AvailableSpells)
        ; Utility.WaitMenuMode(1.0)
        ; UI.Invoke("CustomMenu", "_root.Menu_mc.ClearEntryList")
        ; Debug.MessageBox("Setting Secondary Actor...")
        ; Utility.WaitMenuMode(1.0)
        ; UI.InvokeForm("CustomMenu", "_root.Menu_mc.MagicMenu_SetSecondaryActor", SpellStorage_PreparedSpells)

    ; Unprepared, therefore we MUST be clicking from the LEFT side (of Available)
    else
        Debug.MessageBox("OUR event " + theSpell.GetName() + " second BRANCH")

        SpellStorage_AvailableSpells.RemoveSpell(theSpell)
        SpellStorage_PreparedSpells.AddSpell(theSpell)

        ; UI.Invoke("CustomMenu", "_root.Menu_mc.ClearEntryList")

        ; Utility.WaitMenuMode(0.2)
        ; Debug.MessageBox("Setting Actor...")
        ; UI.InvokeForm("CustomMenu", "_root.Menu_mc.MagicMenu_SetActor", SpellStorage_AvailableSpells)
        ; Utility.WaitMenuMode(1.0)
        ; Debug.MessageBox("Setting Secondary Actor...")
        UI.InvokeForm("CustomMenu", "_root.Menu_mc.MagicMenu_SetSecondaryActor", SpellStorage_PreparedSpells)

        UI.Invoke("CustomMenu", "_root.Menu_mc.this.ComputeCategoryAvailability")

        UI.InvokeForm("CustomMenu", "_root.Menu_mc.Secondary_MagicMenu_AddSpell", differentSpell)

    endIf
endEvent


        ; UI.InvokeForm("CustomMenu", "_root.Menu_mc.MagicMenu_SetActor", SpellStorage_AvailableSpells)
        ; UI.InvokeForm("CustomMenu", "_root.Menu_mc.MagicMenu_SetSecondaryActor", SpellStorage_PreparedSpells)
        ; UI.Invoke("CustomMenu", "_root.Menu_mc.inventoryLists.categoryList.InvalidateData")
        ; UI.Invoke("CustomMenu", "_root.Menu_mc.inventoryLists.itemList.InvalidateData")
        ; UI.Invoke("CustomMenu", "_root.Menu_mc.inventoryLists.itemList.InvalidateData")