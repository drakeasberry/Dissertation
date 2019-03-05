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

