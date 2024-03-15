rule genome_faidx:
    input:
        config["ref_genome"],
    output:
        config["ref_genome"] + ".fai",
    log:
        "logs/genome-faidx.log",
    cache: True
    resources:
        mem_mb=20000,
    wrapper:
        "v3.3.6/bio/samtools/faidx"


rule bwa_index:
    input:
        config["ref_genome"],
    output:
        multiext(config["ref_genome"], ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "logs/bwa_index.log",
    resources:
        mem_mb=20000,
    cache: True
    wrapper:
        "v3.3.6/bio/bwa/index"
        
rule dict_index:
    input:
        config["ref_genome"],
    output:
#        config["ref_genome"] + ".dict",
        config["ref_genome"].replace('fasta','dict')
    log:
        "logs/picard/create_dict.log",
    resources:
        mem_mb=20000,
    wrapper:
        "v3.3.6/bio/picard/createsequencedictionary"

rule star_index:
    input:
        unpack(choose_genome),
        gtf=config["ref_annotation"],
    output:
        directory("resources/star_genome"),
    threads: 4
    log:
        "logs/star_index_genome.log",
    cache: True
    resources:
        mem_mb=30000,
    wrapper:
        "v3.3.6/bio/star/index"
        
rule index_vcf:
    input:
        vcf = config["snp_vcf"],
    output:
        out = config["snp_vcf"] + ".idx",
    conda:
        "../envs/gatk_aserc.yaml",
    log:
        "logs/vcf_index.log",
    resources:
        mem_mb = 40000
    shell:
        """
        gatk IndexFeatureFile -I {input.vcf} 
        """
        
rule mask_fasta:
    input:
        fasta=config["ref_genome"],
        vcf = config["snp_vcf"],
    output:
        out=config["ref_genome"].replace('.fasta','.mask.fasta')
    conda:
        "../envs/bedtools.yaml",
    log:
        "logs/genome_mask.log",
    resources:
        mem_mb = 20000
    shell:
        "bedtools maskfasta -fi {input.fasta} -bed {input.vcf} -fo {output.out}"
