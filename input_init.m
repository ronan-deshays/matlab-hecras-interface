function input_init (files, sett_list) 
% function customized by user
% called before the first simulation step
%
% Param : depends on what you choosed, potentially, every 
% variables defined in master script, see input and output 
% scripts doc for further informations.
%
% Note : please follow the input_list rules to avoid 
% issues
%
% Written by Ronan Deshays for IMTLD, july 2020

    db('input_init launched')



%% YOUR MATLAB CODE



    % your code



%% EXAMPLE 1 : HOW TO IMPORT HORODATED HYDROGRAPH FROM EXCEL



    % this example converts dates in Excel format to MATLAB dates

    % code from Read Cell Arrays of Excel Spreadsheet Data, MATLAB doc
    NET.addAssembly('microsoft.office.interop.excel');
    app = Microsoft.Office.Interop.Excel.ApplicationClass;
    book =  app.Workbooks.Open(...
        [pwd,'\input_data.xlsx']);
    sheet = Microsoft.Office.Interop.Excel.Worksheet(...
        book.Worksheets.Item(1)); 
    range1 = sheet.UsedRange;
    arr = range1.Value;
    data = cell(arr,'ConvertTypes',{'all'});
    %cellfun(@disp,data(:,1)) % display the dates
    Close(book)
    Quit(app)
    


%% SAVE INPUT DATA



    % short reminder : %   data, type, fileext, ref_param, XS, other_info
    input_list={...
        
    };

    db(input_list) % displays input list only if debug mode enabled



%% PREPARE AND WRITE INPUT DATA



    %input_writing (input_list, files)

end





