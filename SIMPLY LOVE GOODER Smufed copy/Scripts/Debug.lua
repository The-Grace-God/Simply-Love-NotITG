-- =======================
-- Debug console functions
-- =======================
-- This file contains some functions just for debug console.
-- You can call debug console by doing Ctrl+9 on any screen.
-- (if you don't change console value on NotITG/Data/config.lua)
-- So these functions will be useful. Maybe. I guess?

-- exit() / restart()
-- Shutdown the game. / Reboot the game.
--
-- note:
--   restart() requires [ScreenRestart] in metrics.ini
--   (already included in oats-fork or fork-n-edit theme)
--[[
[ScreenRestart]
Class=ScreenExitCommand
ExecPath="explorer"
ExecParams=@'".\\Program\\NotITG-'..GetProductVer()..'.exe"'
]]
--
-- usage:
--   exit''
--   restart""
function exit() SCREENMAN:SetNewScreen('ScreenExit') end
function restart() SCREENMAN:SetNewScreen('ScreenRestart') end

-- RemoveScore(name,diff)
-- Removing machine and card's score. Recommand use on SongSelect.
--
-- name: put song's FOLDER name (optional)
--   if you skip this, focued song on SongSelect will be choose
--   check folder name by doing Ctrl+o (o of open) on SongSelect
--
-- diff: put number of chart difficulty (optional)
--   (none) or -1 = all charts
--   0=Novice, 1=Easy, 2=Medium, 3=Hard, 4=Expert, 5=Edit
--
-- usage:
--   RemoveScore()
--   RemoveScore(4)
--   RemoveScore "folder name"
--   RemoveScore("folder name",4)
function RemoveScore(name,diff)
    local Prof={PROFILEMAN:GetMachineProfile()}
    local NumPL=GAMESTATE:GetNumPlayersEnabled()
    if not (PROFILEMAN and PROFILEMAN:GetMachineProfile()) then
        Debug("Machine profile dosen't exist.")
        return
    end
    if NumPL==0 then
        Debug("Player dosen't exist. Remove machine scores only.")
    else for i=1,NumPL do if PROFILEMAN:IsPersistentProfile(i-1) then
        table.insert(Prof,PROFILEMAN:GetProfile(i-1))
    end end end

    local song
    if type(name)=="number" and diff==nil then
        diff=name; name=nil
    end
    if type(name)=="string" then
        song=SONGMAN:FindSong(name)
        if song==nil then
            Debug('Song folder "'..name..'" dosen\'t exist.')
            return
        end
    else
        song=GAMESTATE:GetCurrentSong()
        name=song
        if song==nil then
            Debug('Current song is nothing.')
            return
        end
    end

    if diff==nil or diff==-1 then
        for _,p in ipairs(Prof) do
            p:ClearHighScoresForSong(name)
        end
        Debug('Score of "'..song:GetTranslitMainTitle()..'" is removed.')
    else
        for _,p in ipairs(Prof) do
            p:ClearHighScoresForSongAndSteps(name,diff)
        end
        Debug('Score of "'..song:GetTranslitMainTitle()..'" on '
                          ..DifficultyToThemedString(diff)..' is removed.')
    end
end
