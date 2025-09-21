######################
# Join the transformed raw BioRad data to save and prep for import
######################

# Join tables 2 (Melt Curve Amp) and 3 (Melt Curve Deriv.).
# Both tables have same cols
tbl_2and3 <- full_join(bioRad_transformed_list[[2]],
                       bioRad_transformed_list[[3]])
