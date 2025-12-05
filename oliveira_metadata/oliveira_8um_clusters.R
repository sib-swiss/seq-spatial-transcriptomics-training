library(arrow)
library("RColorBrewer")
library("ggplot2")

meta<- read_parquet("oliveira_metadata/P1CRC_Metadata.parquet")

# load 8um binned data
# Import Visium HD data from Space Ranger output into a SpatialExperiment object.
spe <- TENxVisiumHD(
  spacerangerOut = "data/Human_Colon_Cancer_P1/",
  processing = "filtered",
  format = "h5",
  images = "lowres",
  bin_size = "008"
) |>
  import()

# match spots from metadata to spots in spe object
meta_sub <- meta[meta$barcode %in% colnames(spe), ]
# Ensure the order matches your spe object
all(colnames(spe) %in% meta$barcode)

# Add to colData (excluding the barcode column to avoid duplication)
colData(spe) <- cbind(colData(spe), meta_sub[, !names(meta_sub) %in% "barcode"])

# we will subset the dataset for computational and visual reasons
spe_s <- spe[, spatialCoords(spe)[, 1] * scaleFactors(spe) > 70 &
             spatialCoords(spe)[, 1] * scaleFactors(spe) < 130 &
             spatialCoords(spe)[, 2] * scaleFactors(spe) > 200 &
             spatialCoords(spe)[, 2] * scaleFactors(spe) < 260]

colData(spe_s)$DeconvolutionLabel1 <- droplevels(as.factor(colData(spe_s)$DeconvolutionLabel1))

# test some visualisation options

plotVisium(spe_s, annotate = "DeconvolutionLabel1", zoom = T)
plotVisium(spe_s, pal="Set1", annotate = "UnsupervisedL1", zoom = T)

#custom_palette <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", 
#                    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")

p1 + scale_color_manual(values = brewer.pal(length(unique(colData(spe_s)$UnsupervisedL1)), "Set3")) +
  scale_fill_manual(values = brewer.pal(length(unique(colData(spe_s)$UnsupervisedL1)), "Set3"))

plotCoords(spe_s, annotate = "UnsupervisedL1")
plotCoords(spe_s, annotate = "DeconvolutionLabel1")
plotVisium(spe_s, annotate = "GobletSubcluster", zoom = T)
plotVisium(spe_s, annotate = "MacrophageSubtype", zoom = T)
plotVisium(spe_s, annotate = "Periphery", zoom = T)


