rule genome_faidx:
    input:
        ref_genome,
    output:
        ref_genome + ".fai",
    log:
        "logs/genome-faidx.log",
    cache: True
    wrapper:
        "v3.3.6/bio/samtools/faidx"


rule bwa_index:
    input:
        ref_genome,
    output:
        multiext(ref_genome, ".amb", ".ann", ".bwt", ".pac", ".sa"),
    log:
        "logs/bwa_index.log",
    resources:
        mem_mb=10000,
    cache: True
    wrapper:
        "v3.3.6/bio/bwa/index"


rule star_index:
    input:
        fasta=ref_genome,
        gtf=ref_annotation,
    output:
        directory("resources/star_genome"),
    threads: 4
    log:
        "logs/star_index_genome.log",
    cache: True
    wrapper:
        "v3.3.6/bio/star/index"