#!/bin/bash
##### Firstly check log value generated in Overall_degs.csv ###################
##head GSE*Overall_degs.csv | sed "s/,/\t/g" | cut -f1,5,7 ##1= gene and 5 = log_value
#If logfc is not generated for some samples check the error and rerun analysis.
##IF error not found then remove those file GSE_Overall_degs.csv files which is having logfc==0 ##### 
###After the error check run this script#####


#####In loop to featch Gene-log-pvalue from GSE_overall_degs.csv ####
#$cd /data/users-workspace/komal.bhosle/Asthma/Asthma_Microarray ##(go to folder where results generated)
echo "started gene-logfc-pvalue text making"
mkdir all_txt_files
for f in *Overall_degs.csv; do cat $f | sed "s/,/\t/g" | cut -f1,5,7 | sed "s/\t/,/g" > all_txt_files/$f; done
echo "Done with text making"


###to check logfc generated properly in all files 
#echo "stareted check logfc generated or not"
#cd all_txt_files/
#sed "s/,/\t/g" | head GSE*.csv
#echo "done"



#######create Merged.csv from all sample combination ##
echo "started meging files"
cd all_txt_files/
cat PRJNA*.csv > Merged.csv
echo "Done with merging"


######after merging to remove /// seperated genes and only keep first gene symbol from each#####
echo "started to sep gene sep by ///"
cat Merged.csv | sed "s/,/\t/" | sed "s/\//\t/" | awk '{print $1, "," $NF}' | tr -d "[:blank:]"  > Merged_normalized.csv
echo "done with normalization"
###where, sed "s/,/\t/" ===To convert csv to txt, sed "s/\//\t/" ====To replace slash sep gene with tab, awk '{print $1, "," $NF}'===keep only first and last column, tr -d "[:blank:]" ==== to remove blank spaces.



####To filter the more significant p value gene####
echo "filtering significant pvalue"
cat Merged_normalized.csv | sed "s/,/\t/g" | sort -k3 | uniq | awk '!seen[$1]++' > indication_final_out.txt
echo "Done with filtering"



#####filtering
#open this file in excel
#filter file and remove unwanted genes (XLOC)
#Validate Gene symbols by HGNC database





