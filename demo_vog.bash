#!/bin/bash

data=as-caida

echo ''
echo -e "\e[34m======== Steps 1 & 2: Subgraph Generation and Labeling  ==========\e[0m"
matlab -r run_structureDiscovery
echo ''
echo 'Structure discovery finished.'

unweighted_graph='DATA/'$data'.graph'
model='DATA/'$data'_orderedALL.model'
modelFile=$data'_orderedALL.model'
modelTop10='DATA/'$data'_top10ordered.model'

echo ''
echo -e "\e[34m=============== Step 3: Summary Assembly ===============\e[0m"
echo ''
echo -e "\e[31m=============== TOP 10 structures ===============\e[0m"
head -n 10 $model > $modelTop10
echo 'Computing the encoding cost...'
echo ''
python MDL/score.py $unweighted_graph $modelTop10 > DATA/encoding_top10.out

echo ''
echo 'Explanation of the above output:'
echo 'L(G,M):  Number of bits to describe the data given a model M.'
echo 'L(M): Number of bits to describe only the model.'
echo 'L(E): Number of bits to describe only the error.'
echo ': M_0 is the zero-model where the graph is encoded as noise (no structure is assumed).'
echo ': M_x is the model of the graph as represented by the top-10 structures.'
echo ''
cat DATA/encoding_top10.out
echo ''
echo ''

echo -e "\e[31m========= Greedy selection of structures =========\e[0m"
echo 'Computing the encoding cost...'
echo ''
python2.7 MDL/greedySearch_nStop.py $unweighted_graph $model > DATA/encoding_GnF_$data.out
cat out_final.out
rm out_final.out
mv heuristic* DATA/
echo ''
echo '>> Outputs saved in DATA/. To interpret the structures that are selected, check the file MDL/readme.txt.'
echo ": DATA/heuristicSelection_nStop_ALL_$modelFile has the lines of the $model structures included in the summary."
echo ": DATA/heuristic_Selection_costs_ALL_$modelFile has the encoding cost of the considered model at each time step."
echo ''
echo ''
