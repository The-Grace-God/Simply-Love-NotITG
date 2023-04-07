-- avoid collision to oat-fork
function _FE_PROF(castDice)
	local saved = PROFILEMAN:GetMachineProfile():GetSaved()
	return castDice and {
		BackgroundShader=BackgroundShader_CastDice(saved.BackgroundShader),
		-- add here other options using random
	} or saved
end

local CUR_VER=10101

-- keep savedata compatibility
if not _FE_PROF() then
	PROFILEMAN:GetMachineProfile():GetSaved().Fork_n_Edit={ Version=CUR_VER }
else
	local version=_FE_PROF().Version or 0
	--[[
	if version<12000 then
		FixFoobarSavedata()
	end
	]]--
	if version>CUR_VER then
		SCREENMAN:SystemMessage(string.format(
			"WARNING: This theme version is older then save data version!\ntheme ver%d.%d.%d - save ver%d.%d.%d",
			CUR_VER/10000, CUR_VER/100%100, CUR_VER%100, version/10000, version/100%100, version%100
		))
	else _FE_PROF().Version = CUR_VER end
end

-- set defaults (note: if there seems like "rough", check the .editorconfig file)
_FE_PROF().DisplayFriendZ		= _FE_PROF().DisplayFriendZ			or 1
_FE_PROF().HideCredit			= _FE_PROF().HideCredit				or 2
_FE_PROF().ResultGif			= _FE_PROF().ResultGif				or 2
_FE_PROF().ResultText			= _FE_PROF().ResultText				or 2
_FE_PROF().ResultBar			= _FE_PROF().ResultBar				or 125
_FE_PROF().ResultPB				= _FE_PROF().ResultPB				or 3
_FE_PROF().FakeFailed			= _FE_PROF().FakeFailed				~= not true -- [nil->true]
_FE_PROF().DefaultInputType		= _FE_PROF().DefaultInputType		or 1
_FE_PROF().Apply2Both			= _FE_PROF().Apply2Both				~= not true
_FE_PROF().BackgroundShader		= _FE_PROF().BackgroundShader		or 1
_FE_PROF().RichPresence			= _FE_PROF().RichPresence			~= not true
_FE_PROF().ResultsAlpha			= _FE_PROF().ResultsAlpha			or 2 -- floating point
_FE_PROF().ShowHeaders			= _FE_PROF().ShowHeaders			~= not true
_FE_PROF().OATShowPlaytime			= _FE_PROF().OATShowPlaytime			~= not true
_FE_PROF().OATShowTotalPlaytime	= _FE_PROF().OATShowTotalPlaytime		~= not true
_FE_PROF().AggressiveRichPresence=_FE_PROF().AggressiveRichPresence	== not false -- [nil->false]
_FE_PROF().BackgroundBrightness	= _FE_PROF().BackgroundBrightness	or 5 -- floating point

_FE_PROF().InputTypeOffset2		= _FE_PROF().InputTypeOffset2		or ''
_FE_PROF().InputTypeOffset3		= _FE_PROF().InputTypeOffset3		or ''
_FE_PROF().TotalPlayedSongs		= _FE_PROF().TotalPlayedSongs		or 0
_FE_PROF().TotalPlayedFor		= _FE_PROF().TotalPlayedFor			or 0

-- keep total played count
local prof = PROFILEMAN:GetMachineProfile():GetSaved()
if prof.OATTotalPlayedFor and prof.OATTotalPlayedSongs then
	if prof.OATTotalPlayedFor>_FE_PROF().TotalPlayedFor then _FE_PROF().TotalPlayedFor=prof.OATTotalPlayedFor end
	if prof.OATTotalPlayedFor<_FE_PROF().TotalPlayedFor then prof.OATTotalPlayedFor=_FE_PROF().TotalPlayedFor end
	if prof.OATTotalPlayedSongs>_FE_PROF().TotalPlayedSongs then _FE_PROF().TotalPlayedSongs=prof.OATTotalPlayedSongs end
	if prof.OATTotalPlayedSongs<_FE_PROF().TotalPlayedSongs then prof.OATTotalPlayedSongs=_FE_PROF().TotalPlayedSongs end
else
	prof.OATTotalPlayedFor=_FE_PROF().TotalPlayedFor
	prof.OATTotalPlayedSongs=_FE_PROF().TotalPlayedSongs
end

