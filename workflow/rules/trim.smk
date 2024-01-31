rule trim_galore_se:
    input:
        unpack(get_fastq),
    output:
        fasta="results/trim_galore/{sample}_trimmed.fq.gz",
        report=" results/trim_galore/report/{sample}.fastq.gz_trimming_report.txt",
    threads: 4
    log:
        "logs/trim_galore/{sample}.log",
    message:
        "Trimming fastq reads with TrimGalore. Sample: {wildcards.sample}"
    wrapper:
        "v3.3.6/bio/trim_galore/se"
        
rule trim_galore_pe:
    input:
        unpack(get_fastq),
    output:
        fasta_fwd="results/trim_galore/{sample}_R1.fq.gz",
        report_fwd="results/trim_galore/reports/{sample}_R1_trimming_report.txt",
        fasta_rev="results/trim_galore/{sample}_R2.fq.gz",
        report_rev="results/trim_galore/reports/{sample}_R2_trimming_report.txt",
    threads: 4
    log:
        "logs/trim_galore/{sample}.log",
    message:
        "Trimming fastq reads with TrimGalore. Sample: {wildcards.sample}"
    wrapper:
        "v3.3.6/bio/trim_galore/pe"

