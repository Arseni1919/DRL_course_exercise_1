classdef cWorld < handle
    
    properties (Constant)
        
        
        nRows = 3;
        nCols = 4;
        
        stateObstacles = 5;
        stateTerminals = [10;11];
        
        nStates = 12;
        nActions = 4;
        
    end
        
     properties    
       
        R = [];  %zeros(nStates,nActions);
        Pr = []; %zeros(nStates,nStates,nActions);
        
             
    end
    
    methods  
       
        function plot(obj)
            
         % plot function
         
         nStates = obj.nStates;
         nRows = obj.nRows;
         nCols = obj.nCols;
         stateObstacles = obj.stateObstacles;
         stateTerminals = obj.stateTerminals;
         
         
        
         figure
         % plots white background patch
         patch([0,nCols,nCols,0],[0,0,nRows,nRows],'w')
         % plot dark gray patch for grid cells with obstacles
         hold on;
         for n=1:length(stateObstacles)
             [I,J]=ind2sub([nRows,nCols],stateObstacles(n));
             patch([J-1 J J J-1],[nRows-I nRows-I nRows-I+1 nRows-I+1],[0.5,0.5,0.5]);
             hold on;
         end
         % plot bright gray patch for grid cells with terminal states
         for n=1:length(stateTerminals)
             [I,J]=ind2sub([nRows,nCols],stateTerminals(n));
             patch([J-1 J J J-1],[nRows-I nRows-I nRows-I+1 nRows-I+1],[0.8,0.8,0.8]);
             hold on;
         end
         %generate mesh for grid world
         [X Y] = meshgrid(0:nCols,0:nRows);
         hold on;
         %plot grid lines of gridworld
         hold on;
         plot(X,Y,'k-')
         hold on;
         plot(X',Y','k-')
         % create labels for states
         string = mat2cell(num2str(flipud([1:nStates]')),ones(nStates,1));
         hold on
         % label coordinates
         X1 = X(2:end,2:end);
         Y1 = Y(1:end-1,1:end-1);
         % add labels to grid cells
         text(flipud(X1(:))-.2,Y1(:)+.15,string,'HorizontalAlignment','left')
         hold on;
         % add title
         title('MDP gridworld','FontSize',16)
         
         axis off
         axis equal
         
            
            
            
            
        end
      
        function plot_value(obj,valueFunction)
            
            nStates = obj.nStates;
            nRows = obj.nRows;
            nCols = obj.nCols;
            stateObstacles = obj.stateObstacles;
            stateTerminals = obj.stateTerminals;
            
            %figure(1)
            % generate mesh grid
            [X Y] = meshgrid(0:nCols,0:nRows);
            % generate strings from value function
            string = mat2cell(num2str(round(valueFunction,3),'%1.3f'),ones(12,1));
            hold on
            % place text
            X1 = X(1:end-1,1:end-1);
            Y1 = Y(1:end-1,1:end-1);
            % do not plot obstacle grid cell
            index_no_value = stateObstacles;
            string{index_no_value} = '';
            % display value function in grid cells
            text(X1(:)+ .3,flipud(Y1(:))+.5,string,'FontSize',16);
            
            
        end
        
        
        function plot_policy(obj,policy)
            
         
            nStates = obj.nStates;
            nActions = obj.nActions;
            nRows = obj.nRows;
            nCols = obj.nCols;
            stateObstacles = obj.stateObstacles;
            stateTerminals = obj.stateTerminals;
            %generate mesh for grid world
            [X Y] = meshgrid(0:nCols,0:nRows);
            
            % generate locations of policy vectors
            X1 = X(1:end-1,1:end-1);
            Y1 = Y(1:end-1,1:end-1);
            X2 = X1(:) + 0.5;
            Y2 = flipud(Y1(:)) + 0.5;
            
            X2 = repmat(X2,1,nActions);
            Y2 = repmat(Y2,1,nActions);
            
            % define an auxiliary matrix
            mat = cumsum(ones(nStates,nActions),2);
            
            if size(policy,2) == 1  % policy is a vector -> turn it into matrix of size (nStates,nAction) 
                
                policy = (repmat(policy,1,nActions) == mat);
                
            end
            
            % no policy entry for obstacles and terminal states
            index_no_policy = [stateObstacles; stateTerminals];
            index_policy = setdiff([1:nStates]',index_no_policy);
            % orientation of vector N(1) = 90 deg, E(2) = 0 deg, S(3) = - 90 deg, W(4)
            % = -180 deg
            
            % generate mask for policy output
            mask = (policy > 0).*mat;
            % consider only states where a policy vector should be generated
            mask = mask(index_policy,:);
            
            % consider only locations where a policy vector should be generated
            X3 = X2(index_policy,:);
            Y3 = Y2(index_policy,:);
            
            % generate orientation angle for policy vector
            alpha = pi - pi/2*mask;
            hold on;
            % plot policy vector
            for i=1:size(mask,1)
                index = find( mask(i,:)>0 );
                h = quiver(X3(i,index),Y3(i,index),cos(alpha(i,index)),sin(alpha(i,index)),0.3);
                set(h,'LineWidth',3,'Color',[0.2539,0.4102,0.8789],'MaxHeadSize',1);  
            end
            
            
            
            
            
        end
        
        
        
    
    end

end