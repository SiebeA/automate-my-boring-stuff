import os
import datetime
from hachoir.parser import createParser
from hachoir.metadata import extractMetadata

# Set the path to the video file
video_folder = "C://Users//Siebe//Desktop//upload_youtube"

# Loop through all the files in the folder
for filename in os.listdir(video_folder):
    # Check if the file is an MP4 file
    if filename.endswith("MP4"):
        # Set the path to the video file
        video_path = os.path.join(video_folder, filename)

        # Create a parser for the video file
        parser = createParser(video_path)

        # Extract the metadata from the video file
        metadata = extractMetadata(parser)
        print('hi')
        # Get the media creation date from the metadata

        # Get the media creation date from the metadata
        create_date = metadata.get("creation_date")
        if create_date:
            create_date_str = create_date.strftime("%Y-%m-%d %H:%M:%S")
            create_datetime = datetime.datetime.strptime(create_date_str, "%Y-%m-%d %H:%M:%S")
            create_date_formatted = create_datetime.strftime("%Y-%m-%d_%H-%M")
            print(f"{filename}: {create_date_formatted}")
        else:
            print(f"{filename}: Media creation date not found.")