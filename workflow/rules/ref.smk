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


rule star_index:
    input:
        fasta=config["ref_genome"],
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