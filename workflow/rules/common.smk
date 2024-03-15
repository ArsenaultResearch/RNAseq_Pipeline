import glob
import pandas as pd
from snakemake.utils import validate


validate(config, schema="../schemas/config.schema.yaml")

samples = (
    pd.read_csv(config["samples"], sep="\t", dtype={"sample": str})
    .set_index("sample", drop=False)
    .sort_index()
)
validate(samples,schema="../schemas/samples.schema.yaml")

##### Wildcard constraints #####

wildcard_constraints:
    sample="|".join(samples["sample"]),

##### Helper functions #####

def get_final_output():
    final_output = expand("results/star_2p/{sample}_ReadsPerGene.out.tab",sample=SAMPLES)
    final_output.append("qc/multiqc.html")
    if config["compute_aserc"]:
        final_output.extend(expand("results/aserc/{sample}_aserc.csv",sample=SAMPLES))
    return final_output

def get_fastq(wildcards):
    """Get fastq files of given sample-group."""
    fastqs = samples.loc[(wildcards.sample), ["fq1", "fq2"]].dropna()
    if len(fastqs) == 2:
        return {"r1": fastqs.fq1, "r2": fastqs.fq2}
    return {"r1": fastqs.fq1}

def is_single_end(sample):
    """Return True if sample-group is single end."""
    return pd.isnull(samples.loc[sample, "fq2"])


def get_trimmed_fq(wildcards):
    """Get trimmed reads of given sample-group."""
    if not is_single_end(**wildcards):
        # paired-end sample
        return {"fq1": "results/trim_galore/{sample}_R1.fq.gz".format(**wildcards), "fq2": "results/trim_galore/{sample}_R2.fq.gz".format(**wildcards) }
    # single end sample
    return {"fq1": "results/trim_galore/{sample}_R1.fq.gz".format(**wildcards)}

SAMPLES=samples['sample'].tolist()

def get_sj(wilcards):
    """Collect the Star_1p SJ files to send to 2pass alignment"""
    return expand(
        "results/star_1p/{sample}_SJ.out.tab",
        sample=SAMPLES
    )
    

def get_2p(wildcards):
    """Collect the Star_2p alignment files to verify multiQC can run"""
    return expand(
        "results/star_2p/{sample}_ReadsPerGene.out.tab",
        sample=SAMPLES
    )

def choose_genome(wildcards):
    if config["compute_aserc"]:
        final_output = config["ref_genome"].replace('.fasta','.mask.fasta')
    else:
        final_output = config["ref_genome"]
    return {"fasta": final_output}
