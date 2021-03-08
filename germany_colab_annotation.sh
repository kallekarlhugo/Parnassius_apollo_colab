# run with bash 05.braker2_annotation.sh
mkdir annotation && cd annotation
mkdir assemblies
basepath=$(pwd)/
mkdir proteins && cd proteins
cd proteins
wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
tar xvf odb10_arthropoda_fasta.tar.gz
cat arthropoda/Rawdata/* > odb10_arthropoda_proteins.fa
proteins=$(pwd)/odb10_arthropoda_proteins.fa
cd ../assemblies
ln -s <PATH TO ASSEMBLUES> # edit this to make links to your assemblies.
genomepath=$(pwd)/
cd ..
mkdir rnaseq && cd rnaseq
bash map.sh
sambamba sort *bam
bampath=$(pwd)/
#set paths
cp -r /data/programs/Augustus_v3.3.3/config/ $(pwd)/augustus_config
export AUGUSTUS_CONFIG_PATH=$(pwd)/augustus_config
# now set paths to the other tools
export PATH=/data/programs/BRAKER2_v2.1.5/scripts//:$PATH
export AUGUSTUS_BIN_PATH=/mnt/griffin/kaltun/software/Augustus/bin
export AUGUSTUS_SCRIPTS_PATH=/mnt/griffin/kaltun/software/Augustus/scripts
export DIAMOND_PATH=/data/programs/diamond_v0.9.24/
export GENEMARK_PATH=/data/programs/gmes_linux_64.4.61_lic/
export BAMTOOLS_PATH=/data/programs/bamtools-2.5.1/bin/
export PROTHINT_PATH=/data/programs/ProtHint/bin/
export ALIGNMENT_TOOL_PATH=/data/programs/gth-1.7.0-Linux_x86_64-64bit/bin
export SAMTOOLS_PATH=/data/programs/samtools-1.10/
export MAKEHUB_PATH=/data/programs/MakeHub/

# RUN
cd $basepath && mkdir prot && cd prot
prot=$(pwd)
# Papollo
genome=Parnassius_apollo_shasta7k_pepper.fasta.PolcaCorrected.UPPER.fa.masked.purged.fa
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=${genomepath}$genome --prot_seq=$proteins --cores=20 --gff3 --softmasking

# RNA_PROT
cd $basepath && mkdir rna_prot && cd rna_prot
rna_prot=$(pwd)
# Parnassius
genome=Parnassius_apollo_shasta7k_pepper.fasta.PolcaCorrected.UPPER.fa.masked.purged.fa
bamfile=${bampath}Parnassius_apollo_shasta7k_pepper.fasta.PolcaCorrected.UPPER.fa.masked.purged._PE.sorted.bam
mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --softmasking --etpmode --cores=10 --gff3

# agat fix
/mnt/griffin/chrwhe/software/AGAT/bin/agat_convert_sp_gxf2gxf.pl --gff braker.gff3 -o braker.agat.gff3
# get stats
/mnt/griffin/chrwhe/software/AGAT/bin/agat_sp_statistics.pl --gff braker.agat.gff3 -g ../../../assemblies/Parnassius_apollo_shasta7k_pepper.fasta.PolcaCorrected.UPPER.fa.masked.purged.fa  -o braker.agat.stats
# Compute mrna with isoforms if any
# 
# Number of genes                              28334
# Number of mrnas                              30102
# Number of cdss                               30102
# Number of exons                              142655
# Number of introns                            112553
# Number of start_codons                       29891
# Number of stop_codons                        29950
# Number of exon in cds                        142655
# Number of intron in cds                      112553
# Number of intron in exon                     112553
# Number of intron in intron                   92947
# Number gene overlapping                      39
# Number of single exon gene                   10338
# Number of single exon mrna                   10496
# mean mrnas per gene                          1.1
# mean cdss per mrna                           1.0
# mean exons per mrna                          4.7
# mean introns per mrna                        3.7
# mean start_codons per mrna                   1.0
# mean stop_codons per mrna                    1.0
# mean exons per cds                           4.7
# mean introns in cdss per mrna                3.7
# mean introns in exons per mrna               3.7
# mean introns in introns per mrna             3.1
# Total gene length                            381020510
# Total mrna length                            451475718
# Total cds length                             35435293
# Total exon length                            35435293
# Total intron length                          416040425
# Total start_codon length                     89673
# Total stop_codon length                      89850
# Total intron length per cds                  416152978
# Total intron length per exon                 416152978
# Total intron length per intron               18080359
# mean gene length                             13447
# mean mrna length                             14998
# mean cds length                              1177
# mean exon length                             248
# mean intron length                           3696
# mean start_codon length                      3
# mean stop_codon length                       3
# mean cds piece length                        248
# mean intron in cds length                    3697
# mean intron in exon length                   3697
# mean intron in intron length                 194
# Longest gene                                 440283
# Longest mrna                                 440283
# Longest cds                                  62964
# Longest exon                                 12751
# Longest intron                               279773
# Longest start_codon                          3
# Longest stop_codon                           3
# Longest cds piece                            12751
# Longest intron into cds part                 279774
# Longest intron into exon part                279774
# Longest intron into intron part              12752
# Shortest gene                                114
# Shortest mrna                                114
# Shortest cds                                 16
# Shortest exon                                3
# Shortest intron                              61
# Shortest start_codon                         3
# Shortest stop_codon                          3
# Shortest cds piece                           3
# Shortest intron into cds part                62
# Shortest intron into exon part               62
# Shortest intron into intron part             6
