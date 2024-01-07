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


 function [Puma_X,Puma_C,Convergence]=Puma(nSol,MaxIter,lb,ub,dim,CostFunction)

% Parameter setting
UnSelected = ones(1,2); % 1:Exploration 2:Exploitaion
F3_Explore = 0; 
F3_Exploit = 0;
Seq_Time_Explore = ones(1,3);
Seq_Time_Exploit = ones(1,3);
Seq_Cost_Explore = ones(1,3);
Seq_Cost_Exploit = ones(1,3); 
Score_Explore = 0; %#ok % Score of Exploration
Score_Exploit = 0; %#ok % Score of Exploitaion 
PF = [0.5 0.5 0.3];  % 1&2 for intensification (for F1 and F2) 3 for diversification (For F3)
PF_F3=[];
Mega_Explor = 0.99;
Mega_Exploit = 0.99;

% Initialization

for i = 1 : nSol
   Sol(i).X = unifrnd(lb,ub,1,dim);  %#ok
   Sol(i).Cost = CostFunction(Sol(i).X); %#ok
end

[~,ind] = min([Sol.Cost]);
Best = Sol(ind);
Flag_Change = 1;

Initial_Best = Best;


%%  Unexperienced Phase
    for Iter = 1 : 3

        Sol_Explor = Exploration(Sol,lb,ub,dim,nSol,CostFunction); % Run Exploration Phase
        Costs_Explor(1,Iter) = min([Sol_Explor.Cost]);%#ok

        Sol_Exploit = Exploitation(Sol,lb,ub,dim,nSol,Best,MaxIter,Iter,CostFunction); % Run Exploitation Phase
        Costs_Exploit(1,Iter) = min([Sol_Exploit.Cost]);%#ok

        Sol = [Sol Sol_Explor Sol_Exploit];%#ok
        [~,sind] = sort([Sol.Cost]);
        Sol = Sol(sind(1:nSol));
        Best = Sol(1);

        Convergence(Iter) = Best.Cost;%#ok
        disp(['Iteration: ' num2str(Iter) ' Best Cost = ' num2str(Best.Cost)]);

    end

   % Hyper Initilization    
    Seq_Cost_Explore(1) = abs(Initial_Best.Cost - Costs_Explor(1));   % Eq (5)
    Seq_Cost_Exploit(1) = abs(Initial_Best.Cost - Costs_Exploit(1));  % Eq (8)
    Seq_Cost_Explore(2) = abs(Costs_Explor(2)  - Costs_Explor(1));    % Eq (6)
    Seq_Cost_Exploit(2) = abs(Costs_Exploit(2) - Costs_Exploit(1));   % Eq (9)
    Seq_Cost_Explore(3) = abs(Costs_Explor(3)  - Costs_Explor(2));    % Eq (7)
    Seq_Cost_Exploit(3) = abs(Costs_Exploit(3) - Costs_Exploit(2));   % Eq (10)

    for i= 1 : 3
        if Seq_Cost_Explore(i)~=0
            PF_F3=[PF_F3,Seq_Cost_Explore(i)]%#ok
        end
        if Seq_Cost_Exploit(i)~=0
            PF_F3=[PF_F3,Seq_Cost_Exploit(i)]%#ok
        end
    end
    
    %F1_Explore
    F1_Explor = PF(1)*(Seq_Cost_Explore(1)/Seq_Time_Explore(1));      % Eq (1)
    %F1_Exploit
    F1_Exploit = PF(1)*(Seq_Cost_Exploit(1)/Seq_Time_Exploit(1));     % Eq (2)
    %F2_Explore
    F2_Explor = PF(2)*((Seq_Cost_Explore(1)+Seq_Cost_Explore(2)+Seq_Cost_Explore(3))/(Seq_Time_Explore(1)+Seq_Time_Explore(2)+Seq_Time_Explore(3)));  % Eq (3)
    %F2_Exploit
    F2_Exploit = PF(2)*((Seq_Cost_Exploit(1)+Seq_Cost_Exploit(2)+Seq_Cost_Exploit(3))/(Seq_Time_Exploit(1)+Seq_Time_Exploit(2)+Seq_Time_Exploit(3))); % Eq (4)
    % Score calculation 
    Score_Explore =(PF(1)*F1_Explor) +(PF(2)*F2_Explor);  % Eq (11)
    Score_Exploit =(PF(1)*F1_Exploit)+(PF(2)*F2_Exploit); % Eq (12)
    %% Experienced Phase
    for Iter = 4 : MaxIter

        if Score_Explore > Score_Exploit
            % Exploration
            SelectFlag = 1;
            Sol= Exploration(Sol,lb,ub,dim,nSol,CostFunction); % Run Exploration Phase
            Count_select=UnSelected;
            UnSelected(2) = UnSelected(2) + 1;
            UnSelected(1) = 1;
            F3_Explore = PF(3); %F3 
            F3_Exploit = F3_Exploit+PF(3); %F3
            [~,TBind] = min([Sol.Cost]);
            TBest = Sol(TBind);
            Seq_Cost_Explore(3) = Seq_Cost_Explore(2);
            Seq_Cost_Explore(2) = Seq_Cost_Explore(1);
            Seq_Cost_Explore(1) = abs(Best.Cost - TBest.Cost);
            if Seq_Cost_Explore(1)~=0
               PF_F3=[PF_F3,Seq_Cost_Explore(1)];%#ok
            end
            if TBest.Cost < Best.Cost
                Best = TBest;
            end
        else
            % Exploitation
            SelectFlag = 2;
            Sol = Exploitation(Sol,lb,ub,dim,nSol,Best,MaxIter,Iter,CostFunction); % Run Exploitation Phase
            Count_select=UnSelected;
            UnSelected(1) = UnSelected(1) + 1;
            UnSelected(2) = 1;
            F3_Explore = F3_Explore+PF(3); %F3
            F3_Exploit = PF(3); %F3

            [~,TBind] = min([Sol.Cost]);
            TBest = Sol(TBind);
            Seq_Cost_Exploit(3) = Seq_Cost_Exploit(2);
            Seq_Cost_Exploit(2) = Seq_Cost_Exploit(1);
            Seq_Cost_Exploit(1) = abs(Best.Cost - TBest.Cost);
            if Seq_Cost_Exploit(1)~=0
               PF_F3=[PF_F3,Seq_Cost_Exploit(1)]; %#ok
            end
            
            if TBest.Cost < Best.Cost
                Best = TBest;
            end
        end

        if Flag_Change ~= SelectFlag     
            Flag_Change = SelectFlag;               
                Seq_Time_Explore(3) = Seq_Time_Explore(2);
                Seq_Time_Explore(2) = Seq_Time_Explore(1);
                Seq_Time_Explore(1) = Count_select(1);
                Seq_Time_Exploit(3) = Seq_Time_Exploit(2);
                Seq_Time_Exploit(2) = Seq_Time_Exploit(1);
                Seq_Time_Exploit(1) = Count_select(2);
        end    

        %% Hyper Initilization    
        % F1_Explore: Exploration
        F1_Explor = PF(1)*(Seq_Cost_Explore(1)/Seq_Time_Explore(1));  % Eq 14
        %F1_Exploit
        F1_Exploit = PF(1)*(Seq_Cost_Exploit(1)/Seq_Time_Exploit(1)); % Eq 13
        %%F2_Explore
        F2_Explor = PF(2)*((Seq_Cost_Explore(1)+Seq_Cost_Explore(2)+Seq_Cost_Explore(3))/(Seq_Time_Explore(1)+Seq_Time_Explore(2)+Seq_Time_Explore(3)));  % Eq 16
        %F2_Exploit
        F2_Exploit = PF(2)*((Seq_Cost_Exploit(1)+Seq_Cost_Exploit(2)+Seq_Cost_Exploit(3))/(Seq_Time_Exploit(1)+Seq_Time_Exploit(2)+Seq_Time_Exploit(3))); % Eq 15

        % calculate function value Eq 17 and 18
        if Score_Explore < Score_Exploit 
           Mega_Explor = max((Mega_Explor-0.01),0.01);
           Mega_Exploit = 0.99;
        elseif Score_Explore > Score_Exploit 
           Mega_Explor = 0.99;
           Mega_Exploit = max((Mega_Exploit-0.01),0.01);
        end

        lmn_Explore = 1-Mega_Explor;  % Eq 24
        lmn_Exploit = 1-Mega_Exploit; % Eq 22

        Score_Explore =(Mega_Explor*F1_Explor)+(Mega_Explor*F2_Explor)+(lmn_Explore*(min(PF_F3)*F3_Explore));       % Eq 20
        Score_Exploit =(Mega_Exploit*F1_Exploit)+(Mega_Exploit*F2_Exploit)+(lmn_Exploit*(min(PF_F3)*F3_Exploit));   % Eq 19
        Convergence(Iter) = Best.Cost;
        disp(['Iteration: ' num2str(Iter) ' Best Cost = ' num2str(Best.Cost)]);
        Puma_C=Best.Cost;
        Puma_X=Best.X;
    end

 end








