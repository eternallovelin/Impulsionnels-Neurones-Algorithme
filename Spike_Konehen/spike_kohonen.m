function [ W ] = spike_kohonen(N)
%SPIKE_KOHONEN Summary of this function goes here
%   Detailed explanation goes here

    clc;
    close all;

    nbInputNeuron = N;
    timeMax = 1.5;
    
    timeMaxSpike = 1;
    gapTime = 0.001;
    
    alpha = 0.1;
    nbLearning = N;
    
    t = [0:0.001:3];
    pattern1 = zeros(nbInputNeuron, timeMax/gapTime);
    pattern2 = zeros(nbInputNeuron, timeMax/gapTime);
    
    synapticActivity = zeros(nbInputNeuron, (2*timeMax)/gapTime);
    
    %% Kernel
    k_t = (t/(timeMax*exp(-1))).*exp(-t/timeMax);
    %plot(k_t);pause;

    spikePattern = rand(timeMaxSpike, nbInputNeuron, 1);
    spikePattern2 = rand(timeMaxSpike, nbInputNeuron, 1);
    
    %% Cr¨¦ation des patterns
    for idInputNeuron=1:nbInputNeuron
        posSPike = ceil(spikePattern(idInputNeuron)/gapTime);
        posSPike2 = ceil(spikePattern2(idInputNeuron)/gapTime);
        pattern1(idInputNeuron, posSPike) = 1;
        pattern2(idInputNeuron, posSPike2) = 1;
    end

    %% Convolution avec le kernel spike
      for idInputNeuron=1:nbInputNeuron
        disp(size(pattern1(idInputNeuron,:)));
        disp(size(pattern2(idInputNeuron,:)));
        
        tmp = conv(pattern1(idInputNeuron,:), k_t);
        tmp2 = conv(pattern2(idInputNeuron,:), k_t);
        
        synapticActivity(idInputNeuron,:) = tmp(1:(2*timeMax)/gapTime);   
        synapticActivity2(idInputNeuron,:) = tmp2(1:(2*timeMax)/gapTime);  
        %plot(synapticActivity(idInputNeuron,:));pause;
        
      end
    
    %% Gen¨¦rationa al¨¦atoire des poids
    W = rand(nbInputNeuron, 1);
    W = W/norm(W);
    
    W2 = rand(nbInputNeuron, 1);
    W2 = W2/norm(W2);
    
    %% Somme des spike <=> potentiel
    
    potentiel = bsxfun(@times, W, synapticActivity);
    potentiel = sum(potentiel, 1);
    
    potentiel2 = bsxfun(@times, W2, synapticActivity2);
    potentiel2 = sum(potentiel2, 1);
    
    plot(potentiel);    hold on;pause;
    plot(potentiel2, 'r');hold on;pause;
     
    
     %% APPRENTISSAGE
     
   
   timeMax = timeMaxSpike;
   
   for idLearning=1:nbLearning
       S = timeMax-spikePattern;
       S = S/norm(S);
       diff = S'-W;
       W = W+ alpha*diff;
       W = W/norm(W);
       
       potentiel = bsxfun(@times, W, synapticActivity);
       potentiel = sum(potentiel, 1);
       plot(potentiel);hold on;pause;
       
       
       S = timeMax-spikePattern2;
       S = S/norm(S);
       diff = S'-W2;
       W2 = W2+ alpha*diff;
       W2 = W2/norm(W);
       
       potentiel2 = bsxfun(@times, W2, synapticActivity2);
       potentiel2 = sum(potentiel2, 1);
       plot(potentiel2, 'r');hold on;pause;
   end
    
end

