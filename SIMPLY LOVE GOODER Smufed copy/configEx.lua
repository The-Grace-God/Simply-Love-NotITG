-- ========================
-- Extra Configuration File
-- ========================
-- Extra contents read by stitch("configEx").YourPref
-- just use for this theme

return stitch("config").configEx or {
    -- put true to change window title
    -- put false to deactivate
    FunnyTitleActivate = true,
    -- color of header and footer
    -- put string comes after "diffuse,"
    ColorHeader = "#00000044",
    -- put funny text on result
    TextFantastic = "Fanta",
    TextExcellent = "Exclennet",
    TextGreat     = '"Great"',
    TextDecent    = "Decent",
    TextWayOff    = "Way Off",
    TextMiss      = "FUCK",
    TextHolds     = "Holds",
    TextMines     = "Mines",
    TextHands     = "Hands",
    TextRolls     = "Rolls",
    -- label of InputType device
    -- default: 2="DancePad", 3="Keyboard"
    InputDevice2 = "DancePad",
    InputDevice3 = "Keyboard",
    -- color of system message frame
    -- put the ratio of color {red,green,bule}
    ColorMsg = {0.30,0.70,0.10},
    -- put true to change color of chart difficulty
    -- put false to deactivate
    ColorDiffActivate = false,
    -- color of chart difficulty
    -- put the ratio of color {red,green,bule}
    ColorNovc = {0.10,0.40,0.90},
    ColorEasy = {0.10,0.80,0.20},
    ColorMedm = {0.90,0.90,0.00},
    ColorHard = {1.00,0.50,0.00},
    ColorExpt = {1.00,0.00,0.25},
    ColorEdit = {0.70,0.00,0.70},
}
