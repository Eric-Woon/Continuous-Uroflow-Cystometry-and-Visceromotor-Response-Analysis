clear all;
close all;
clc;

load("SAMPLE_5sUBD.mat")

%UBD is called CRD to match spike 2 recording configuration 

CRD_values = CRD.values;
CRD_times = CRD.times;

CRD_values_temp = CRD_values;
CRD_times_temp = CRD_times;
nCRD=(length(find(diff(find(CRD_values_temp>1.5))>2))+1)/4; 

CRD4steptimes=cell(4,nCRD);

for i=1:nCRD
    
    
    CRD_start_index =find(CRD_values_temp>1.95,1);
    CRD_end_index = CRD_start_index + 3818; 
    
    
    CRD_values_section = CRD_values_temp(CRD_start_index : CRD_end_index);
    CRD_times_section = CRD_times_temp(CRD_start_index : CRD_end_index);
    
    CRD_2000_times = [];
    CRD_2500_times = [];
    CRD_3000_times = [];
    CRD_3500_times = [];
    
    for j=1:length(CRD_values_section)
        
    if (CRD_values_section(j)>1.95) && (CRD_values_section(j)< 2.05)
        CRD_2000_times(end+1) = CRD_times_section(j);
    
    
    elseif (CRD_values_section(j)>2.45) && (CRD_values_section(j)< 2.55)
        CRD_2500_times(end+1) = CRD_times_section(j);
    
    
    elseif (CRD_values_section(j)>2.9) && (CRD_values_section(j)< 3.1)
        CRD_3000_times(end+1) = CRD_times_section(j);
    
    
    elseif (CRD_values_section(j)>3.4) && (CRD_values_section(j)< 3.6)
        CRD_3500_times(end+1) = CRD_times_section(j);
    end
    
    end
    
    
    CRD4steptimes(1:4,i)={CRD_2000_times;CRD_2500_times;CRD_3000_times;CRD_3500_times};
    
    
    CRD_values_temp = CRD_values_temp(CRD_end_index+1:end);
    CRD_times_temp = CRD_times_temp(CRD_end_index+1:end);
    
    
end

CRDindex=1:nCRD;           
CRD4steptimesselect=CRD4steptimes(1:4,CRDindex);


%%

EMG_values= VMR.values;
EMG_times = VMR.times; 

EMG4steplocs=cell(4,length(CRDindex));
EMGnoiselocs=cell(1,length(CRDindex));

EMG4stepAUCclean = zeros(4,length(CRDindex));


for j=1:length(CRDindex)
    CRDsteptimesindex = CRD4steptimesselect{1,j}; 
    EMGnoiselocs{j} = find(EMG_times > (CRDsteptimesindex(1) - 5) & EMG_times < (CRDsteptimesindex(end) - 5));
    EMGnoisetimes{j, 1} = EMG_times(EMGnoiselocs{j});
    EMGnoisevalues{j} = EMG_values(EMGnoiselocs{j});
    EMGnoiseAUC{j} = trapz(EMGnoisetimes{j}, abs(EMGnoisevalues{j}));
    
    
     for i=1:4
   
     CRDsteptimesindex=CRD4steptimesselect{i,j}; 
     EMG4steplocs(i,j) = {find(EMG_times>CRDsteptimesindex(1)& EMG_times<CRDsteptimesindex(end))};
     
     EMG4steptimes(i,j)={EMG_times(EMG4steplocs{i,j})};
     EMG4stepvalues(i,j)={EMG_values(EMG4steplocs{i,j})};
     
     EMG4stepAUC(i,j) = trapz(EMG4steptimes{i,j},abs(EMG4stepvalues{i,j}));
     UBD_AUC(i,j) = EMG4stepAUC(i,j) - EMGnoiseAUC{j};
     
     EMGsteplength(i,j)=length(EMG4steplocs{i,j}); % get the length of each CRD step
     
    end
  
end



minEMGsteplength=min(EMGsteplength,[],'all');

noiseEMGstarttime=0;                          
noiseEMGstartindex=find(EMG_times>noiseEMGstarttime,1);
noiseEMGendindex=noiseEMGstartindex+minEMGsteplength;

noiseEMGAUC = trapz(EMG_times(noiseEMGstartindex:noiseEMGendindex),abs(EMG_values(noiseEMGstartindex:noiseEMGendindex)));

EMGAUCclean=EMG4stepAUC'-noiseEMGAUC;

%%

cutstart=min(CRD4steptimesselect{1,1})-1;
cutend=max(CRD4steptimesselect{4,1})+5;

CRDcutlocs = find(CRD_times>cutstart & CRD_times<cutend);
CRDtimecut=CRD_times(CRDcutlocs);
CRDtimecut0=CRDtimecut-min(CRDtimecut);
CRDvaluecut=CRD_values(CRDcutlocs);

for i=1:length(CRDvaluecut)
    
    if (CRDvaluecut(i)>1.95) && (CRDvaluecut(i)< 2.05)
        CRDvaluecut(i)=2;
    end

    if (CRDvaluecut(i)>2.45) && (CRDvaluecut(i)< 2.55)
        CRDvaluecut(i)=2.5;
    end
    
    if (CRDvaluecut(i)>2.95) && (CRDvaluecut(i)< 3.05)
        CRDvaluecut(i)=3;
    end

    if (CRDvaluecut(i)>3.45) && (CRDvaluecut(i)< 3.55)
        CRDvaluecut(i)=3.5;
    end
    
    if  CRDvaluecut(i)<1.5
        CRDvaluecut(i)=0;
    end
    
end    
    

EMGcutlocs = find(EMG_times>cutstart & EMG_times<cutend);
EMGtimecut=EMG_times(EMGcutlocs);
EMGvaluecut=EMG_values(EMGcutlocs);


xaxis=[0 max(EMG_times)];          

subplot(2,1,1)
plot(EMG_times,EMG_values,'k')
ylim([-0.1 0.1])

hold on
for i=1:4   
    for j=1:length(CRDindex)
        plot(EMG4steptimes{i,j},EMG4stepvalues{i,j}) % plot each EMG step
    end
end

hold on
plot(EMG_times(noiseEMGstartindex:noiseEMGendindex),EMG_values(noiseEMGstartindex:noiseEMGendindex),'r') 

subplot(2,1,2)
plot(CRD_times,CRD_values)
hold on
plot(CRDtimecut,CRDvaluecut)

UBD_AUC

