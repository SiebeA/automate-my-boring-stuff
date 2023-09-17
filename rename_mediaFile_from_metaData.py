# venv: audio-text


import os
import datetime
from hachoir.parser import createParser
from hachoir.metadata import extractMetadata

# ==================================
#     import functions    
# ==================================
def text2int(textnum, numwords={}):
    import re
    if not numwords:
        units = [
            "zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
            "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
            "sixteen", "seventeen", "eighteen", "nineteen",
        ]

        tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

        scales = ["hundred", "thousand", "million", "billion", "trillion"]

        for idx, word in enumerate(units):    numwords[word] = (1, idx)
        for idx, word in enumerate(tens):     numwords[word] = (1, idx * 10)
        for idx, word in enumerate(scales):   numwords[word] = (10 ** (idx * 3 or 2), 0)

    current = result = 0
    textnum = re.sub(r'([^\s\w]|_)+', '', textnum)     # remove adjacent characters
    words = textnum.split()
    converted_words = []
    for word in words:
        if word.lower() in numwords:
            scale, increment = numwords[word.lower()]
            current = current * scale + increment
            if scale > 100:
                result += current
                current = 0
            converted_words.append(str(current))
            current = 0  # Reset current after conversion
        else:
            converted_words.append(word)

    return ' '.join(converted_words)

# ==================================
#     main    
# ==================================
# Set the path to the video file
video_folder = r'C:\Users\Siebe\Desktop\Audiobooks\.Audiobook\podcast\The Age of Napoleon Podcast'

# Loop through all the files in the folder
for filename in os.listdir(video_folder):
    # Check if the file is an MP3 file
    if filename.endswith("mp3"):
        # Set the path to the video file
        video_path = os.path.join(video_folder, filename)

        # Create a parser for the video file
        parser = createParser(video_path)

        # Extract the metadata from the video file
        metadata = extractMetadata(parser)

        # Close the parser to release the file
        parser.close()

        # Get the media creation date from the metadata
        # create_date = metadata.get("creation_date") # outputs dates that are all the same
        title = metadata.get("title")
        print(title)
        # if create_date:
        #     create_date_str = create_date.strftime("%Y-%m-%d %H:%M:%S")
        #     create_datetime = datetime.datetime.strptime(create_date_str, "%Y-%m-%d %H:%M:%S")
        #     create_date_formatted = create_datetime.strftime("%Y-%m-%d")

        # Replace characters not allowed in filenames
        valid_title = title.replace(":", "_")
        valid_title = valid_title.replace("/", "_")

        # replace written-numbers to string digits
        valid_title = text2int(valid_title)

        # remove the following words case insensitive: episode
        valid_title = valid_title.lower().replace("episode", "")
        # strip leading and trailing whitespace
        valid_title = valid_title.strip()
        # replace spaces for underscores
        valid_title = valid_title.replace(" ", "_")

        # new_filename = f"{create_date_formatted}_{valid_title}.mp3" # outputs dates that are all the same
        new_filename = f"{valid_title}.mp3"
        new_path = os.path.join(video_folder, new_filename)
        os.rename(video_path, new_path)
        # else:
        #     print(f"{filename}: Media creation date not found.")

# list the new names
for filename in os.listdir(video_folder):
    print(filename)
