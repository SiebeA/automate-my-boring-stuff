from bs4 import BeautifulSoup
import re

def create_ebook_html(text):
    lines = text.split('\n')
    html = '<body class="calibre5">\n\n'
    current_speaker = None

    for line in lines:
        line = line.strip()
        if not line:
            continue

        if ":" in line:
            speaker, dialogue = line.split(":", 1)
            speaker = speaker.strip()
            dialogue = dialogue.strip()
        else:
            # If no colon is found, assume the entire line is dialogue
            speaker = current_speaker
            dialogue = line.strip()

        if speaker != current_speaker:
            if current_speaker:
                html += '</table>\n\n'
            html += f'<h3 class="h">{speaker}</h3>\n\n'
            html += '<table border="0" cellpadding="0" cellspacing="0" class="calibre12">\n'
            current_speaker = speaker

        html += '<tr class="calibre13">\n'
        html += '  <td class="calibre14">\n'
        html += '    <p class="hanginga">           </p>\n'
        html += '  </td>\n'
        html += f'  <td class="calibre15">\n    <p class="hanging">{dialogue}</p>\n  </td>\n'
        html += '</tr>\n'

    html += '</table>\n</body>'
    return html

# Specify the path to the input text file
input_file_path = r'C:\Users\Siebe\Desktop\Spanish Subtitles to book\Krishnamurti\input.txt'

# Open the input text file and read its contents
with open(input_file_path, 'r', encoding='utf-8') as input_file:
    input_text = input_file.read()


html_output = create_ebook_html(input_text)

# Write final HTML output to a text file
output_file_path = "output.txt"
with open(output_file_path, "w", encoding='utf-8') as output_file:
    output_file.write(html_output)

print("HTML output saved to output.txt")