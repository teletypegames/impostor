--- @section Audio

--- Stops current music.
--- @within Audio
function Audio.music_stop() music() end
--- Plays main menu music.
--- @within Audio
function Audio.music_play_mainmenu() end
--- Plays waking up music.
--- @within Audio
function Audio.music_play_wakingup() end
--- Plays room morning music.
--- @within Audio
function Audio.music_play_room_morning() end
--- Plays room street 1 music.
---  @within Audio
function Audio.music_play_room_street_1() end
--- Plays room street 2 music.
--- @within Audio
function Audio.music_play_room_street_2() end
--- Plays room music.
-- TODO: function name is incomplete, determine the correct room identifier
--- @within Audio
function Audio.music_play_room_() end
--- Plays room work music.
--- @within Audio
function Audio.music_play_room_work() end

--- Plays select sound effect.
---  @within Audio
function Audio.sfx_select() sfx(17, 'C-7', 30) end
--- Plays deselect sound effect.
---  @within Audio
function Audio.sfx_deselect() sfx(18, 'C-7', 30) end
--- Plays beep sound effect.
---  @within Audio
function Audio.sfx_beep() sfx(19, 'C-6', 30) end
--- Plays success sound effect.
---  @within Audio
function Audio.sfx_success() sfx(16, 'C-7', 60) end
--- Plays bloop sound effect.
---  @within Audio
function Audio.sfx_bloop() sfx(21, 'C-3', 60) end
