--[[
[ScreenSelectMusic]
InitCommand=%SetWheelCacheInit
[MusicWheelItem]
SectionOnCommand=%function(self) SetWheelGroupInit(self) end
[TextBanner]
ArtistOnCommand=hidden,1;...
TwoLinesArtistCommand=%SetWheelMeterInit
ThreeLinesArtistCommand=%SetWheelMeterInit
]]

local function FindSongSteps(main,sub,artist)
    for _,s in ipairs(SONGMAN:GetAllSongs()) do
        if (main==s:GetDisplayMainTitle() or main==s:GetTranslitMainTitle()) and
           (sub==s:GetDisplaySubTitle() or sub==s:GetTranslitSubTitle()) and
           (artist==s:GetDisplayArtist() or artist==s:GetTranslitArtist()) then
    -- song found
    local song=s
    if CurStyleName()=="single" or CurStyleName()=="versus" then
        s=song:GetStepsByStepsType(STEPS_TYPE_DANCE_SINGLE)
    elseif CurStyleName()=="double" then
        s=song:GetStepsByStepsType(STEPS_TYPE_DANCE_DOUBLE)
    elseif CurStyleName()=="couple" then 
        s=song:GetStepsByStepsType(STEPS_TYPE_DANCE_COUPLE)
    else s={} end
    -- i'm curless about style and stepstype so there it is
    local steps={}
    for n=1,#s do
        m=1
        for i,a in ipairs(s) do
            if a:GetDifficulty()<s[m]:GetDifficulty() or
               (a:GetDifficulty()==s[m]:GetDifficulty() and (a:GetMeter()<s[m]:GetMeter() or
               (a:GetMeter()==s[m]:GetMeter() and a:GetDescription()<s[m]:GetDescription()))) then
                m=i
            end
        end
        table.insert(steps,s[m])
        table.remove(s,m)
    end
    -- sort system [/Scripts/Mods.lua->CaptureSteps()]
    if #steps~=0 then return {song,steps,false} end
    -- third attr is a safty lock bool to avoid tween overflow
    end end
end

local function GetIntendedSteps(steps,pl)
    if not GAMESTATE:IsPlayerEnabled(pl) then return end
    if GAMESTATE:GetCurrentSteps(pl) then
        for _,s in ipairs(steps) do
            if s==GAMESTATE:GetCurrentSteps(pl) then return s end
        end
    end
    -- set current steps for multiple edit charts
    local diff=GAMESTATE:GetPreferredDifficulty(pl)
    for _,s in ipairs(steps) do
        if s:GetDifficulty()==diff then return s end
    end
    -- Difficulty = diff+-0
    for delta=1,5 do
        if diff-delta>=DIFFICULTY_BEGINNER then for _,s in ipairs(steps) do
            if s:GetDifficulty()==diff-delta then return s end
        end end
        if diff+delta<=DIFFICULTY_EDIT then for _,s in ipairs(steps) do
            if s:GetDifficulty()==diff+delta then return s end
        end end
    end
    -- Difficulty = diff+-delta
end

--========================--

local ch_s={}

local function SetWheelSongCacheInit() ch_s={} end

local function SetWheelMeter(self)
    local adr=string.sub(tostring(self),-9,-2)
    local steps=GetIntendedSteps(ch_s[adr][2],PLAYER_1)
    if not steps then self:settext("") return end
    self:glow(DifficultyColorRGB(steps:GetDifficulty()))
    self:settext(steps:GetMeter()>999 and "???" or tostring(steps:GetMeter()))
end

local function SetWheelGrade(self,pl)
    local adr=string.sub(tostring(self),-9,-2)
    local steps=GetIntendedSteps(ch_s[adr][2],pl)
    if not steps then return end
    local wi=self:GetParent():GetParent()
    local grade=wi("GradeP"..pl.."Sprite")
    local r,g,b,a=grade:getdiffuse()
    if a==1 and steps:GetDifficulty()==(GAMESTATE:GetCurrentSteps(pl)
                                        and GAMESTATE:PlayerDifficulty(pl)
                                        or  GAMESTATE:GetPreferredDifficulty(pl)) then return end
    local score=(PROFILEMAN:IsPersistentProfile(pl)
                 and PROFILEMAN:GetProfile(pl)
                 or  PROFILEMAN:GetMachineProfile())
                :GetHighScoreForSongAndSteps(ch_s[adr][1],steps:GetDifficulty())
    if not score then grade:diffusealpha(0) return end
    grade:diffusealpha(0.5)
    grade:setstate(GetGradeFromPercent(score:GetPercentDP())*2+pl)
end

local function SetWheelSafetyLock(self)
    local adr=string.sub(tostring(self),-9,-2)
    if not ch_s[adr][3] then
        ch_s[adr][3]=true
        local wi=self:GetParent():GetParent()
        wi("GradeP0Sprite"):addx(SCREEN_WIDTH)
        wi("GradeP1Sprite"):addx(SCREEN_WIDTH)
        self:queuecommand("SafetyUnlock")
    end
