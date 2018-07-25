function runSupervisedAlgorithm(file)
    % binary classification - 0=no fear, 1=fear

    matrix = csvread(file,1,0);
    
    values = matrix(:,[1:end-1]);
    last_row = matrix(:,end);
    
    SVMModel = fitcsvm(values,last_row);

    classOrder = SVMModel.ClassNames;
    sv = SVMModel.SupportVectors;
    figure
    gscatter(values(:,1),values(:,2),last_row)
    hold on
    plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
    legend('No Fear','Fear','Support Vector')
    hold off
    
end