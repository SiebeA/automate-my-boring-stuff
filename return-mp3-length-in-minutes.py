
import pydub
from pydub import AudioSegment
import os

folder_path = 'C:\\Users\\Siebe\\Desktop\\Input' # Replace this with the path to your directory of MP3 files

for file_name in os.listdir(folder_path):
    if file_name.endswith('.mp3'):
        file_path = os.path.join(folder_path, file_name)
        audio = AudioSegment.from_file(file_path, format="mp3")
        duration_seconds = audio.duration_seconds
        duration_minutes = int(duration_seconds // 60)
        duration_seconds_remainder = int(duration_seconds % 60)
        duration_string = f"{duration_minutes:02}:{duration_seconds_remainder:02}"
        print(f"{file_name}: {duration_string}")