end

local function SetWheelSafetyUnlock(self)
    SetWheelGrade(self,PLAYER_1)
    SetWheelGrade(self,PLAYER_2)
    local wi=self:GetParent():GetParent()
    wi("GradeP0Sprite"):addx(-SCREEN_WIDTH)
    wi("GradeP1Sprite"):addx(-SCREEN_WIDTH)
    local adr=string.sub(tostring(self),-9,-2)
    ch_s[adr][3]=false
end

function SetWheelMeterInit(self)
    local wi=self:GetParent():GetParent()
    if not wi or wi:GetName()~="MusicWheelItem" then return end
    local adr=string.sub(tostring(self),-9,-2)
    local title=self:GetParent()
    ch_s[adr]=FindSongSteps(title(1):GetText(),title(2):GetText(),title(3):GetText())
    if ch_s[adr] then
        if self:GetHidden() then
            self:addcommand("CurrentStepsP1ChangedMessage",function(self)
                SetWheelMeter(self)
                SetWheelSafetyLock(self)
            end)
            self:addcommand("CurrentStepsP2ChangedMessage",SetWheelSafetyLock)
            self:addcommand("CurrentSongChangedMessage",SetWheelSafetyLock)
            self:addcommand("SafetyUnlock",SetWheelSafetyUnlock)
            self:hidden(0)
        end
        SetWheelMeter(self)
        SetWheelSafetyLock(self)
    elseif not self:GetHidden() then
        self:removecommand("CurrentStepsP1ChangedMessage")
        self:removecommand("CurrentStepsP2ChangedMessage")
        self:removecommand("CurrentSongChangedMessage")
        self:removecommand("SafetyUnlock")
        self:hidden(1)
    end
end

--========================--

local ch_g={}

local function SetWheelGroupCacheInit()
    ch_g={}
    for _,s in ipairs(SONGMAN:GetAllSongs()) do
        local group=s:GetGroupName()
        local steps={}
        if CurStyleName()=="single" or CurStyleName()=="versus" then
            steps=s:GetStepsByStepsType(STEPS_TYPE_DANCE_SINGLE)
        elseif CurStyleName()=="double" then
            steps=s:GetStepsByStepsType(STEPS_TYPE_DANCE_DOUBLE)
        elseif CurStyleName()=="couple" then 
            steps=s:GetStepsByStepsType(STEPS_TYPE_DANCE_COUPLE)
        end
        if #steps~=0 then ch_g[group]=(ch_g[group] or 0)+1 end
    end
    for s,i in pairs(ch_g) do
        if i>999 then ch_g[s]="???" end
    end
end

local function SetWheelGroupCounts(self)
    iSection=iSection+1
    self:glow(ColorRGB(math.abs(math.mod(iSection,8)-4)-2))    
    self:zoom(0.5)
    self:maxwidth(400*((SCREEN_WIDTH/SCREEN_HEIGHT)/(4/3)))
    self:zoomx(0.5/((SCREEN_WIDTH/SCREEN_HEIGHT)/(4/3)))
    witmp=self
    if GAMESTATE:GetSortOrder()==SORT_GROUP and self:GetParent() and
       not self:GetHidden() and self:GetParent()("CourseName"):GetHidden() then
        local elm=self:GetParent()("CourseName")
        elm:x(140/((SCREEN_WIDTH/SCREEN_HEIGHT)/(16/9))
                +88.125*((SCREEN_WIDTH/SCREEN_HEIGHT)-(16/9)))
        elm:diffuse(0.71,0.72,0.73,1)
        elm:horizalign("center")
        elm:settext(ch_g[self:GetText()] or "0")
        elm:hidden(0)
    end
        local elm=self:GetParent()("CourseName")
        elm:x(150/((SCREEN_WIDTH/SCREEN_HEIGHT)/(4/3)))
        -- or IDK it's kind of good value
end

local function SetWheelGroupRefresh(self)
    SetWheelGroupCounts(self)
    self:sleep(0.1)
    self:queuecommand("RefreshGroup")
end

local iSection=0

function SetWheelGroupInit(self)
    iSection=iSection+1
    self:glow(ColorRGB(math.abs(math.mod(iSection,8)-4)-2))
    self:zoom(0.3)
    self:maxwidth(650*((SCREEN_WIDTH/SCREEN_HEIGHT)/(4/3)))
    self:zoomx(0.3/((SCREEN_WIDTH/SCREEN_HEIGHT)/(4/3)))
    self:addcommand("RefreshGroup",SetWheelGroupRefresh)
    self:addcommand("CurrentSongChangedMessage",SetWheelGroupCounts)
    self:queuecommand("RefreshGroup")
end

--========================--

function SetWheelCacheInit()
    SetWheelSongCacheInit()
    SetWheelGroupCacheInit()
end
