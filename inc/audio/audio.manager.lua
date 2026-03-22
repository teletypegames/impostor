--- @section Audio

Audio = {
    music_playing = nil
}

--- Stops current music.
--- @within Audio
function Audio.music_stop()
    music()
    Audio.music_playing = nil
end

--- Plays track, doesn't restart if already playing.
function Audio.music_play(track)
    if Audio.music_playing ~= track then
        music(track)
        Audio.music_playing = track
    end
end

--- Plays main menu music.
--- @within Audio
function Audio.music_play_mainmenu() end

--- Plays mystery man music.
--- @within Audio
function Audio.music_play_mystery() Audio.music_play(2) end

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
--- @within Audio
function Audio.music_play_room_() end

--- Plays room work music.
--- @within Audio
function Audio.music_play_room_work() Audio.music_play(0) end

--- Plays activity work music.
--- @within Audio
function Audio.music_play_activity_work() Audio.music_play(1) end

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

--- Plays alarm sound effect
--- @within Audio
function Audio.sfx_alarm() sfx(34, "C-5", 240) end

--- Plays drum sound effect.
---  @within Audio
function Audio.sfx_drum_low() sfx(61, "C-2") end

--- Plays drum sound effect.
---  @within Audio
function Audio.sfx_drum_high() sfx(61, "C-6") end

--- Plays sound effect for arrow hit
--- @within Audio
--- @param note string The note for the sound to play
function Audio.sfx_arrowhit(note) sfx(56, note) end
