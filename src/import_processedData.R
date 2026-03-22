#####################################################
# import/load our extracted data into a usable format
######################################################

# Cerebral Vessel Data ----------------------------------------------------

#list rds files
processed_cerebral <-
    list.files(paste(getwd(), "data/processed/cerebral", sep = '/'),
               pattern = ".rds")

processed_cerebral <- processed_cerebral[!processed_cerebral %like%
                                             "Hist_Base_Data"]

# combine all chemicals for vessel data
cerebral_data <-
    lapply(processed_cerebral, import_cerebral_data) |>
    list_rbind() |>
    mutate(across(where(is.numeric), ~ replace_na(.x, 0))) |>
    mutate(flagM = grepl(".*M", measure))


# qRTPCR Data -------------------------------------------------------------
message("Importing and Combining BioRad Data")

## Import Various Catagories of qRTPCR Data
import_meltCurve <-
    list.files(paste(getwd(), "data/processed/qRTPCR/",sep = '/'),
               full.names = TRUE, pattern = "Curve") |>
    lapply(readRDS)

import_quant <-
    list.files(paste(getwd(), "data/processed/qRTPCR/",sep = '/'),
               full.names = TRUE, pattern = "Quant") |>
    lapply(readRDS)

import_endPoint <-
    list.files(paste(getwd(), "data/processed/qRTPCR/",sep = '/'),
               full.names = TRUE, pattern = "End_Point") |>
    readRDS()

## Combine Melt Curve Tables
meltCurve_cols <- c("Plate", "Run_Started", "Run_Ended",
                    "Lid_Temp", "Sample_Vol", "Well")

meltCurveAmp <- import_meltCurve[[1]] |>
    select(all_of(meltCurve_cols), MeltCurve_Amp, Temperature)

meltCurveDeriv <- import_meltCurve[[2]] |>
    select(all_of(meltCurve_cols), MeltCurve_Deriv, Temperature)

meltCurvePeak <- import_meltCurve[[3]] |>
    select(all_of(meltCurve_cols), Melt_Temperature,
           Begin_Temperature, End_Temperature, Peak_Height)

meltCurve_data <-
    full_join(meltCurveAmp, meltCurveDeriv) |>
    full_join(meltCurvePeak, join_by(Plate, Run_Started, Run_Ended,
                                     Lid_Temp, Sample_Vol, Well),
              relationship = "many-to-many")


## Combine Quant Tables
quantAmp <- import_quant[[1]] |>
    select(Cycle, Plate, Well, Run_Started, Run_Ended,
           Lid_Temp,Sample_Vol, Quant_Amp)

quantCq <- import_quant[[2]] |>
    select(Plate, Well, Run_Started, Run_Ended, Lid_Temp, Sample_Vol,
           starts_with("Cq"))

quant_data <- full_join(quantAmp, quantCq,
                        join_by(Plate, Well, Run_Started, Run_Ended,
                                Lid_Temp, Sample_Vol),
                        relationship = "many-to-many")

## EndPoint Table
endPoint_data <- import_endPoint |>
    select(Plate, Well, Run_Started, Run_Ended, Lid_Temp, Sample_Vol,
           End_RFU)

## Join all qRTPCR Data
bioRad_data <-
    full_join(meltCurve_data,quant_data,
              join_by(Plate, Well, Run_Started, Run_Ended,
                      Lid_Temp, Sample_Vol),
              relationship = "many-to-many") |>
    full_join(endPoint_data,
              join_by(Plate, Well, Run_Started, Run_Ended,
                      Lid_Temp, Sample_Vol)) |>
    mutate(Plate = as.numeric(Plate)) |>
    relocate(c(Plate, Well, Cycle, Temperature),
             .after = Run_Ended) |>
    relocate(c(Cq, Cq_Mean, Cq_Std._Dev,
               Peak_Height, MeltCurve_Amp, MeltCurve_Deriv,
               Quant_Amp, End_RFU),
             .after = Temperature) |>
    relocate(c(Lid_Temp, Sample_Vol),
             .after = End_Temperature)



# qRTPCR Plate Data - Channels --------------------------------------------
message("Importing and combing qRTPCR Plate Channel Data")
qRTPCR_channels <-
    list.files(paste(getwd(), "data/processed/qRTPCR/",sep = '/'),
               full.names = TRUE, pattern = "channel") |>
    lapply(readRDS) |>
    list_rbind() |>
    select(Researcher, channel, Plate, cDNA_synth, qPCRreplicate, Replicate,
           Ind_Extr, Label, water_temp, Position, Gene, Tissue, Exposure,
           Ind_Exp, CrossingPoint, Individual_Efficiency, Included)



# Combing BioRad and Channel Data -----------------------------------------
message("Combining BioRad and qRTPCR Plate Channel Data")
bioRad_withChannels <-
    full_join(bioRad_data, qRTPCR_channels,
              join_by(Plate, Well == Position),
              relationship = "many-to-many")

# Collect Garbage ---------------------------------------------------------
message("Collecting Garbage, freeing memory")
rm(processed_cerebral,
   import_meltCurve, import_quant, import_endPoint,
   meltCurveAmp, meltCurveDeriv, meltCurvePeak,
   quantAmp, quantCq,
   meltCurve_data, quant_data, endPoint_data,
   bioRad_data,qRTPCR_channels)
