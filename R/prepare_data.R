###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

# library
# library(dplyr)
# library(stringr)
# library(sf)
# library(mapproj)
# library(ggplot2)
# library(geojsonio)

# read in ISO codes
ISO_codes <- read.csv("data/ISO_A3_codes.csv", stringsAsFactors = FALSE)

# read in data
map_data <- sf::read_sf("data/ne_50m_admin_0_map_subunits")

# conver to data frame
# map_data <- as.data.frame(map_data)

# choose variables
map_data <- select(map_data, SOVEREIGNT, SOV_A3, ADMIN, ADM0_A3, SUBUNIT, SU_A3, CONTINENT, REGION_UN, SUBREGION, geometry)

# rename variables
names(map_data) <- c("SOV_name", "SOV_code", "ADMIN_name", "ADMIN_code", "UNIT_name", "UNIT_code", "continent", "UN_region", "UN_subregion", "geometry")

# valid ISO code
map_data$valid_ISO_code <- as.numeric(map_data$ADMIN_code %in% ISO_codes$ISO_A3)

##################################################
# SOV codes
##################################################

# list of invalid IOS codes
unique(map_data$SOV_code[!(map_data$SOV_code %in% ISO_codes$ISO_A3)])

# codes to fix
map_data$SOV_code[map_data$SOV_code == "SDS"] <- "SSD" # South Sudan
map_data$SOV_code[map_data$SOV_code == "US1"] <- "USA"
map_data$SOV_code[map_data$SOV_code == "GB1"] <- "GBR"
map_data$SOV_code[map_data$SOV_code == "NZ1"] <- "NZL"
map_data$SOV_code[map_data$SOV_code == "NL1"] <- "NLD"
map_data$SOV_code[map_data$SOV_code == "IS1"] <- "ISR"
map_data$SOV_code[map_data$SOV_code == "FR1"] <- "FRA"
map_data$SOV_code[map_data$SOV_code == "FI1"] <- "FIN"
map_data$SOV_code[map_data$SOV_code == "DN1"] <- "DNK"
map_data$SOV_code[map_data$SOV_code == "CH1"] <- "CHN"
map_data$SOV_code[map_data$SOV_code == "AU1"] <- "AUS"

# codes to keep
# SOL = Somaliland
# SAH = Western Sahara
# KOS = Kosovo
# CYN = Northern Cyprus
# KAS = Kashmir

##################################################
# clean ADMIN codes
##################################################

# codes to check
unique(map_data$ADMIN_code[!(map_data$ADMIN_code %in% ISO_codes$ISO_A3)])

# SOL = Somaliland
# SAH = Western Sahara
# KOS = Kosovo
# CYN = Northern Cyprus
# KAS = Kashmir

# South Sudan (recode)
map_data$ADMIN_code[map_data$ADMIN_code == "SDS"] <- "SSD"

# Finland (collapse all)
map_data$ADMIN_name[map_data$ADMIN_code == "ALD"] <- "Finland"
map_data$ADMIN_code[map_data$ADMIN_code == "ALD"] <- "FIN"

# Australia (collapse in Indian Ocean Territories and Ashmore and Cartier Islands)
map_data$ADMIN_name[map_data$ADMIN_code == "IOA"] <- "Australia"
map_data$ADMIN_code[map_data$ADMIN_code == "IOA"] <- "AUS"
map_data$ADMIN_name[map_data$ADMIN_code == "ATC"] <- "Australia"
map_data$ADMIN_code[map_data$ADMIN_code == "ATC"] <- "AUS"

##################################################
# ADMIN variables
##################################################

# count variables
map_data <- map_data %>% group_by(ADMIN_code) %>% mutate(unit_ID = 1:n(), unit_count = n())

##################################################
# clean UNIT codes
##################################################

# codes to check
unique(map_data$UNIT_code[!(map_data$UNIT_code %in% ISO_codes$ISO_A3)])

# Antarctica (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "ATB"] <- "ATA" # Antarctica
map_data$UNIT_code[map_data$UNIT_code == "ATP"] <- "ATA" # Peter I Island
map_data$UNIT_code[map_data$UNIT_code == "ATS"] <- "ATA" # South Orkney Islands

# Antigua and Barbuda (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "ACA"] <- "ATG" # Antigua
map_data$UNIT_code[map_data$UNIT_code == "ACB"] <- "ATG" # Barbuda

