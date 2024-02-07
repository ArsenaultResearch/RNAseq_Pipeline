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

rule run_aserc:
    input:
        bam = "results/add-rg/{sample}.bam",
        vcf = config["snp_vcf"],
        gen = config["ref_genome"],
    output:
        out = "results/aserc/{sample}_aserc.csv",
    conda:
        "workflow/envs/gatk_aserc.yaml",
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
