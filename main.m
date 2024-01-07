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

clear  
close all 
clc

Function_name='F1'; % Name of the test function from F1 to F23 

% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
T=500; % Maximum number of iterations
N=30; % Maximum number of Puma

[Adult1_pos,Adult1_score,CNVG]=Puma(N,T,lb,ub,dim,fobj);


% %Convergence curve
figure;
semilogy(CNVG,'Color','r','LineWidth',1.25)
title('Convergence curve')
xlabel('Iteration');
ylabel('Best score obtained so far');

axis tight
grid off
box on
