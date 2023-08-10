# venv: audio-text


import os
import datetime
from hachoir.parser import createParser
from hachoir.metadata import extractMetadata

# Set the path to the video file
video_folder = "C://Users//Siebe//Phone_sync//podcast//The Age of Napoleon Podcast"

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
        # if create_date:
        #     create_date_str = create_date.strftime("%Y-%m-%d %H:%M:%S")
        #     create_datetime = datetime.datetime.strptime(create_date_str, "%Y-%m-%d %H:%M:%S")
        #     create_date_formatted = create_datetime.strftime("%Y-%m-%d")

        # Replace characters not allowed in filenames
        valid_title = title.replace(":", "_")
        valid_title = valid_title.replace("/", "_")

        # new_filename = f"{create_date_formatted}_{valid_title}.mp3" # outputs dates that are all the same
        new_filename = f"{valid_title}.mp3"
        new_path = os.path.join(video_folder, new_filename)
        os.rename(video_path, new_path)
        # else:
        #     print(f"{filename}: Media creation date not found.")
