LDPC_rate = 5/6;
M = 16;

ldpcEnc = comm.LDPCEncoder(dvbs2ldpc(LDPC_rate,'indices'));
ldpcDecSoft = comm.LDPCDecoder('ParityCheckMatrix',dvbs2ldpc(LDPC_rate,'indices'),'DecisionMethod','Soft decision');
ldpcDecHard = comm.LDPCDecoder(dvbs2ldpc(LDPC_rate,'indices'));

BinMsg = randi([0,1],(5/6)*64800,1);
encData =  step(ldpcEnc,BinMsg);
modData = qammod(encData,M,'gray','InputType','bit');

noisyData = awgn(modData,4,1); %awgn

demodData = qamdemod(noisyData,M,'gray','OutputType','llr');

decDataSoft = step(ldpcDecSoft,demodData);%soft ldpc decoder
decDataHard = step(ldpcDecHard,demodData);%hard ldpc decoder

sum(BinMsg ~= decDataHard)