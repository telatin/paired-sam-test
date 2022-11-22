all: mapdir/bwa.bam.bai

clean:
	rm -rf mapdir
mapdir:
	mkdir -p mapdir

mapdir/bwa.bam: mapdir/bwa.raw.bam
	samtools sort -n  -o mapdir/tmp.bam $< 2>/dev/null
	samtools fixmate mapdir/tmp.bam mapdir/fix.bam 2>/dev/null
	samtools sort -o $@ mapdir/fix.bam
	rm mapdir/tmp.bam mapdir/fix.bam

mapdir/bwa.bam.bai: mapdir/bwa.bam
	samtools index $< 2>/dev/null

mapdir/bwa.raw.bam: ref/ref.fa reads/reads_R1.fq reads/reads_R2.fq mapdir
	echo ALIGN
	bwa mem ref/ref.fa reads/reads_R1.fq reads/reads_R2.fq  | samtools sort -o mapdir/bwa.raw.bam - 2> /dev/null
