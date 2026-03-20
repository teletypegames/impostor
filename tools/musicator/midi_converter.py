from mido import MidiFile

MIDI_FILE = "/tmp/teletype_impostor_musicator/maestro-v3.0.0/2018/MIDI-Unprocessed_Schubert7-9_MID--AUDIO_16_R2_2018_wav.midi"

# resolution: rows per beat (e.g. 4 = 16th notes)
ROWS_PER_BEAT = 4

names = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]

def note_name(n):
    octave = n // 12 - 1
    return f"{names[n % 12]}-{octave}"

mid = MidiFile(MIDI_FILE)
tpb = mid.ticks_per_beat

row_ticks = tpb // ROWS_PER_BEAT

time = 0
rows = {}

for msg in mid:
    time += msg.time
    if msg.type == "note_on" and msg.velocity > 0:
        row = int(time // row_ticks)
        rows.setdefault(row, []).append(msg.note)

# build monophonic sequence (highest note wins)
max_row = max(rows.keys())
sequence = []

for r in range(max_row + 1):
    if r in rows:
        n = max(rows[r])
        sequence.append(note_name(n))
    else:
        sequence.append("...")

# trim (optional)
sequence = sequence[:512]

# output as Lua
print("sequence = {")
for n in sequence:
    print(f'  "{n}",')
print("}")
