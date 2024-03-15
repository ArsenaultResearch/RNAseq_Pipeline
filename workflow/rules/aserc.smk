rule add_rg:
    input:
        "results/star_2p/{sample}_Aligned.sortedByCoord.out.bam",
    output:
        "results/add-rg/{sample}.bam",
    log:
        "logs/add_rg/{sample}.log",
    params:
        extra="--RGLB lib1 --RGPL ILLUMINA --RGPU {sample} --RGSM {sample}",
    resources:
        mem_mb=20000,
    wrapper:
        "v2.6.0/bio/picard/addorreplacereadgroups"
        
# rule markduplicates_bam:
#     input:
#         bams="results/add-rg/{sample}.bam",
#     output:
#         bam="results/markdupe/{sample}.bam",
#         metrics="results/markdupe/{sample}.metrics.txt",
#     log:
#         "logs/dedup_bam/{sample}.log",
#     resources:
#         mem_mb=10000,
#     wrapper:
#         "v3.3.6/bio/picard/markduplicates"


rule run_aserc:
    input:
        bam = "results/add-rg/{sample}.bam",
        vcf = config["snp_vcf"],
        gen = config["ref_genome"],
        indices = multiext(config["ref_genome"], ".amb", ".ann", ".bwt", ".pac", ".sa",".fai"),
        dctnry = config["ref_genome"].replace('fasta','dict'),
        vcf_idx = config["snp_vcf"] + ".idx",
    output:
        out = "results/aserc/{sample}_aserc.csv",
    conda:
        "../envs/gatk_aserc.yaml",
    log:
        "logs/aserc/{sample}.txt",
    resources:
        mem_mb = 40000
    shell:
        """
        gatk ASEReadCounter \
            -R {input.gen} \
            -I {input.bam} \
            -V {input.vcf} \
            -O  {output.out} 
        """