# Austrialia (recode)
map_data$UNIT_code[map_data$UNIT_code == "AUS"] <- "AUS-main" # Australia
map_data$UNIT_code[map_data$UNIT_code == "AUA"] <- "AUS-main" # Tasmania
map_data$UNIT_code[map_data$UNIT_code == "AUM"] <- "AUS-other" # Macquarie Island
map_data$UNIT_code[map_data$UNIT_code == "CXR"] <- "AUS-other" # Christmas Island
map_data$UNIT_code[map_data$UNIT_code == "CCK"] <- "AUS-other" # Cocos Islands
map_data$UNIT_code[map_data$UNIT_code == "ATC"] <- "AUS-other" # Ashmore and Cartier Islands

# Belgium (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "BFR"] <- "BEL" # Flanders Region
map_data$UNIT_code[map_data$UNIT_code == "BWR"] <- "BEL" # Walloon Region
map_data$UNIT_code[map_data$UNIT_code == "BCR"] <- "BEL" # Brussels Capital Region

# Bosnia and Herzegovina (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "BIS"] <- "BIH" # Republic Srpska
map_data$UNIT_code[map_data$UNIT_code == "BHF"] <- "BIH" # Bosnia and Herzegovina

# Chile (recode)
map_data$UNIT_code[map_data$UNIT_code == "CHL"] <- "CHL-main"
map_data$UNIT_code[map_data$UNIT_code == "CHP"] <- "CHL-other" # Easter Island
map_data$UNIT_code[map_data$UNIT_code == "CHS"] <- "CHL-other" # Isla Sala y Gomez

# China (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "CHI"] <- "CHN" # China
map_data$UNIT_code[map_data$UNIT_code == "CHH"] <- "CHN" # Hainan

# Denmark (collapse all)
# DNK = Denmark
map_data$UNIT_code[map_data$UNIT_code == "DNB"] <- "DNK" # Bornholm

# East Timor (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "TLX"] <- "TLS"
map_data$UNIT_code[map_data$UNIT_code == "TLP"] <- "TLS"

# Ecuador (recode)
map_data$UNIT_code[map_data$UNIT_code == "ECD"] <- "ECU-main" # Ecuador
map_data$UNIT_code[map_data$UNIT_code == "ECG"] <- "ECU-other" # Galapagos Islands

# Equatorial Guinea (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "GNK"] <- "GNQ" # Bioko
map_data$UNIT_code[map_data$UNIT_code == "GNR"] <- "GNQ" # Rio Muni

# Finland (collapse all)
# FIN = Finland
map_data$UNIT_code[map_data$UNIT_code == "ALD"] <- "FIN" # Aland

# France (recode)
map_data$UNIT_code[map_data$UNIT_code == "FXX"] <- "FRA-main" # France
map_data$UNIT_code[map_data$UNIT_code == "FXC"] <- "FRA-main" # Corsica
map_data$UNIT_code[map_data$UNIT_code == "MYT"] <- "FRA-other" # Mayotte
map_data$UNIT_code[map_data$UNIT_code == "REU"] <- "FRA-other" # Reunion
map_data$UNIT_code[map_data$UNIT_code == "MTQ"] <- "FRA-other" # Martinique
map_data$UNIT_code[map_data$UNIT_code == "GLP"] <- "FRA-other" # Guadeloupe
map_data$UNIT_code[map_data$UNIT_code == "GUF"] <- "FRA-other" # French Guiana

# India (recode)
map_data$UNIT_code[map_data$UNIT_code == "INX"] <- "IND-main" # India
map_data$UNIT_code[map_data$UNIT_code == "INN"] <- "IND-other" # Nicobar Islands
map_data$UNIT_code[map_data$UNIT_code == "INA"] <- "IND-other" # Andaman Islands
map_data$UNIT_code[map_data$UNIT_code == "INL"] <- "IND-other" # Lakshadweep

# Palestine (no changes)
# GAZ = Gaza
# WEB = West Bank

# Italy (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "ITX"] <- "ITA" # Italy
map_data$UNIT_code[map_data$UNIT_code == "ITP"] <- "ITA" # Pantelleria
map_data$UNIT_code[map_data$UNIT_code == "ITY"] <- "ITA" # Sicily
map_data$UNIT_code[map_data$UNIT_code == "ITD"] <- "ITA" # Sardinia

