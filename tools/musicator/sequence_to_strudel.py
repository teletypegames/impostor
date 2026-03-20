import sys
import re

ROWS_PER_BEAT = 4   # keep consistent with your MIDI extraction
SOUND = "piano"

def parse_sequence(text):
    return re.findall(r'"([^"]+)"', text)

def to_strudel_notes(seq):
    out = []
    for n in seq:
        if n == "..." or n == "---":
            out.append("~")
        else:
            # C-5 → c5, C#5 → c#5
            note = n.replace("-", "")
            out.append(note.lower())
    return out

def chunk(seq, size):
    for i in range(0, len(seq), size):
        yield seq[i:i+size]

# read from stdin
text = sys.stdin.read()

sequence = parse_sequence(text)
notes = to_strudel_notes(sequence)

# group into musical lines (4 beats)
lines = []
for group in chunk(notes, ROWS_PER_BEAT * 4):
    lines.append(" ".join(group))

pattern = "\n".join(lines)

print("note(`")
print(pattern)
print(f"`).sound(\"{SOUND}\")")

# npm install -g strudel-cli
