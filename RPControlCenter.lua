-- SPDX-License-Identifier: MPL-2.0
-- RP Control Center 0.2.0. Separate GUI; no modifications to other addons.
local addonName = ...
local names = {"RPChatMod", "HexerRP", "PaladinRP", "JaegerRP", "DruidenRP", "MagierRP"}
local selected = "RPChatMod"
local main, controls = nil, {}
local function db()
    RPControlCenter_CharacterDB = type(RPControlCenter_CharacterDB) == "table" and RPControlCenter_CharacterDB or {}
    local data = RPControlCenter_CharacterDB
    if type(data.debug) ~= "boolean" then data.debug = false end
    if type(data.previousChance) ~= "table" then data.previousChance = {} end
    return data
end
local function info(message)
    print("|cff88ccffRP Control Center:|r " .. message)
end
local function current()
    local addon = _G[selected]
    if type(addon) == "table" and addon.ready and type(addon.db) == "table" then return addon end
    return nil
end
local function makeText(parent, text, x,y, width)
    local label = parent:CreateFontString(nil,"OVERLAY","GameFontNormal")
    label:SetPoint("TOPLEFT",parent,"TOPLEFT",x,y)
    label:SetWidth(width or 280); label:SetJustifyH("LEFT");label:SetText(text)
    return label
end
local function button(parent, text, x,y,w, fn)
    local b=CreateFrame("Button",nil,parent,"UIPanelButtonTemplate")
    b:SetSize(w or 135,24);b:SetPoint("TOPLEFT",parent,"TOPLEFT",x,y)
    b:SetText(text);b:SetScript("OnClick",fn)
    return b
end
local function setSetting(key, value)
    local addon=current()
    if not addon then return end
    if key == "outputLanguage" and type(addon.SetOutputLanguage) == "function" then
        local ok, why=addon.SetOutputLanguage(value)
        if not ok then info("Sprache nicht verfuegbar: "..tostring(why));return end
    elseif type(addon.SetSetting)=="function" then addon.SetSetting(key,value)
    else addon.db[key]=value end
    if db().debug then info(selected .. "." .. key .. " = " .. tostring(value)) end
end
local function dropdown(parent,x,y,width,options,onPick)
    local d=CreateFrame("Frame",nil,parent,"UIDropDownMenuTemplate")
    d:SetPoint("TOPLEFT",parent,"TOPLEFT",x-16,y+5)
    UIDropDownMenu_SetWidth(d,width or 165)
    UIDropDownMenu_Initialize(d,function(self,level)
        for _,opt in ipairs(options) do
            local item=UIDropDownMenu_CreateInfo()
            item.text=opt[2];item.value=opt[1]
            item.func=function() onPick(opt[1]);UIDropDownMenu_SetSelectedValue(d,opt[1]) end
            UIDropDownMenu_AddButton(item,level)
        end
    end)
    return function(value) UIDropDownMenu_SetSelectedValue(d,value);UIDropDownMenu_SetText(d, (function() for _,o in ipairs(options) do if o[1]==value then return o[2] end end return tostring(value) end)()),d
end
local function checkbox(parent,text,x,y,fn)
    local c=CreateFrame("CheckButton",nil,parent,"UICheckButtonTemplate")
    c:SetPoint("TOPLEFT",parent,"TOPLEFT",x,y);c:SetSize(28,28)
    local label=makeText(parent,text,x+32,y-6,300)
    c:SetScript("OnClick",function(self) fn(self:GetChecked() and true or false) end)
    return c,label
