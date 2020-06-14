
% ------------------------------- part a ------------------------------- %
global prob_matrix;
prob_matrix = zeros([12 12 4]);

% ------------ 1 ------------ %

prob_matrix(1,1,1) = 0.9;
prob_matrix(4,1,1) = 0.1;

prob_matrix(1,2,1) = 0.8;
prob_matrix(2,2,1) = 0.2;

prob_matrix(2,3,1) = 0.8;
prob_matrix(6,3,1) = 0.1;
prob_matrix(3,3,1) = 0.1;

prob_matrix(4,4,1) = 0.8;
prob_matrix(7,4,1) = 0.1;
prob_matrix(1,4,1) = 0.1;

prob_matrix(6,6,1) = 0.8;
prob_matrix(9,6,1) = 0.1;
prob_matrix(3,6,1) = 0.1;

prob_matrix(7,7,1) = 0.8;
prob_matrix(10,7,1) = 0.1;
prob_matrix(4,7,1) = 0.1;

prob_matrix(7,8,1) = 0.8;
prob_matrix(11,8,1) = 0.1;
prob_matrix(8,8,1) = 0.1;

prob_matrix(8,9,1) = 0.8;
prob_matrix(12,9,1) = 0.1;
prob_matrix(6,9,1) = 0.1;

prob_matrix(11,12,1) = 0.8;
prob_matrix(12,12,1) = 0.1;
prob_matrix(9,12,1) = 0.1;

% ------------ 2 ------------ %

prob_matrix(4,1,2) = 0.8;
prob_matrix(2,1,2) = 0.1;
prob_matrix(1,1,2) = 0.1;

prob_matrix(2,2,2) = 0.8;
prob_matrix(3,2,2) = 0.1;
prob_matrix(1,2,2) = 0.1;

prob_matrix(6,3,2) = 0.8;
prob_matrix(3,3,2) = 0.1;
prob_matrix(2,3,2) = 0.1;

prob_matrix(7,4,2) = 0.8;
prob_matrix(4,4,2) = 0.2;

prob_matrix(9,6,2) = 0.8;
prob_matrix(6,6,2) = 0.2;

prob_matrix(10,7,2) = 0.8;
prob_matrix(8,7,2) = 0.1;
prob_matrix(7,7,2) = 0.1;

prob_matrix(11,8,2) = 0.8;
prob_matrix(9,8,2) = 0.1;
prob_matrix(7,8,2) = 0.1;

prob_matrix(12,9,2) = 0.8;
prob_matrix(9,9,2) = 0.1;
prob_matrix(8,9,2) = 0.1;

prob_matrix(12,12,2) = 0.9;
prob_matrix(11,12,2) = 0.1;

% ------------ 3 ------------ %

prob_matrix(2,1,3) = 0.8;
prob_matrix(1,1,3) = 0.1;
prob_matrix(4,1,3) = 0.1;

prob_matrix(3,2,3) = 0.8;
prob_matrix(2,2,3) = 0.2;

prob_matrix(3,3,3) = 0.9;
prob_matrix(6,3,3) = 0.1;

prob_matrix(4,4,3) = 0.8;
prob_matrix(1,4,3) = 0.1;
prob_matrix(7,4,3) = 0.1;

prob_matrix(6,6,3) = 0.8;
prob_matrix(3,6,3) = 0.1;
prob_matrix(9,6,3) = 0.1;

prob_matrix(8,7,3) = 0.8;
prob_matrix(4,7,3) = 0.1;
prob_matrix(10,7,3) = 0.1;

prob_matrix(9,8,3) = 0.8;
prob_matrix(8,8,3) = 0.1;
prob_matrix(11,8,3) = 0.1;

prob_matrix(9,9,3) = 0.8;
prob_matrix(6,9,3) = 0.1;
prob_matrix(12,9,3) = 0.1;

prob_matrix(12,12,3) = 0.9;
prob_matrix(9,12,3) = 0.1;

% ------------ 4 ------------ %

prob_matrix(1,1,4) = 0.9;
prob_matrix(2,1,4) = 0.1;

prob_matrix(2,2,4) = 0.8;
prob_matrix(1,2,4) = 0.1;
prob_matrix(3,2,4) = 0.1;

prob_matrix(3,3,4) = 0.9;
prob_matrix(2,3,4) = 0.1;

prob_matrix(1,4,4) = 0.8;
prob_matrix(4,4,4) = 0.2;

prob_matrix(3,6,4) = 0.8;
prob_matrix(6,6,4) = 0.2;

prob_matrix(4,7,4) = 0.8;
prob_matrix(7,7,4) = 0.1;
prob_matrix(8,7,4) = 0.1;

prob_matrix(8,8,4) = 0.8;
prob_matrix(7,8,4) = 0.1;
prob_matrix(9,8,4) = 0.1;

prob_matrix(6,9,4) = 0.8;
prob_matrix(8,9,4) = 0.1;
prob_matrix(9,9,4) = 0.1;

prob_matrix(9,12,4) = 0.8;
prob_matrix(11,12,4) = 0.1;
prob_matrix(12,12,4) = 0.1;

% --------------------------- %


% ------------------------------- part b ------------------------------- %

delta = 1;
tetta = 10^-4;
V = zeros(1,12);
gamma = 1;

% Value iteration
while delta > tetta
   delta = 0;
   for s = 1:12
       v = V(s);
       max_array = zeros(1, 4);
       for a = 1:4
           sum = 0;
           for i = 1:12
               sum = sum + gamma*prob_matrix(i,s,a)*V(i);
           end
           sum = sum + r(s);
           max_array(a) = sum;
       end
       V(s) = max(max_array);
       delta = max([delta, abs(v-V(s))]);      
   end 
