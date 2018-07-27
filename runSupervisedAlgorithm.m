% hasHeaders = If you have titles at the top of the csv doc or not
%
function runSupervisedAlgorithm(file, hasHeaders)
    % binary classification - 0=no fear, 1=fear

    if hasHeaders
        matrix = csvread(file,1,0);
    else 
        matrix = csvread(file);
    end
    values = matrix(:,[1:end-1]);
    last_row = matrix(:,end);
    
    SVMModel = fitcsvm(values,last_row);
    ClassTree = fitctree(values,last_row, 'CrossVal','on');
    view(ClassTree.Trained{1},'Mode','graph')
    
    classOrder = SVMModel.ClassNames;
    sv = SVMModel.SupportVectors;
    figure
    gscatter(values(:,1),values(:,2),last_row)
    hold on
    plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
    legend('No Fear','Fear','Support Vector')
    hold off
    
end