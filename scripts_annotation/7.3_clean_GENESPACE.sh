#!/bin/bash

#SBATCH --job-name=clean_GENESPACE
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --time=1:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/clean_GENESPACE_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/clean_GENESPACE_%j.e

WD="/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE"
cd "$WD"

# 1) Sanitize all peptide FASTAs (both .fa and .faa):
#    - keep only the first token in header (before space)
#    - replace any ':' with '_'
#    - strip common transcript suffixes: -R*, .tN
for f in peptide/*; do
  tmp="$f.tmp"
  awk '
    BEGIN{OFS=""}
    /^>/{
      h=$0; sub(/^>/,"",h);            # remove leading ">"
      split(h,parts,/ /); id=parts[1]; # keep token before first space
      gsub(/:/,"_",id);                # no colons allowed
      sub(/-R[[:alnum:]]+$/,"",id);    # drop -RA/-RB/-R1 etc.
      sub(/\.t[0-9]+$/,"",id);         # drop .t1/.t2
      print ">" id; next
    }
    {print}
  ' "$f" > "$tmp" && mv "$tmp" "$f"
done

# 2) Rebuild genomes.list from the actual filenames (guarantees consistency)
beds=$(for b in bed/*.bed; do basename "$b" .bed; done | sort -u)
peps=$(for p in peptide/*; do basename "$p" | sed -E 's/\.(fa|faa)$//' ; done | sort -u)
comm -12 <(printf "%s\n" $beds | sort) <(printf "%s\n" $peps | sort) > genomes.list

# 3) Verify IDs are clean (no '-', spaces, or ':')
echo "Genomes GENESPACE will use:"
nl -ba genomes.list
echo "Illegal characters (should show nothing):"
grep -nE '[^A-Za-z0-9_.]' genomes.list || echo "OK"
