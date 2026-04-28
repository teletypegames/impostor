--- @section Audio

Audio = {
    music_playing = nil,
    music_playing_tempo = nil,
}

--- Stops current music.
--- @within Audio
function Audio.music_stop()
    music()
    Audio.music_playing = nil
    Audio.music_playing_tempo = nil
end

--- Plays track at optional speed. Doesn't restart if track and speed are unchanged.
--- @param track number Track index.
--- @param[opt] speed number TIC-80 music speed override (-1 = default).
function Audio.music_play(track, speed)
    if Audio.music_playing ~= track or Audio.music_playing_tempo ~= speed then
        music(track, -1, -1, true, false, -1, speed or -1)
        Audio.music_playing = track
        Audio.music_playing_tempo = speed
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

--- Plays room work music. Speed scales with commute glitch level when active.
--- @within Audio
function Audio.music_play_room_work(speed)
    Audio.music_play(0, speed or -1)
end

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
