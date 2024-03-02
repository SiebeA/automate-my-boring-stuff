from bs4 import BeautifulSoup
import re

# Specify the path to the input text file
input_file_path = r'C:\Users\Siebe\Desktop\Spanish Subtitles to book\Krishnamurti\input.txt'

# Open the input text file and read its contents
with open(input_file_path, 'r', encoding='utf-8') as input_file:
    input_text = input_file.read()

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
    # Debugging: print the content of the line
    print("Line:", line)
    # Check if the line contains a colon
    if ':' in line:
        # If yes, update the speaker and format the accumulated dialogue
        if speaker:
            formatted_dialogue = ''
            for i, dialogue_line in enumerate(dialogue_accumulator):
                if i % 2 == 0 and i > 0:
                    formatted_dialogue += '<br/>\n\t\t\t'
                formatted_dialogue += f'- {dialogue_line.strip()} <br/>'
            formatted_line = f'<tr class="first-child1">\n\t<td epub:type="z3998:persona" class="epub-type-z3998-persona1"><b>{speaker}</b></td>\n\t<td class="epub-type-z3998-verse">\n\t\t<p class="first-child3">\n\t\t\t<span class="calibre19">{formatted_dialogue}</span>\n\t\t</p>\n\t</td>\n</tr>'
            formatted_lines.append(formatted_line)
        # Split the line into speaker and dialogue
        try:
            speaker, dialogue = re.split(r':\s+', line, maxsplit=1)
        except ValueError:
            print("Error: Could not split line into speaker and dialogue:", line)
            continue
        dialogue_accumulator = [dialogue.strip()]
    else:
        # If no colon is found, append the dialogue to the accumulator
        if speaker:
            dialogue_accumulator.append(line)

# Format the last accumulated dialogue
if speaker and dialogue_accumulator:
    formatted_dialogue = ''
    for i, dialogue_line in enumerate(dialogue_accumulator):
        if i % 2 == 0 and i > 0:
            formatted_dialogue += '<br/>\n\t\t\t'
        formatted_dialogue += f'- {dialogue_line.strip()} <br/>'
    formatted_line = f'<tr class="first-child1">\n\t<td epub:type="z3998:persona" class="epub-type-z3998-persona1"></td>\n\t<td class="epub-type-z3998-verse">\n\t\t<p class="first-child3">\n\t\t\t<span class="calibre19">{formatted_dialogue}</span>\n\t\t</p>\n\t</td>\n</tr>'
    formatted_lines.append(formatted_line)

# Join the formatted lines
output_text = '\n'.join(formatted_lines)

# Add the necessary HTML tags
final_output = f'<table class="calibre17">\n\t<tbody class="calibre18">\n{output_text}\n\t</tbody>\n</table>'

# Write final output to a text file
with open("output.txt", "w") as file:
    file.write(final_output)

print("HTML output saved to output.txt")
