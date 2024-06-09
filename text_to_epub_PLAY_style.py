from bs4 import BeautifulSoup

def convert_gorgias_to_caesar_format(input_html_path, output_html_path):
    # Read the input HTML file
    with open(input_html_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Parse the HTML content
    soup = BeautifulSoup(content, 'html.parser')

    # Create a new BeautifulSoup object for the output
    new_soup = BeautifulSoup('<html><head></head><body></body></html>', 'html.parser')

    # Copy the head content
    new_soup.head.append(new_soup.new_tag('meta', charset='utf-8'))
    new_soup.head.append(new_soup.new_tag('title'))
    new_soup.title.string = soup.title.string

    # Add the CSS for formatting
    style_tag = new_soup.new_tag('style')
    style_tag.string = """
    .dialogue {
      display: table;
      width: 100%;
      margin-bottom: 10px;
    }
    .character {
      display: table-cell;
      width: 20%;
      font-weight: bold;
      vertical-align: top;
    }
    .speech {
      display: table-cell;
      width: 80%;
      padding-left: 10px;
    }
    """
    new_soup.head.append(style_tag)

    # Copy the body content
    new_soup.body.append(soup.h2)
    new_soup.body.append(soup.find('p', class_='p18'))
    new_soup.body.append(soup.find_all('p', class_='p18')[1])
    new_soup.body.append(soup.find('p', class_='p19'))

    # Process each paragraph in the original HTML
    for p in soup.find_all('p'):
        if ':' in p.text:
            character, speech = p.text.split(':', 1)
            dialogue_div = new_soup.new_tag('div', **{'class': 'dialogue'})
            character_div = new_soup.new_tag('div', **{'class': 'character'})
            character_div.string = character + ":"
            speech_div = new_soup.new_tag('div', **{'class': 'speech'})
            speech_div.string = speech.strip()
            dialogue_div.append(character_div)
            dialogue_div.append(speech_div)
            new_soup.body.append(dialogue_div)
        else:
            new_p = new_soup.new_tag('p')
            new_p.string = p.text
            new_soup.body.append(new_p)

    # Write the output HTML file
    with open(output_html_path, 'w', encoding='utf-8') as file:
        file.write(new_soup.prettify())

# Paths to the input and output HTML files
input_html_path = r"C:\Users\Siebe\Desktop\temp\text00069 gorgias.html"
output_html_path = r"C:\Users\Siebe\Desktop\temp\output.html"

# Convert the HTML file
convert_gorgias_to_caesar_format(input_html_path, output_html_path)

output_html_path
