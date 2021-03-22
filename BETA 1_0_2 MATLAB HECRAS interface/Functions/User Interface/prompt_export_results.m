function prompt_export_results (results)
% ask user to export results to CSV
%
% Syntax : prompt_export_results (results)
%
% Param : results, Results_ object
%
% See also
% User Interface : input_update_standalone,
% intelli_flow_update, input_writing, 
% rating_curve_update
%
% Written by Ronan Deshays for IMTLD, July 2020 

    warning('export to CSV will erase current content of out.csv')
    
    if prompt('Do you want to export these results to CSV ?','Y')

        big_results_array=results{1}.Array;

    % same dimensions for every results array

        row_sz=size(results{1}.Array,1);
        column_sz=size(results{1}.Array,2);

        for k=1:size(results,1)-1
            l=k+1;
            
            big_results_array(k*(row_sz+1)+1:l*row_sz+k,...
                1:column_sz)=results{l}.Array;
                
        end

        cell2csv(big_results_array)

    end

end