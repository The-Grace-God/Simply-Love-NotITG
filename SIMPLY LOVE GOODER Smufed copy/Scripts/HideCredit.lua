--[[
[ScreenGameplay]
MemoryCardDisplayP1OnCommand=%function(self) self:cmd("...") HideCreditSetup(1,self) end
MemoryCardDisplayP2OnCommand=%function(self) self:cmd("...") HideCreditSetup(2,self) end

[ScreenSystemLayer]
MessageOnCommand=queuecommand,Trigger;...
]]

local function OVERLAYMAN(scr)
    if scr==nil then return SCREENMAN:GetOverlayScreens() end
    if type(scr)=="number" then return SCREENMAN:GetOverlayScreens()[i] end
    if type(scr)=="string" then for _,s in ipairs(SCREENMAN:GetOverlayScreens()) do
        if s:GetName()==scr then return s end
    end end
end

function HideCreditSetup(pl,MemoryPn)
    if _FE_PROF().HideCredit==4 then return end

    local CreditPn=OVERLAYMAN("ScreenSystemLayer")("CreditsP"..pl)
    local AutoText=OVERLAYMAN("ScreenSyncOverlay")(3)
    local SystemMsg=OVERLAYMAN("ScreenSystemLayer")("Message")

    CreditPn:diffusealpha(0)
    MemoryPn:diffusealpha(0)
    
    if pl==2 then
        AutoText:hidden(1)

        MemoryPn:addcommand("Trigger",function(self) HideCreditUpdate(true) end)
        MemoryPn:queuecommand("Trigger")
        
        if _FE_PROF().HideCredit~=1 then
            if not SystemMsg:hascommand("Trigger") then
                SystemMsg:addcommand("Trigger",function(self)
                    if not HideCreditUpdate() then self:removecommand("Trigger") end
                end)
            end
            MemoryPn:addcommand("Off",function(self)
                OVERLAYMAN("ScreenSystemLayer")("Message"):removecommand("Trigger") -- SystemMsg
            end)
        end
    end
end

function HideCreditUpdate(init)
    if not init and (_FE_PROF().HideCredit==1 or string.sub(SCREENMAN():GetName(),7,16)~='Gameplay') then
        return false
    end
    
    local CreditP1=OVERLAYMAN("ScreenSystemLayer")("CreditsP1")
    local CreditP2=OVERLAYMAN("ScreenSystemLayer")("CreditsP2")
    local MemoryP1=SCREENMAN("MemoryCardDisplayP1")
    local MemoryP2=SCREENMAN("MemoryCardDisplayP2")
    local AutoText=OVERLAYMAN("ScreenSyncOverlay")(3)

    if init then
        CreditP1:diffusealpha(1)
        CreditP2:diffusealpha(1)
        MemoryP1:diffusealpha(1)
        MemoryP2:diffusealpha(1)
        AutoText:hidden(0)

        CreditP1:settext("")
        CreditP2:settext("")
        for i=1,6 do MemoryP1(i):hidden(1) end
        for i=1,6 do MemoryP2(i):hidden(1) end
    end

    if _FE_PROF().HideCredit==3 then
        local mode=PREFSMAN:GetPreference('AutoPlay')==1 and "AutoPlay" or
                   PREFSMAN:GetPreference('AutoPlay')==2 and "AutoCPU" or ""
        
        CreditP1:settext(mode)
        CreditP2:settext(mode)
        MemoryP1(4):hidden(mode=="" and 1 or 0)
        MemoryP2(4):hidden(mode=="" and 1 or 0)
    end

    if _FE_PROF().HideCredit~=1 then
        AutoText:hidden(PREFSMAN:GetPreference('AutoPlay'))
    end

    return true
end