# Japan (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "JPN"] <- "JPN" # Japan
map_data$UNIT_code[map_data$UNIT_code == "JPB"] <- "JPN" # Bonin Islands
map_data$UNIT_code[map_data$UNIT_code == "JPK"] <- "JPN" # Hokkaido
map_data$UNIT_code[map_data$UNIT_code == "JPY"] <- "JPN" # Kyushu
map_data$UNIT_code[map_data$UNIT_code == "JPS"] <- "JPN" # Shikoku
map_data$UNIT_code[map_data$UNIT_code == "JPH"] <- "JPN" # Honshu
map_data$UNIT_code[map_data$UNIT_code == "JPO"] <- "JPN" # Nanseishoto
map_data$UNIT_code[map_data$UNIT_code == "JPI"] <- "JPN" # Izushoto

# Netherlands (recode)
map_data$UNIT_code[map_data$UNIT_code == "NLD"] <- "NLD-main" # Netherlands
map_data$UNIT_code[map_data$UNIT_code == "NLY"] <- "NLD-other" # Caribbean Netherlands

# New Zealand (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "NZS"] <- "NZL-main" # South Island
map_data$UNIT_code[map_data$UNIT_code == "NZN"] <- "NZL-main" # North Island
map_data$UNIT_code[map_data$UNIT_code == "NZA"] <- "NZL-other" # Sub-Antarctic Islands
map_data$UNIT_code[map_data$UNIT_code == "NZC"] <- "NZL-other" # Chatham Islands
map_data$UNIT_code[map_data$UNIT_code == "TKL"] <- "NZL-other" # Tokelau

# Norway (recode)
map_data$UNIT_code[map_data$UNIT_code == "NOR"] <- "NOR-main"
map_data$UNIT_code[map_data$UNIT_code == "NJM"] <- "NOR-other" # Jan Mayen
map_data$UNIT_code[map_data$UNIT_code == "NSV"] <- "NOR-other" # Svalbard

# Papua New Guinea (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "PNX"] <- "PNG" # Papua New Guinea
map_data$UNIT_code[map_data$UNIT_code == "PNB"] <- "PNG" # Bougainville

# Portugal (recode)
map_data$UNIT_code[map_data$UNIT_code == "PRX"] <- "PRT-main" # Portugal
map_data$UNIT_code[map_data$UNIT_code == "PMD"] <- "PRT-other" # Madeira
map_data$UNIT_code[map_data$UNIT_code == "PAZ"] <- "PRT-other" # Azores

# Serbia (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "SRB"] <- "PRT-other" # Serbia
map_data$UNIT_code[map_data$UNIT_code == "SRB"] <- "PRT-other" # Vojvodina

# Russia (recode)
map_data$UNIT_code[map_data$UNIT_code == "RUA"] <- "RUS-main" # Russia (Asia)
map_data$UNIT_code[map_data$UNIT_code == "RUE"] <- "RUS-main" # Russia (Europe)
map_data$UNIT_code[map_data$UNIT_code == "RUK"] <- "RUS-other" # Kaliningrad
map_data$UNIT_code[map_data$UNIT_code == "RUC"] <- "RUS-other" # Crimea

# Sao Tome and Principe (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "STA"] <- "STP" # Principe
map_data$UNIT_code[map_data$UNIT_code == "STS"] <- "STP" # Sao Tome

# South Africa (recode)
map_data$UNIT_code[map_data$UNIT_code == "ZAX"] <- "ZAF-main" # South Africa
map_data$UNIT_code[map_data$UNIT_code == "ZAI"] <- "ZAF-other" # Prince Edward Islands

# South Korea (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "KOR"] <- "KOR" # South Korea
map_data$UNIT_code[map_data$UNIT_code == "KOU"] <- "KOR" # Ulleungdo
map_data$UNIT_code[map_data$UNIT_code == "KOJ"] <- "KOR" # Jejudo

# Spain (recode)
map_data$UNIT_code[map_data$UNIT_code == "ESX"] <- "ESP-main" # Spain
map_data$UNIT_code[map_data$UNIT_code == "ESI"] <- "ESP-main" # Balearic Islands
map_data$UNIT_code[map_data$UNIT_code == "ESC"] <- "ESP-other" # Canary Islands

# Trinidad and Tobago (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "TTD"] <- "TTO" # Trinidad
map_data$UNIT_code[map_data$UNIT_code == "TTG"] <- "TTO" # Tobago