function OptionDisplaySongSelectFriends()
	local t = OptionRowBase('SongSelectFriends',{'Mix Random','PixelJumpers','PixelJumpers+','Just SHAME','Karens','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().DisplayFriendZ] = true end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().DisplayFriendZ = i end end
		 
		 
	end
	return t
end

function OptionHideCredit()
	local t = OptionRowBase('HideCredit',{'On','HideAuto','CardAuto','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().HideCredit] = true end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().HideCredit = i end end
		 
		 
	end
	return t
end

function OptionDisplayResultGIF()
	local t = OptionRowBase('ResultGradeGIF',{'On','FunnyFail','Off','FunnyFail-ONLY'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().ResultGif] = true end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().ResultGif = i end end
		 
		 
	end
	return t
end

function OptionDisplayResultFunnyText()
	local t = OptionRowBase('ResultFunnyJudge',{'Text Only','Text with Animation','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().ResultText] = true end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().ResultText = i end end
		 
		 
	end
	return t
end

function OptionDisplayResultRatioBar()
	local t = OptionRowBase('ResultRatioBar',{'Full Bar','Half Bar','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list)
		for i,w in ipairs({125,62,0}) do if _FE_PROF().ResultBar==w then list[i] = true end end
	end
	t.SaveSelections = function(self, list)
		for i,w in ipairs({125,62,0}) do if list[i] then _FE_PROF().ResultBar = w end end
		 
		 
	end
	return t
end

function OptionDisplayResultBestScore()
	local t = OptionRowBase('ResultBestScore',{'Score Only','Diff. Only','Score and Diff.','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().ResultPB] = true end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().ResultPB = i end end
		 
		 
	end
	return t
end

function OptionFakeFailed()
	local t = OptionRowBase('FakeFailed',{'On','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().FakeFailed and 1 or 2] = true end
	t.SaveSelections = function(self, list)
		_FE_PROF().FakeFailed = list[1]
		 
		 
	end
	return t
end

function OptionDefaultInputType()
	local t = OptionRowBase('DefaultInputType',{'Off',stitch('configEx').InputDevice2,stitch('configEx').InputDevice3,'Auto(Card)','Auto(Connect)'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().DefaultInputType] = true end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().DefaultInputType = i end end
		 
		 
	end
	return t
end

function OptionApply2Both()
	local t = OptionRowBase('Apply2Both',{'On','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().Apply2Both and 1 or 2] = true end
	t.SaveSelections = function(self, list)
		_FE_PROF().Apply2Both = list[1]
		 
		 
	end
	return t
end

local shaders= { -- {choiceName,intensiveFlag}
	{'earthbound.frag'},
	{'plasma.frag'},
	{'topologica.frag',true},
	{'theyaremanycolors.frag'},
	{'descent.frag',true},
	{'rez_dubstepmyass.frag',true},
	{'rez_mynameisjulia.frag',true},
	{'rez_roadtohell.frag',true},
	{'rez_structures.frag',true},
	{'rez_thedescent.frag',true},
	{'solid color'},
	{'star factory'},
	{'glacia',true},
}
function OptionBackgroundShader()
	local t = OptionRowBase('BackgroundShader',{})
	t.OneChoiceForAllPlayers = true
	for _,v in ipairs(shaders) do table.insert(t.Choices,v[1]) end
	table.insert(t.Choices,"Random") -- -1
	table.insert(t.Choices,"Daily Random") -- -2
	t.LoadSelections = function(self, list)
		list[_FE_PROF().BackgroundShader<0 and #shaders-_FE_PROF().BackgroundShader or _FE_PROF().BackgroundShader] = true
	end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then
			_FE_PROF().BackgroundShader = i>#shaders and #shaders-i or i
			MESSAGEMAN:Broadcast('UpdateBackgroundShader')
		end end
	end
	return t
end
function BackgroundShader_CastDice(BackgroundShader)
	if BackgroundShader == -1 then
		-- Random
		math.randomseed(math.random()*1000000+Second()*Hour()*DayOfYear())
		return math.random(1,#shaders)
	elseif BackgroundShader == -2 then
		-- Daily Random
		math.randomseed(DayOfYear()+Year()*366)
		math.random() math.random() math.random() -- WDYM lua math.random has stacks???
		return math.random(1,#shaders)
	else
		return BackgroundShader
	end
end

function OptionRichPresence()
	local t = OptionRowBase('RichPresence',{'On','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().RichPresence and 1 or 2] = true end
	t.SaveSelections = function(self, list)
		_FE_PROF().RichPresence = list[1]
		 
		 
	end
	return t
end

function OptionResultsAlpha()
	local t = OptionRowBase('ResultsAlpha',{})
	t.OneChoiceForAllPlayers = true
	for i = 0,1,0.1 do table.insert(t.Choices, i) end
	t.LoadSelections = function(self, list) list[_FE_PROF().ResultsAlpha+1] = true return end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().ResultsAlpha = i-1 end end
		SCREENMAN:GetTopScreen()(1)(2):diffusealpha(0)
	end
	t.LayoutType = 'ShowOneInRow'
	return t
end

function OptionBackgroundBrightness()
	local t = OptionRowBase('BackgroundBrightness',{})
	t.OneChoiceForAllPlayers = true
	for i = 0,1,0.1 do table.insert(t.Choices, i) end
	t.LoadSelections = function(self, list) list[_FE_PROF().BackgroundBrightness+1] = true return end
	t.SaveSelections = function(self, list)
		for i,c in ipairs(list) do if c then _FE_PROF().BackgroundBrightness = i-1 end end
		 
		 
		MESSAGEMAN:Broadcast('UpdateBackgroundShader')
		SCREENMAN:GetTopScreen()(1)(2):diffusealpha(0.3)
	end
	t.LayoutType = 'ShowOneInRow'
	return t
end

function OptionShowPlaytime()
	local t = OptionRowBase('ShowPlaytime',{'On','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().OATShowPlaytime and 1 or 2] = true end
	t.SaveSelections = function(self, list)
		_FE_PROF().OATShowPlaytime = list[1]
		 
		 
	end
	return t
end

function OptionShowTotalPlaytime()
	local t = OptionRowBase('ShowTotalPlaytime',{'On','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().OATShowTotalPlaytime and 1 or 2] = true end
	t.SaveSelections = function(self, list)
		_FE_PROF().OATShowTotalPlaytime = list[1]
		 
		 
	end
	return t
end

function OptionAggressiveRichPresence()
	local t = OptionRowBase('AggressiveRichPresence',{'On','Off'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list) list[_FE_PROF().AggressiveRichPresence and 1 or 2] = true end
	t.SaveSelections = function(self, list)
		_FE_PROF().AggressiveRichPresence = list[1]
		 
		 
	end
	return t
end
