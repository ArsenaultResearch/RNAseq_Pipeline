rule multiqc_dir:
    input:
        unpack(get_2p),
    output:
        "qc/multiqc.html",
        directory("qc/multiqc_data"),
    params:
        extra="--data-dir results/trim_galore results/star_2p",  
    log:
        "logs/multiqc.log",
    wrapper:
        "v3.3.6/bio/multiqc"
