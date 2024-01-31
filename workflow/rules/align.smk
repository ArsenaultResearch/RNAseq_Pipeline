rule align_1p:
    input:
        unpack(get_trimmed_fq),
        index="resources/star_genome",
        gtf=ref_annotation,
    output:
        aln="results/star_1p/{sample}_Aligned.sortedByCoord.out.bam",
        sj="results/star_1p/{sample}_SJ.out.tab",
    log:
        "logs/star_1p/{sample}.log",
    params:
        idx=lambda wc, input: input.index,
        extra=lambda wc, input: f'--outSAMtype BAM SortedByCoordinate --sjdbGTFfile {input.gtf} {config["params"]["star"]}',
    threads: 24
    wrapper:
        "v3.3.6/bio/star/align"

rule align_2p:
    input:
        unpack(get_trimmed_fq),
        index="resources/star_genome",
        gtf=ref_annotation,
        SJfiles=unpack(get_sj)
    output:
        aln="results/star_2p/{sample}_Aligned.sortedByCoord.out.bam",
        reads_per_gene="results/star_2p/{sample}_ReadsPerGene.out.tab",
    log:
        "logs/star_2p/{sample}.log",
    params:
        idx=lambda wc, input: input.index,
        extra=lambda wc, input: f'--outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --sjdbGTFfile {input.gtf} --sjdbFileChrStartEnd {input.SJfiles} {config["params"]["star"]}',
    threads: 24
    wrapper:
        "v3.3.6/bio/star/align"