def sort_lines_by_word_length(filename):
    """
    Sorts the lines in a text file by the sum of the length of the words in each line.
    The lines are sorted in ascending order.
    The sorted lines are written to a new text file.

    input: .txt file
    output: .txt file with sorted lines

    # run it from the command line:
    python sort-lines-by-word-length.py

    # application areas:
    - I want to order all my text highlights from a book by their length
    """
    with open(filename, 'r', encoding='utf-8') as file:
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
    # ask for input file
    input_file = input('Enter the path of the file you want to sort: ')
    sort_lines_by_word_length(input_file)