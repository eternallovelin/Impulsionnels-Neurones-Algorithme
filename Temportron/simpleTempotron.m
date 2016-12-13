clear;

%parameters
maxTime = 1.5; %duration of the traces
maxIncomingSpikeTime = 1.; % max time of an incoming spike
nbInputNeuron = 100; %number of input neuron = nb dimension of input space
timeGap = 0.001; %time resolution

%useful variables
timeLine = 0:timeGap:maxTime;
nbTimeValue = size(timeLine,2);

%spike pattern structure
spikePattern = zeros(nbInputNeuron,nbTimeValue);
%random spike pattern
listSpikeTime = randi(maxIncomingSpikeTime/timeGap, nbInputNeuron, 1);
for idInputNeuron = 1:nbInputNeuron
    spikePattern(idInputNeuron,listSpikeTime(idInputNeuron)) = 1;
    %plot(spikePattern(idInputNeuron,:)); pause;
end

%kernel
kernelTimeConstant = 0.04;
kernel = timeLine/(kernelTimeConstant*exp(-1)).*exp(-timeLine/kernelTimeConstant);
plot(kernel)

%synaptic pattern
synapticPattern = conv2(spikePattern, kernel);   
synapticPattern = synapticPattern(:, 1:nbTimeValue);
%plot(synapticPattern(1, :)); pause;
%plot(synapticPattern(2, :)); pause;

%learning coeficients
threshold = 10;
alphaLearning = 0.05;

%value to change to consider the pattern as a P+ or P- pattern
learningCoef = 1;%for positive pattern
%learningCoef = -1;%for negative pattern

%initial synatpic weights
synapticWeight = rand(nbInputNeuron,1)*2-1;

%compute initial membrane potential
synapticActivity = bsxfun(@times,synapticWeight,synapticPattern);
membranePotential = sum(synapticActivity,1);
maxVal = max(membranePotential);
maxPos = find(membranePotential==maxVal);
%plot(synapticActivity(1,:)); pause;
%plot(synapticActivity(2,:)); pause;
%plot(membranePotential); pause;

%loop until the learning is complete
while learningCoef*(maxVal-threshold)<0
    
   plot(membranePotential); pause;

    %modify the weights
    for idInputNeuron = 1:nbInputNeuron        
        spikePos = listSpikeTime(idInputNeuron);                
        delayPos = maxPos-spikePos;

        if delayPos>0
            kernelValue = kernel(delayPos);
            synapticWeight(idInputNeuron) = synapticWeight(idInputNeuron)+learningCoef*kernelValue*alphaLearning;
        end                                    
    end
    
    %compute new membrane potential
    synapticActivity = bsxfun(@times,synapticWeight,synapticPattern);
    membranePotential = sum(synapticActivity,1);
    maxVal = max(membranePotential);
    maxPos = find(membranePotential==maxVal);
    
end     
disp('learning OK');
plot(membranePotential); pause;

