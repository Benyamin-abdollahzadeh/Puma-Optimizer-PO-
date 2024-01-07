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

function Sol = Exploration(Sol,lb,ub,dim,nSol,CostFunction)
    [~,sind] = sort([Sol.Cost]);
    Sol = Sol(sind);
    pCR=0.20; 
    PCR=1-pCR;   % Eq 28
    p=PCR/nSol;  % Eq 29
    for i = 1 : nSol
        x=Sol(i).X;        
        A=randperm(nSol);       
        A(A==i)=[];        
        a=A(1);
        b=A(2);
        c=A(3);  
        d=A(4);
        e=A(5);  
        f=A(6);
        G=2*rand-1; % Eq 26
        if rand < 0.5
            y=rand(1,dim).*(ub-lb)+lb; % Eq 25
        else
            y=Sol(a).X+G.*(Sol(a).X-Sol(b).X)+G.*(((Sol(a).X-Sol(b).X)-(Sol(c).X-Sol(d).X))+((Sol(c).X-Sol(d).X)-(Sol(e).X-Sol(f).X))); % Eq 25
        end
        y = max(y, lb);
		y = min(y, ub);
        z=zeros(size(x));
        j0=randi([1 numel(x)]);
        for j=1:numel(x)
            if j==j0 || rand<=pCR
                z(j)=y(j);
            else
                z(j)=x(j);
            end
        end           
        NewSol(i).X = z;%#ok
        NewSol(i).Cost = CostFunction(NewSol(i).X);%#ok        
        if NewSol(i).Cost < Sol(i).Cost
            Sol(i) = NewSol(i);
        else
            pCR=pCR+p; % Eq 30
        end
    end
end