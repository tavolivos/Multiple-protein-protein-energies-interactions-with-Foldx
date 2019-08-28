#!/bin/bash
#This is an script to calculate protein-protein energy interaction with FOLDX
#Writen by:     Gustavo E. Olivos Ramirez
#               gustavo.olivos@upch.pe
#This script repairs, optimizes and analyses PDB files. 
#chain_receptor=$1 	/ use this argument to provide a chain name runing the command in the terminal (e.g: A)
#chain_ligand=$2	/ use this argument to provide a chain name runing the command in the terminal (e.g: B)
#change PDB files names before running (if not necessary turn off this part)
echo 'CHANGING FILES NAMES' && sleep 5
g=1
for file in *.pdb; do
    mv $file mod$g.pdb
    g=$((g+1));
done
clear && sleep 10 && echo '*****STARTING FOLDX*****' && sleep 5
#this part runs repair command
echo '****REPAIRING PDB FILES****' && sleep 5 && echo 'I <3 protein-protein interactions' && echo '...' && sleep 5 && echo 'Running' && sleep 5
for file in *.pdb; do
    ./foldx  --command=RepairPDB --pdb=$file;
done
sleep 5 && echo 'All PDB files have been repaired successfully' && sleep 6 && clear && sleep 2 && echo 'SETTING NEW EMVIRONMENT' && sleep 5
mkdir PDB_repaired && sleep 5 && mv foldx rotabase.txt PDB_repaired/ && sleep 5 && mv *_Repair.pdb PDB_repaired/
mv *_Repair.fxout PDB_repaired/ && sleep 5 && cd PDB_repaired/ && sleep 5 && clear
#this part optimize pdb structures
echo '****OPTIMIZING PDB STRUCTURES****' && sleep 5 && echo '...' && sleep 5
for file in *pdb; do
    ./foldx --command=Optimize --pdb=$file;
done
sleep 5 && echo 'All PDB files have been optimized' && sleep 5 && echo 'SETTING NEW EMVIRONMENT' && sleep 5
mkdir PDB_optimized && sleep 5 && mv foldx rotabase.txt PDB_optimized && mv O* PDB_optimized/ && cd PDB_optimized/
sleep 5 && clear
#This part analyse protein-protein interaction energies 
echo 'ANALYSING COMPLEX' && sleep 5 && echo '...' && sleep 5
for file in *.pdb; do
#    ./foldx --command=AnalyseComplex --pdb=$file --analyseComplexChains=$chain_receptor,$chain_ligand;
#									 A and V are chain's names
     ./foldx --command=AnalyseComplex --pdb=$file --analyseComplexChains=A,V;
done
mkdir A_V && mv I* A_V/ && mv S* A_V/
for file in *.pdb; do
#    ./foldx --command=AnalyseComplex --pdb=$file --analyseComplexChains=$chain_receptor,$chain_ligand;
#									 C and V are chain's names 
     ./foldx --command=AnalyseComplex --pdb=$file --analyseComplexChains=C,V;
done
mkdir C_V && mv I* C_V/ && mv S* C_V/ && clear 
echo 'SETTING RESULTS' && sleep 5 && echo '...' && sleep 3
mv A_V/ ../../ && mv C_V/ ../../ && mv foldx rotabase.txt ../../ && cd ../../
mkdir Results_energies && mv A_V/ Res*/ && mv C_V/ Res*/
gedit Re*/A_V/Interac*
gedit Re*/C_V/Interac*
sleep 5 && clear && echo 'FOLDX HAS FINISHED COMPLETELY' && sleep 5