end
local refresh
local function create()
    if main then return end
    main=CreateFrame("Frame","RPControlCenterFrame",UIParent,"BasicFrameTemplateWithInset")
    main:SetSize(650,705);main:SetPoint("CENTER")
    main:SetMovable(true);main:EnableMouse(true)
    main:RegisterForDrag("LeftButton");main:SetScript("OnDragStart",main.StartMoving);main:SetScript("OnDragStop",main.StopMovingOrSizing)
    main.TitleText:SetText("RP Control Center 0.2.0")
    main:SetClampedToScreen(true)
    main:Hide()
    main:SetScript("OnShow",function() if refresh then refresh() end end)
    makeText(main,"AddOn",20,-45)
    controls.selectAddon=dropdown(main,120,-44,200,{
        {"RPChatMod","RPChatMod"},{"HexerRP","HexerRP"},{"PaladinRP","PaladinRP"},
        {"JaegerRP","JaegerRP"},{"DruidenRP","DruidenRP"},{"MagierRP","MagierRP"}
    },function(v) selected=v;refresh() end)
    controls.status=makeText(main,"",20,-88,560)
    controls.output=checkbox(main,"RP-Textausgabe aktiv",20,-123,function(enabled)
        local addon=current();if not addon then return end
        local memory=db().previousChance
        if enabled then
            local value=tonumber(memory[selected]) or addon.defaults.textChance or 30
            if value<=0 then value=addon.defaults.textChance or 30 end
            setSetting("textChance",value)
        else
            if addon.db.textChance>0 then memory[selected]=addon.db.textChance end
            setSetting("textChance",0)
        end
        refresh()
    end)
    makeText(main,"Textwahrscheinlichkeit",20,-169)
    controls.chanceValue=makeText(main,"",205,-169,65)
    button(main,"- 10 %",290,-164,82,function()
        local a=current();if not a then return end
        setSetting("textChance",math.max(0,(tonumber(a.db.textChance) or 0)-10));refresh()
    end)
    button(main,"+ 10 %",385,-164,82,function()
        local a=current();if not a then return end
        setSetting("textChance",math.min(100,(tonumber(a.db.textChance) or 0)+10));refresh()
    end)
    makeText(main,"Textsprache",20,-211)
    controls.lang=dropdown(main,170,-207,155,{{"deDE","Deutsch"},{"enUS","English"},{"frFR","Francais"}},function(v)setSetting("outputLanguage",v);refresh() end)
    controls.channelLabel=makeText(main,"Ausgabekanal",20,-250)
    controls.channel,controls.channelFrame=dropdown(main,170,-246,155,{
        {"SAY","Sagen"},{"YELL","Schreien"},{"PARTY","Gruppe"},
        {"RAID","Schlachtzug"},{"INSTANCE_CHAT","Instanz"},{"AUTO","Automatisch"},{"GROUP","Gruppenkanal"}
    },function(v)setSetting("chatChannel",v);refresh() end)
    controls.raceLabel=makeText(main,"Volkssprache (nur RPChatMod)",20,-290,235)
    controls.race=dropdown(main,275,-286,165,{{"auto","Automatisch"},{"on","Erzwingen"},{"off","Aus"}},function(v)setSetting("racialLanguageMode",v);refresh() end)
    controls.group=checkbox(main,"Gruppensprache verwenden (nur RPChatMod)",20,-326,function(v)
        setSetting("groupLanguageMode",v and "on" or "off");refresh()
    end)
    controls.native=checkbox(main,"Native WoW-Emotes (nur RPChatMod)",20,-359,function(v)
        setSetting("nativeEmotes",v);refresh()
    end)
    controls.debug=checkbox(main,"Diagnosemeldungen bei Aenderungen",20,-392,function(v)
        db().debug=v;refresh()
    end)
    controls.ambientLabel=makeText(main,"Ambient-System (Hexer/Jäger/Paladin/Druide)",20,-431,520)
    controls.ambient=checkbox(main,"Ambient aktiviert",20,-458,function(value)
        local a=current(); if not a or type(a.db.ambientEnabled) ~= "boolean" then return end
        setSetting("ambientEnabled",value)
        if a.ResetAmbientTimer then a.ResetAmbientTimer() end
        refresh()
    end)
    controls.ambientCombat=checkbox(main,"Ambient im Kampf zulassen",245,-458,function(value)
        setSetting("ambientInCombat",value);refresh()
    end)
    controls.ambientChance=makeText(main,"Ambient-Chance: --",20,-500,220)
    button(main,"- 10 %",250,-494,80,function()
        local a=current();if not a or type(a.db.ambientChance)~="number" then return end
        setSetting("ambientChance",math.max(0,a.db.ambientChance-10));refresh()
    end)
    button(main,"+ 10 %",340,-494,80,function()
        local a=current();if not a or type(a.db.ambientChance)~="number" then return end
        setSetting("ambientChance",math.min(100,a.db.ambientChance+10));refresh()
    end)
    controls.ambientInterval=makeText(main,"Ambient-Intervall: --",20,-545,280)
    button(main,"Test Ambient",390,-541,165,function()
        local a=current()
        if not a or type(a.TryAmbient)~="function" then info("Ambient nicht verfuegbar.");return end
        if not a.TryAmbient(nil,true) then info("Ambient-Ausgabe blockiert: Klasse, Kampf, Cooldown oder deaktiviert.") end
    end)
    makeText(main,"Magier: volkstypische Zaubertexte",20,-605,300)
    controls.mageRaceValue=makeText(main,"--",305,-605,70)
    controls.mageRaceMinus=button(main,"- 10 %",390,-600,85,function()
        local a=current()
        if selected~="MagierRP" or not a or type(a.db.racialTextChance)~="number" then return end
        setSetting("racialTextChance",math.max(0,a.db.racialTextChance-10))
        refresh()
    end)
    controls.mageRacePlus=button(main,"+ 10 %",480,-600,85,function()
        local a=current()
        if selected~="MagierRP" or not a or type(a.db.racialTextChance)~="number" then return end
        setSetting("racialTextChance",math.min(100,a.db.racialTextChance+10))
        refresh()
    end)
    controls.statusButton=button(main,"Sprachstatus",390,-572,150,function()
        local a=_G.RPChatMod
        if a and a.ready and a.HandleCommand then a.HandleCommand("languagestatus")
        else info("RPChatMod ist nicht geladen") end
    end)
    button(main,"Hilfe",20,-572,90,function()
        info("/rpconfig zeigt die GUI. Einstellungen werden pro Charakter gespeichert.")
        info("0% Textchance unterdrueckt Texte, nicht unbedingt Emote-Animationen.")
        info("Debug protokolliert Aenderungen im Control Center; kein globales AddOn-Log.")
    end)
