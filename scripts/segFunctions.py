def csv_from_excel(workbookPath, sheetName, outputPath):
    """ Grabs a worksheet from Excel workbook and converts it to a csv file

    Keyword arguments:
        workbookPath - the file path of the current Excel Workbook
        sheetName - the name of worksheet that you want to convert to csv
        outputPath - path to write

    Return:
        outs a new csv file
    """
    import xlrd
    import csv
    wb = xlrd.open_workbook(workbookPath)
    sh = wb.sheet_by_name(sheetName)
    your_csv_file = open(outputPath, 'w')
    wr = csv.writer(your_csv_file, quoting=csv.QUOTE_ALL)

    for rownum in range(sh.nrows):
        wr.writerow(sh.row_values(rownum))

    your_csv_file.close()

    return your_csv_file


def fix_csv(input_path, output_path, column_converters):
    import csv
    with open(input_path, 'r') as input_file, open(output_path,
                                                   'w') as output_file:
        csv_reader = csv.DictReader(input_file)
        print(column_converters)
        csv_writer = csv.DictWriter(output_file,
                                    fieldnames=csv_reader.fieldnames)
        csv_writer.writeheader()
        for index, input_line in enumerate(csv_reader):
            print(index, input_line)
            modified_line = fix_csv_line(input_line, column_converters)
            csv_writer.writerow(modified_line)


def fix_csv_line(input_line, column_converters):
    modified_line = input_line
    for column_name, converter_function in column_converters.items():
        original_value = input_line[column_name]
        modified_value = converter_function(original_value)
        modified_line[column_name] = modified_value
    return modified_line