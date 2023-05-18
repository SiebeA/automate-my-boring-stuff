def apply_time_delay(srt_file, delay):
    with open(srt_file, 'r') as file:
        lines = file.readlines()

    new_lines = []
    for line in lines:
        if '-->' in line:
            start, end = line.strip().split(' --> ')
            start_time = convert_time(start) + delay
            end_time = convert_time(end) + delay
            new_line = f"{format_time(start_time)} --> {format_time(end_time)}\n"
            new_lines.append(new_line)
        else:
            new_lines.append(line)

    output_file = f"delayed_{srt_file}"
    with open(output_file, 'w') as file:
        file.writelines(new_lines)

    print(f"Modified .srt file created: {output_file}")


def convert_time(time_str):
    h, m, s = time_str.split(':')
    s, ms = s.split(',')
    return int(h) * 3600 + int(m) * 60 + int(s) * 1000 + int(ms)


def format_time(time):
    ms = time % 1000
    time //= 1000
    s = time % 60
    time //= 60
    m = time % 60
    h = time // 60
    return f"{h:02d}:{m:02d}:{s:02d},{ms:03d}"


# Example usage
srt_file = 'input.srt'  # Replace with your .srt file path
time_delay = 1400  # Delay in milliseconds

apply_time_delay(srt_file, time_delay)
