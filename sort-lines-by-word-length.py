def sort_lines_by_word_length(filename):
    """
    Sorts the lines in a text file by the sum of the length of the words in each line.
    The lines are sorted in ascending order.
    The sorted lines are written to a new text file.

    input: text file with lines of text
    output: text file with sorted lines of text
    """
    with open(filename, 'r') as file:
        lines = file.readlines()
        # remove empty lines:
        lines = [line for line in lines if line.strip()]
        # if the lines start with e.g. "- " or "* ", remve it:
        lines = [line[2:] if line.startswith('- ') or line.startswith('* ') else line for line in lines]

    sorted_lines = sorted(lines, key=lambda line: sum(len(word) for word in line.split()))

    # write to text file
    with open('sorted-lines.txt', 'w') as file:
        for line in sorted_lines:
            line.strip().replace('"', '')
            file.write(line)
            file.write('\n')

if __name__ == '__main__':
    import sys
    filename = sys.argv[1]
    # filename = 'example.txt'
    sort_lines_by_word_length(filename)

# run it in the command line like this:
# python sort-lines-by-word-length.py example.txt