end
refresh=function()
    if not main then return end
    controls.selectAddon(selected)
    local a=current()
    controls.status:SetText(a and ("Aktiv: " .. selected .. " | gespeicherte Charaktereinstellungen") or (selected .. " ist nicht geladen / nicht bereit"))
    local present=a~=nil
    local d=present and a.db or {}
    controls.output:SetChecked(present and (tonumber(d.textChance) or 0)>0)
    controls.chanceValue:SetText(present and (tostring(d.textChance).." %") or "--")
    controls.lang(d.outputLanguage or "deDE")
    controls.channel(d.chatChannel or "SAY")
    if selected=="MagierRP" then
        controls.channelLabel:Hide()
        controls.channelFrame:Hide()
    else
        controls.channelLabel:Show()
        controls.channelFrame:Show()
    end
    local rc=present and selected=="RPChatMod"
    controls.race(d.racialLanguageMode or "auto")
    controls.group:SetChecked(rc and d.groupLanguageMode=="on")
    controls.native:SetChecked(rc and d.nativeEmotes and true or false)
    controls.raceLabel:SetText("Volkssprache"..(rc and "" or " (nur RPChatMod)"))
    local ambientAvailable=present and type(d.ambientEnabled)=="boolean" and type(a.TryAmbient)=="function"
    controls.ambient:SetChecked(ambientAvailable and d.ambientEnabled)
    controls.ambient:SetEnabled(ambientAvailable)
    controls.ambientCombat:SetChecked(ambientAvailable and d.ambientInCombat)
    controls.ambientCombat:SetEnabled(ambientAvailable)
    controls.ambientChance:SetText(ambientAvailable and ("Ambient-Chance: "..tostring(d.ambientChance).." %") or "Ambient-Chance: --")
    controls.ambientInterval:SetText(ambientAvailable and ("Intervall: "..d.ambientMinInterval.." bis "..d.ambientMaxInterval.." Sekunden") or "Intervall: --")
    local mage = present and selected=="MagierRP" and type(d.racialTextChance)=="number"
    controls.mageRaceValue:SetText(mage and (tostring(d.racialTextChance).." %") or "--")
    controls.mageRaceMinus:SetEnabled(mage)
    controls.mageRacePlus:SetEnabled(mage)
    controls.debug:SetChecked(db().debug)
    -- Disable protected choices when the chosen addon is unavailable.
    controls.output:SetEnabled(present)
    controls.group:SetEnabled(rc)
    controls.native:SetEnabled(rc)
end
SLASH_RPCONTROLCENTER1="/rpconfig"
SLASH_RPCONTROLCENTER2="/rpcc"
SlashCmdList["RPCONTROLCENTER"]=function(message)
    create()
    if main:IsShown() then main:Hide() else refresh();main:Show() end
end
local events=CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent",function() db();info("geladen: /rpconfig") end)
