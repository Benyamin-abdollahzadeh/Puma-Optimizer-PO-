%_______________________________________________________________________________________________
%  Puma Optimizar Algorithm (POA)  
%
%  Source codes demo version 1.0                                                                      
%                                                                                                     
%  Developed in MATLAB R2011b(R2021a)                                                                   
%  Main Paper: { Cluster Computing
%  Authors: Benyamin Abdollahzadeh, Nima Khodadadi, Saeid Barshandeh, Pavel Trojovský ,Farhad Soleimanian Gharehchopogh, El-Sayed M. El-kenawy, Laith Abualigah, Seyedali Mirjalili
%  Puma optimizer (PO): a novel metaheuristic optimization algorithm and its application in machine learning
%  DOI: 10.1007/s10586-023-04221-5 }                                                                                                                                                            
%                                                                                                     
%  e-Mail: benyamin.abdolahzade@gmail.com  
%_______________________________________________________________________________________________


function [ X ] = BoundaryCheck(X, lb, ub)

    for i=1:size(X,1)
            FU=X(i,:)>ub;
            FL=X(i,:)<lb;
            X(i,:)=(X(i,:).*(~(FU+FL)))+ub.*FU+lb.*FL;
    end
end