# United Kingdom (recode)
map_data$UNIT_code[map_data$UNIT_code == "WLS"] <- "GBR-main" # Wales
map_data$UNIT_code[map_data$UNIT_code == "SCT"] <- "GBR-main" # Scotland
map_data$UNIT_code[map_data$UNIT_code == "NIR"] <- "GBR-main" # Northern Ireland
map_data$UNIT_code[map_data$UNIT_code == "ENG"] <- "GBR-main" # England
map_data$UNIT_code[map_data$UNIT_code == "SGX"] <- "GBR-other" # South Sandwich Islands
map_data$UNIT_code[map_data$UNIT_code == "SGG"] <- "GBR-other" # South Georgia
map_data$UNIT_code[map_data$UNIT_code == "SHN"] <- "GBR-other" # Saint Helena
map_data$UNIT_code[map_data$UNIT_code == "BAC"] <- "GBR-other" # Ascension

# Tanzania (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "TZA"] <- "TZA" # Tanzania
map_data$UNIT_code[map_data$UNIT_code == "TZZ"] <- "TZA" # Zanzabar

# United States (recode)
map_data$UNIT_code[map_data$UNIT_code == "USB"] <- "USA-main" # United States
map_data$UNIT_code[map_data$UNIT_code == "USK"] <- "USA-other" # Alaska
map_data$UNIT_code[map_data$UNIT_code == "USH"] <- "USA-other" # Hawaii

# Yemen (collapse all)
map_data$UNIT_code[map_data$UNIT_code == "YEM"] <- "YEM" # Yemen
map_data$UNIT_code[map_data$UNIT_code == "YES"] <- "YEM" # Suqutra

##################################################
# region variables
##################################################

# continent
map_data$continent[map_data$continent == "Seven seas (open ocean)"] <- "Open Ocean"

# UN region
map_data$UN_region[map_data$UN_region == "Seven seas (open ocean)"] <- "Open Ocean"

# UN subregion
map_data$UN_subregion[map_data$UN_subregion == "Seven seas (open ocean)"] <- "Open Ocean"

##################################################
# collapse
##################################################

# collapse by ADMIN code
map_data <- map_data %>% 
  group_by(UNIT_code) %>% 
  summarize(
    SOV_name = SOV_name[1],
    SOV_code = SOV_code[1],
    ADMIN_name = ADMIN_name[1],
    ADMIN_code = ADMIN_code[1],
    continent = str_c(unique(continent), collapse = ", "),
    UN_region = str_c(unique(UN_region), collapse = ", "),
    UN_subregion = str_c(unique(UN_subregion), collapse = ", "),
    valid_ISO_code = as.numeric(sum(valid_ISO_code) > 0)
  )

# st_combine()

##################################################
# EU variables
##################################################

map_data$EU6 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg"))
map_data$EU9 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "United Kingdom", "Ireland", "Denmark"))
map_data$EU10 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "United Kingdom", "Ireland", "Denmark", "Greece"))
map_data$EU12 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "United Kingdom", "Ireland", "Denmark", "Greece", "Spain", "Portugal"))
map_data$EU15 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "United Kingdom", "Ireland", "Denmark", "Greece", "Spain", "Portugal", "Sweden", "Finland", "Austria"))
map_data$EU25 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "United Kingdom", "Ireland", "Denmark", "Greece", "Spain", "Portugal", "Sweden", "Finland", "Austria", "Cyprus", "Czechia", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia"))
map_data$EU27 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "United Kingdom", "Ireland", "Denmark", "Greece", "Spain", "Portugal", "Sweden", "Finland", "Austria", "Cyprus", "Czechia", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia", "Bulgaria", "Romania"))
map_data$EU28 <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "United Kingdom", "Ireland", "Denmark", "Greece", "Spain", "Portugal", "Sweden", "Finland", "Austria", "Cyprus", "Czechia", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia", "Bulgaria", "Romania", "Croatia"))
map_data$EU_current <- as.numeric(map_data$ADMIN_name %in% c("Germany", "France", "Italy", "Belgium", "Netherlands", "Luxembourg", "Ireland", "Denmark", "Greece", "Spain", "Portugal", "Sweden", "Finland", "Austria", "Cyprus", "Czechia", "Estonia", "Hungary", "Latvia", "Lithuania", "Malta", "Poland", "Slovakia", "Slovenia", "Bulgaria", "Romania", "Croatia"))

##################################################
# test data
##################################################

out <- select(map_data, ADMIN_name, geometry, UNIT_code, EU6)
# out <- st_transform(out, crs = "+proj=merc")
out2 <- filter(out, !str_detect(out$UNIT_code, "other") & out$EU6 == 1)
out <- st_crop(out, st_bbox(out2))

ggplot(data = out) + 
  geom_sf(color = "black", fill = "gray80")

geojson_write(out, file = "test.geojson")



