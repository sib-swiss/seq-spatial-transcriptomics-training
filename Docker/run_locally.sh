docker run \
--rm \
-p 8787:8787 \
-e ROOT=true \
-v $PWD:/home/rstudio/seq-spatial-transcriptomics-training \
sibswiss/training-seq-spatial-transcriptomics-rstudio:latest
