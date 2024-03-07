from bs4 import BeautifulSoup
import re

def create_ebook_html(text):
    lines = text.split('\n')
    lines = [line.strip() for line in text.split('\n') if line.strip()]

    html = '<body class="calibre5">\n\n'
    current_speaker = None

    for i in range(0, len(lines), 2):
        spanish_line = lines[i].strip()
        
        # Check if there's an English translation available
        if i + 1 < len(lines):
            english_line = lines[i + 1].strip()
        else:
            english_line = ''

        if not spanish_line:
            continue

        if ":" in spanish_line:
            speaker, spanish_dialogue = spanish_line.split(":", 1)
            speaker = speaker.strip()
            spanish_dialogue = spanish_dialogue.strip()
        else:
            speaker = current_speaker
            spanish_dialogue = spanish_line.strip()

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
        html += '  <td class="calibre15">\n'
        html += f'    <p class="hanging">{spanish_dialogue}<br/>{english_line}</p>\n'
        html += '  </td>\n'
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
