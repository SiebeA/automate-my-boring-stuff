from bs4 import BeautifulSoup
import re

input_text = """
Anderson: y también la referencia cualitativa que simplemente necesitábamos, creo,
   and then this qualitative reference that we simply needed,

para discernir como posibilidad.
it seems to me, to discern as a possibility.

De nuevo recuerdo una declaración que hizo y anteriormente cité
I am reminded again of the statement that you made that I quoted earlier,

'Es la responsabilidad de todos, de cada persona'.
that it is the responsibility of each, each human person.

Krishnamurti: Del ser humano, sí. 
   Human being, yes. 

Anderson: Exacto.
   Right.
"""

# Create BeautifulSoup object
soup = BeautifulSoup(input_text, 'html.parser')

# Create an empty list to store formatted lines
formatted_lines = []
speaker = None  # Initialize speaker variable
dialogue_accumulator = []  # Initialize dialogue accumulator

# Iterate over each line in the input text
for line in soup.get_text().split('\n'):
    line = line.strip()
    if not line:
        continue
    # Check if the line contains a colon
    if ':' in line:
        # If yes, update the speaker and format the accumulated dialogue
        if speaker:
            formatted_dialogue = ''
            for i, dialogue_line in enumerate(dialogue_accumulator):
                if i % 2 == 0 and i > 0:
                    formatted_dialogue += '<br/>\n\t\t\t'
                formatted_dialogue += dialogue_line
            formatted_line = f'<tr class="first-child1">\n\t<td epub:type="z3998:persona" class="epub-type-z3998-persona1"><b>{speaker}</b></td>\n\t<td class="epub-type-z3998-verse">\n\t\t<p class="first-child3">\n\t\t\t<span class="calibre19">{formatted_dialogue}</span>\n\t\t</p>\n\t</td>\n</tr>'
            formatted_lines.append(formatted_line)
        speaker, dialogue = re.split(r':\s+', line, maxsplit=1)
        dialogue_accumulator = [dialogue.strip()]
    else:
        # If no, append the dialogue to the dialogue accumulator
        if speaker:
            dialogue_accumulator.append(line)

# Format the last accumulated dialogue
if speaker and dialogue_accumulator:
    formatted_dialogue = ''
    for i, dialogue_line in enumerate(dialogue_accumulator):
        if i % 2 == 0 and i > 0:
            formatted_dialogue += '<br/>\n\t\t\t'
        formatted_dialogue += dialogue_line
    formatted_line = f'<tr class="first-child1">\n\t<td epub:type="z3998:persona" class="epub-type-z3998-persona1"></td>\n\t<td class="epub-type-z3998-verse">\n\t\t<p class="first-child3">\n\t\t\t<span class="calibre19">{formatted_dialogue}</span>\n\t\t</p>\n\t</td>\n</tr>'
    formatted_lines.append(formatted_line)

# Join the formatted lines
output_text = '\n'.join(formatted_lines)

# Add the necessary HTML tags
final_output = f'<table class="calibre17">\n\t<tbody class="calibre18">\n{output_text}\n\t</tbody>\n</table>'

# Write final output to a text file
with open("output.txt", "w") as file:
    file.write(final_output)