end


% plot the optimal values
myworld = cWorld();
myworld.plot;
myworld.plot_value(transpose(V));

% calculate the optimal policy
policy = zeros(1, 12);
for s = 1:12
    max_array = zeros(1, 4);
    for a = 1:4
        sum = 0;
        for i = 1:12
           sum = sum+prob_matrix(i,s,a)*V(i);
        end
       max_array(a) = r(s)+ gamma*sum;
    end
    [val, idx] = max(max_array);
    policy(s) = idx;
end


% plot the optimal policy
myworld = cWorld();
myworld.plot;
myworld.plot_policy(transpose(policy));


% ------------------------------- part c ------------------------------- %
delta = 1;
tetta = 10^-4;
V = zeros(1,12);
gamma = 0.9;

% Value iteration
while delta > tetta
   delta = 0;
   for s = 1:12
       v = V(s);
       max_array = zeros(1, 4);
       for a = 1:4
           sum = 0;
           for i = 1:12
               sum = sum + gamma*prob_matrix(i,s,a)*V(i);
           end
           sum = sum + r(s);
           max_array(a) = sum;
       end
       V(s) = max(max_array);
       delta = max([delta, abs(v-V(s))]);      
   end 
end


% plot the optimal values
myworld = cWorld();
myworld.plot;
myworld.plot_value(transpose(V));

% calculate the optimal policy
policy = zeros(1, 12);
for s = 1:12
    max_array = zeros(1, 4);
    for a = 1:4
        sum = 0;
        for i = 1:12
           sum = sum+prob_matrix(i,s,a)*V(i);
        end
       max_array(a) = r(s)+ gamma*sum;
    end
    [val, idx] = max(max_array);
    policy(s) = idx;
end


% plot the optimal policy
myworld = cWorld();
myworld.plot;
myworld.plot_policy(transpose(policy));


% ------------------------------- part d ------------------------------- %
delta = 1;
tetta = 10^-4;
V = zeros(1,12);
gamma_d = 1;

% Value iteration
while delta > tetta
   delta = 0;
   for s = 1:12
       v = V(s);
       max_array = zeros(1, 4);
       for a = 1:4
           sum = 0;
           for i = 1:12
               sum = sum + gamma_d*prob_matrix(i,s,a)*V(i);
           end
           sum = sum + r(s);
           max_array(a) = sum;
       end
       V(s) = max(max_array);
       delta = max([delta, abs(v-V(s))]);      
   end 
end


% plot the optimal values
myworld = cWorld();
myworld.plot;
myworld.plot_value(transpose(V));

% calculate the optimal policy
policy = zeros(1, 12);
for s = 1:12
    max_array = zeros(1, 4);
    for a = 1:4
        sum = 0;
        for i = 1:12
           sum = sum+prob_matrix(i,s,a)*V(i);
        end
       max_array(a) = r(s)+ gamma*sum;
    end
    [val, idx] = max(max_array);
    policy(s) = idx;
end


% plot the optimal policy
myworld = cWorld();
myworld.plot;
myworld.plot_policy(transpose(policy));


% ------------------------------- part e ------------------------------- %

% 1 - initialization
V_e = zeros(1,12);
V_e(10) = 1;
V_e(11) = -1;
policy_e(1:4,1:12) = 0.25;
delta = 1;
tetta = 10^-4;
gamma_e = 0.9;
policy_stable = false;



while policy_stable == false
    % 2 - Policy iteration
    delta = 1;
    while delta > tetta
       delta = 0;
       for s = 1:12
           v = V_e(s);

           % calculate reward
           sum_r = r(s);         
           
           % calculate values
           sum_v = 0;
           for i = 1:12
               sum_p = 0;
               for a = 1:4
                   sum_p = sum_p + policy_e(a,s)*prob_matrix(i,s,a);
               end
               sum_v = sum_v + sum_p*V_e(i);
           end
           
  
           V_e(s) = sum_r + gamma_e*sum_v;
           delta = max([delta, abs(v-V_e(s))]);      
       end

    end
    

    % 3 - policy improvement
          
    policy_stable = true;    
    for s = 1:12
        [val, idx] = max(policy_e(:,s));
        old_action = idx;
        
        max_array = zeros(1, 4);
        for a = 1:4
            sum = 0;
            for i = 1:12
               sum = sum + prob_matrix(i,s,a)*V_e(i);
            end
            max_array(a) = r(s)+ gamma_e*sum;
        end

        [val, idx] = max(max_array);
        action = idx;
        for i = 1:4
            if i == action
               policy_e(i,s) = 1;
            else
               policy_e(i,s) = 0;
            end
        end
        
        
        if old_action ~= action
          policy_stable = false;
        end  
        
    end
    
end

% plot the optimal values
myworld = cWorld();
myworld.plot;
myworld.plot_value(transpose(V_e));

% plot the optimal policy
policy_show = zeros(1, 12);
for i = 1:12
    [val, idx] = max(policy_e(:,i));
    policy_show(i) = idx;
end

myworld = cWorld();
myworld.plot;
myworld.plot_policy(transpose(policy_show));



% ----------------------------------------------------------------------- %
% ------------------------------ functions ------------------------------ %
% ----------------------------------------------------------------------- %

% ------------------------------- part a ------------------------------- %

function prob = p(s_1, s_0, a)
  global prob_matrix
  prob = prob_matrix(s_1,s_0,a);
end


function reward = r(s)
    if s == 10
        reward = 1;
    elseif s == 11
        reward = -1;
    else
        %reward = -0.02;
        reward = -0.04;
    end
end

% ------------------------------- part b ------------------------------- %

