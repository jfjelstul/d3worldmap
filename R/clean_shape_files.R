###########################################################################
# Josh Fjelstul, Ph.D.
# 3dworldmap R package
###########################################################################

# define pipe operator locally
`%>%` <- magrittr::`%>%`

###########################################################################
# medium resolution
###########################################################################

# read in data
low <- sf::read_sf("data/ne_50m_admin_0_map_subunits")

# convert to data frame
low <- as.data.frame(low)

# choose variables
low <- dplyr::select(low, SOVEREIGNT, SOV_A3, SUBUNIT, SU_A3, CONTINENT, REGION_UN, SUBREGION, geometry)

# rename variables
names(low) <- c("state_name", "state_code", "territory_name", "territory_code", "continent", "UN_region", "UN_subregion", "geometry")

# clean region variables
low$continent[low$continent == "Seven seas (open ocean)"] <- "Open Ocean"
low$UN_region[low$UN_region == "Seven seas (open ocean)"] <- "Open Ocean"
low$UN_subregion[low$UN_subregion == "Seven seas (open ocean)"] <- "Open Ocean"

##################################################
# clean SOV codes
##################################################

# codes to keep
# SOL = Somaliland
# KOS = Kosovo
# CYN = Northern Cyprus
# KAS = Kashmir

# codes to fix
low$state_code[low$state_code == "SDS"] <- "SSD" # South Sudan
low$state_code[low$state_code == "SAH"] <- "ESH" # Western Sahara
low$state_code[low$state_code == "US1"] <- "USA"
low$state_code[low$state_code == "GB1"] <- "GBR"
low$state_code[low$state_code == "NZ1"] <- "NZL"
low$state_code[low$state_code == "NL1"] <- "NLD"
low$state_code[low$state_code == "IS1"] <- "ISR"
low$state_code[low$state_code == "FR1"] <- "FRA"
low$state_code[low$state_code == "FI1"] <- "FIN"
low$state_code[low$state_code == "DN1"] <- "DNK"
low$state_code[low$state_code == "CH1"] <- "CHN"
low$state_code[low$state_code == "AU1"] <- "AUS"

##################################################
# clean UNIT codes
##################################################

# Western Sahara (rename)
low$territory_code[low$territory_code == "SAH"] <- "ESH"

# South Sudan (rename)
low$territory_code[low$territory_code == "SDS"] <- "SSD"

# Antarctica (collapse all)
low$territory_code[low$territory_code == "ATB"] <- "ATA" # Antarctica
low$territory_code[low$territory_code == "ATP"] <- "ATA" # Peter I Island
low$territory_code[low$territory_code == "ATS"] <- "ATA" # South Orkney Islands

# Antigua and Barbuda (collapse all)
low$territory_code[low$territory_code == "ACA"] <- "ATG" # Antigua
low$territory_code[low$territory_code == "ACB"] <- "ATG" # Barbuda

# Austrialia (recode)
low$territory_code[low$territory_code == "AUS"] <- "AUS-main" # Australia # changed
low$territory_code[low$territory_code == "AUA"] <- "AUS-main" # Tasmania
low$territory_code[low$territory_code == "HMD"] <- "AUS-other" # Heard Island and McDonald Islands
low$territory_code[low$territory_code == "AUM"] <- "AUS-other" # Macquarie Island
low$territory_code[low$territory_code == "CXR"] <- "AUS-other" # Christmas Island
low$territory_code[low$territory_code == "CCK"] <- "AUS-other" # Cocos Islands
low$territory_code[low$territory_code == "NFK"] <- "AUS-other" # Norfolk Island
low$territory_code[low$territory_code == "ATC"] <- "AUS-other" # Ashmore and Cartier Islands

# Belgium (collapse all)
low$territory_code[low$territory_code == "BFR"] <- "BEL" # Flanders Region
low$territory_code[low$territory_code == "BWR"] <- "BEL" # Walloon Region
low$territory_code[low$territory_code == "BCR"] <- "BEL" # Brussels Capital Region

# Bosnia and Herzegovina (collapse all)
low$territory_code[low$territory_code == "BIS"] <- "BIH" # Republic Srpska
low$territory_code[low$territory_code == "BHF"] <- "BIH" # Bosnia and Herzegovina
low$territory_code[low$territory_code == "BHB"] <- "BIH" # Brcko District

# Chile (recode)
low$territory_code[low$territory_code == "CHL"] <- "CHL-main" # Chile
low$territory_code[low$territory_code == "CHP"] <- "CHL-other" # Easter Island
low$territory_code[low$territory_code == "CHS"] <- "CHL-other" # Isla Sala y Gomez

# China (collapse all)
low$territory_code[low$territory_code == "CHI"] <- "CHN" # China
low$territory_code[low$territory_code == "CHH"] <- "CHN" # Hainan
low$territory_code[low$territory_code == "HKG"] <- "CHN" # Hong Kong
low$territory_code[low$territory_code == "MAC"] <- "CHN" # Macao

# Denmark (recode)
low$territory_code[low$territory_code == "DNK"] <- "DNK-main" # Denmark
low$territory_code[low$territory_code == "DNB"] <- "DNK-main" # Bornholm
low$territory_code[low$territory_code == "GRL"] <- "DNK-other" # Greenland
low$territory_code[low$territory_code == "FRO"] <- "DNK-other" # Faroe Islands

# East Timor (collapse all)
low$territory_code[low$territory_code == "TLX"] <- "TLS" # East Timor
low$territory_code[low$territory_code == "TLP"] <- "TLS" # Pante Makasar

# Ecuador (recode)
low$territory_code[low$territory_code == "ECD"] <- "ECU-main" # Ecuador
low$territory_code[low$territory_code == "ECG"] <- "ECU-other" # Galapagos Islands

# Equatorial Guinea (collapse all)
low$territory_code[low$territory_code == "GNK"] <- "GNQ" # Bioko
low$territory_code[low$territory_code == "GNR"] <- "GNQ" # Rio Muni

# Finland (collapse all)
low$territory_code[low$territory_code == "FIN"] <- "FIN" # Finland
low$territory_code[low$territory_code == "ALD"] <- "FIN" # Aland

# France (recode)
low$territory_code[low$territory_code == "FXX"] <- "FRA-main" # France
low$territory_code[low$territory_code == "FXC"] <- "FRA-main" # Corsica
low$territory_code[low$territory_code == "MYT"] <- "FRA-other" # Mayotte
low$territory_code[low$territory_code == "REU"] <- "FRA-other" # Reunion
low$territory_code[low$territory_code == "MTQ"] <- "FRA-other" # Martinique
low$territory_code[low$territory_code == "GLP"] <- "FRA-other" # Guadeloupe
low$territory_code[low$territory_code == "GUF"] <- "FRA-other" # French Guiana
low$territory_code[low$territory_code == "PYF"] <- "FRA-other" # French Polynesia
low$territory_code[low$territory_code == "NCL"] <- "FRA-other" # New Caledonia
low$territory_code[low$territory_code == "BLM"] <- "FRA-other" # Saint Barthelemy
low$territory_code[low$territory_code == "MAF"] <- "FRA-other" # Saint Martin
low$territory_code[low$territory_code == "SPM"] <- "FRA-other" # Saint Pierre and Miquelon
low$territory_code[low$territory_code == "WLF"] <- "FRA-other" # Wallis and Futuna
low$territory_code[low$territory_code == "ATF"] <- "FRA-other" # French Southern Antarctic Lands

# Georgia (collapse all)
low$territory_code[low$territory_code == "GEG"] <- "GEO" # Georgia

# India (recode)
low$territory_code[low$territory_code == "INX"] <- "IND-main" # India
low$territory_code[low$territory_code == "INN"] <- "IND-other" # Nicobar Islands
low$territory_code[low$territory_code == "INA"] <- "IND-other" # Andaman Islands
low$territory_code[low$territory_code == "INL"] <- "IND-other" # Lakshadweep

# Palestine (collapse all)
low$territory_code[low$territory_code == "GAZ"] <- "PSE" # Gaza
low$territory_code[low$territory_code == "WEB"] <- "PSE" # West Bank

# Italy (collapse all)
low$territory_code[low$territory_code == "ITX"] <- "ITA" # Italy
low$territory_code[low$territory_code == "ITP"] <- "ITA" # Pantelleria
low$territory_code[low$territory_code == "ITY"] <- "ITA" # Sicily
low$territory_code[low$territory_code == "ITD"] <- "ITA" # Sardinia

# Japan (collapse all)
low$territory_code[low$territory_code == "JPN"] <- "JPN" # Japan
low$territory_code[low$territory_code == "JPB"] <- "JPN" # Bonin Islands
low$territory_code[low$territory_code == "JPK"] <- "JPN" # Hokkaido
low$territory_code[low$territory_code == "JPY"] <- "JPN" # Kyushu
low$territory_code[low$territory_code == "JPS"] <- "JPN" # Shikoku
low$territory_code[low$territory_code == "JPH"] <- "JPN" # Honshu
low$territory_code[low$territory_code == "JPO"] <- "JPN" # Nanseishoto
low$territory_code[low$territory_code == "JPI"] <- "JPN" # Izushoto
low$territory_code[low$territory_code == "JPB"] <- "JPN" # Bonin Islands

# Netherlands (recode)
low$territory_code[low$territory_code == "NLD"] <- "NLD-main" # Netherlands
low$territory_code[low$territory_code == "NLY"] <- "NLD-other" # Caribbean Netherlands
low$territory_code[low$territory_code == "SXM"] <- "NLD-other" # Sint Maarten
low$territory_code[low$territory_code == "CUW"] <- "NLD-other" # Curacao
low$territory_code[low$territory_code == "ABW"] <- "NLD-other" # Aruba

# New Zealand (recode)
low$territory_code[low$territory_code == "NZS"] <- "NZL-main" # South Island
low$territory_code[low$territory_code == "NZN"] <- "NZL-main" # North Island
low$territory_code[low$territory_code == "NZA"] <- "NZL-other" # Sub-Antarctic Islands
low$territory_code[low$territory_code == "NZC"] <- "NZL-other" # Chatham Islands
low$territory_code[low$territory_code == "TKL"] <- "NZL-other" # Tokelau
low$territory_code[low$territory_code == "NIU"] <- "NZL-other" # Niue
low$territory_code[low$territory_code == "COK"] <- "NZL-other" # Cook Islands

# Norway (recode)
low$territory_code[low$territory_code == "NOR"] <- "NOR-main" # Norway
low$territory_code[low$territory_code == "NJM"] <- "NOR-other" # Jan Mayen
low$territory_code[low$territory_code == "NSV"] <- "NOR-other" # Svalbard

# Papua New Guinea (collapse all)
low$territory_code[low$territory_code == "PNX"] <- "PNG" # Papua New Guinea
low$territory_code[low$territory_code == "PNB"] <- "PNG" # Bougainville

# Portugal (recode)
low$territory_code[low$territory_code == "PRX"] <- "PRT-main" # Portugal
low$territory_code[low$territory_code == "PMD"] <- "PRT-other" # Madeira
low$territory_code[low$territory_code == "PAZ"] <- "PRT-other" # Azores

# Serbia (collapse all)
low$territory_code[low$territory_code == "SRV"] <- "SRB" # Serbia
low$territory_code[low$territory_code == "SRS"] <- "SRB" # Vojvodina

# Russia (recode)
low$territory_code[low$territory_code == "RUA"] <- "RUS-main" # Russia (Asia)
low$territory_code[low$territory_code == "RUE"] <- "RUS-main" # Russia (Europe)
low$territory_code[low$territory_code == "RUK"] <- "RUS-other" # Kaliningrad
low$territory_code[low$territory_code == "RUC"] <- "RUS-other" # Crimea

# Sao Tome and Principe (collapse all)
low$territory_code[low$territory_code == "STA"] <- "STP" # Principe
low$territory_code[low$territory_code == "STS"] <- "STP" # Sao Tome

# South Africa (recode)
low$territory_code[low$territory_code == "ZAX"] <- "ZAF-main" # South Africa
low$territory_code[low$territory_code == "ZAI"] <- "ZAF-other" # Prince Edward Islands

# South Korea (collapse all)
low$territory_code[low$territory_code == "KOR"] <- "KOR" # South Korea
low$territory_code[low$territory_code == "KOU"] <- "KOR" # Ulleungdo
low$territory_code[low$territory_code == "KOJ"] <- "KOR" # Jejudo

# Spain (recode)
low$territory_code[low$territory_code == "ESX"] <- "ESP-main" # Spain
low$territory_code[low$territory_code == "ESI"] <- "ESP-main" # Balearic Islands
low$territory_code[low$territory_code == "ESC"] <- "ESP-other" # Canary Islands

# Trinidad and Tobago (collapse all)
low$territory_code[low$territory_code == "TTD"] <- "TTO" # Trinidad
low$territory_code[low$territory_code == "TTG"] <- "TTO" # Tobago

# United Kingdom (recode)
low$territory_code[low$territory_code == "WLS"] <- "GBR-main" # Wales
low$territory_code[low$territory_code == "SCT"] <- "GBR-main" # Scotland
low$territory_code[low$territory_code == "NIR"] <- "GBR-main" # Northern Ireland
low$territory_code[low$territory_code == "ENG"] <- "GBR-main" # England
low$territory_code[low$territory_code == "IMN"] <- "GBR-main" # Isle of Man
low$territory_code[low$territory_code == "JEY"] <- "GBR-main" # Jersey
low$territory_code[low$territory_code == "GGY"] <- "GBR-main" # Guernsey
low$territory_code[low$territory_code == "AIA"] <- "GBR-other" # Anguilla
low$territory_code[low$territory_code == "BMU"] <- "GBR-other" # Bermuda
low$territory_code[low$territory_code == "VGB"] <- "GBR-other" # British Virgin Islands
low$territory_code[low$territory_code == "FLK"] <- "GBR-other" # Falkland Islands
low$territory_code[low$territory_code == "MSR"] <- "GBR-other" # Montserrat
low$territory_code[low$territory_code == "PCN"] <- "GBR-other" # Pitcairn Islands
low$territory_code[low$territory_code == "CYM"] <- "GBR-other" # Cayman Islands
low$territory_code[low$territory_code == "SGX"] <- "GBR-other" # South Sandwich Islands
low$territory_code[low$territory_code == "SGG"] <- "GBR-other" # South Georgia
low$territory_code[low$territory_code == "SHN"] <- "GBR-other" # Saint Helena
low$territory_code[low$territory_code == "BAC"] <- "GBR-other" # Ascension
low$territory_code[low$territory_code == "TCA"] <- "GBR-other" # Turks and Caicos Islands
low$territory_code[low$territory_code == "IOD"] <- "GBR-other" # Diego Garcia Naval Support Facility

# Tanzania (collapse all)
low$territory_code[low$territory_code == "TZA"] <- "TZA" # Tanzania
low$territory_code[low$territory_code == "TZZ"] <- "TZA" # Zanzabar

# United States (recode)
low$territory_code[low$territory_code == "USB"] <- "USA-main" # United States
low$territory_code[low$territory_code == "USK"] <- "USA-main" # Alaska
low$territory_code[low$territory_code == "USH"] <- "USA-main" # Hawaii
low$territory_code[low$territory_code == "GUM"] <- "USA-other" # Guam
low$territory_code[low$territory_code == "PRI"] <- "USA-other" # Puerto Rico
low$territory_code[low$territory_code == "ASM"] <- "USA-other" # American Samoa
low$territory_code[low$territory_code == "MNP"] <- "USA-other" # Northern Mariana Islands
low$territory_code[low$territory_code == "VIR"] <- "USA-other" # US Virgin Islands

# Yemen (collapse all)
low$territory_code[low$territory_code == "YEM"] <- "YEM" # Yemen
low$territory_code[low$territory_code == "YES"] <- "YEM" # Suqutra

##################################################
# collapse
##################################################

# collapse by ADMIN code
low <- low %>% 
  dplyr::group_by(territory_code) %>% 
  dplyr::summarize(
    state_name = state_name[1],
    state_code = state_code[1],
    continent = stringr::str_c(unique(continent), collapse = ", "),
    UN_region = stringr::str_c(unique(UN_region), collapse = ", "),
    UN_subregion = stringr::str_c(unique(UN_subregion), collapse = ", "),
    geometry = sf::st_union(geometry)
  )

##################################################
# recode regions
##################################################

# continent
low$continent[low$territory_code == "ATA"] <- "Antarctica"
low$continent[low$territory_code == "ESP-main"] <- "Europe"
low$continent[low$territory_code == "USA-main"] <- "North America"

# UN region
low$UN_region[low$territory_code == "ATA"] <- "Antarctica"
low$UN_region[low$territory_code == "ESP-main"] <- "Europe"
low$UN_region[low$territory_code == "USA-main"] <- "Americas"

# UN subregion
low$UN_subregion[low$territory_code == "ATA"] <- "Antarctica"
low$UN_subregion[low$territory_code == "ESP-main"] <- "Southern Europe"
low$UN_subregion[low$territory_code == "FRA-main"] <- "Western Europe"
low$UN_subregion[low$territory_code == "GBR-main"] <- "Northern Europe"
low$UN_subregion[low$territory_code == "USA-main"] <- "Northern America"

##################################################
# export data
##################################################

# select variables
low <- dplyr::select(low, state_name, state_code, territory_code, continent, UN_region, UN_subregion, geometry)

# export data
write.csv(low, "data/low-resolution-map.csv")

###########################################################################
# high resolution
###########################################################################

# read in data
high <- sf::read_sf("data/ne_10m_admin_0_map_subunits/")

# convert to data frame
high <- as.data.frame(high)

# choose variables
high <- dplyr::select(high, SOVEREIGNT, SOV_A3, SUBUNIT, SU_A3, CONTINENT, REGION_UN, SUBREGION, geometry)

# rename variables
names(high) <- c("state_name", "state_code", "territory_name", "territory_code", "continent", "UN_region", "UN_subregion", "geometry")

# clean region variables
high$continent[high$continent == "Seven seas (open ocean)"] <- "Open Ocean"
high$UN_region[high$UN_region == "Seven seas (open ocean)"] <- "Open Ocean"
high$UN_subregion[high$UN_subregion == "Seven seas (open ocean)"] <- "Open Ocean"

##################################################
# clean SOV codes
##################################################

# codes to keep
# SOL = Somaliland
# KOS = Kosovo
# CYN = Northern Cyprus
# KAS = Kashmir
# CNM = United Nations Buffer Zone in Cyprus
# PGA = Spratly Islands
# BJN = Bajo Nuevo Bank
# SER = Serranilla Bank
# SCR = Scarborough Reef

# codes to fix
high$state_code[high$state_code == "SDS"] <- "SSD" # South Sudan
high$state_code[high$state_code == "SAH"] <- "ESH" # Western Sahara
high$state_code[high$state_code == "US1"] <- "USA"
high$state_code[high$state_code == "GB1"] <- "GBR"
high$state_code[high$state_code == "NZ1"] <- "NZL"
high$state_code[high$state_code == "NL1"] <- "NLD"
high$state_code[high$state_code == "IS1"] <- "ISR"
high$state_code[high$state_code == "FR1"] <- "FRA"
high$state_code[high$state_code == "FI1"] <- "FIN"
high$state_code[high$state_code == "DN1"] <- "DNK"
high$state_code[high$state_code == "CH1"] <- "CHN"
high$state_code[high$state_code == "AU1"] <- "AUS"

##################################################
# clean UNIT codes
##################################################

# Western Sahara (rename)
high$territory_code[high$territory_code == "SAH"] <- "ESH"

# South Sudan (rename)
high$territory_code[high$territory_code == "SDS"] <- "SSD"

# Antarctica (collapse all)
high$territory_code[high$territory_code == "ATB"] <- "ATA" # Antarctica
high$territory_code[high$territory_code == "ATP"] <- "ATA" # Peter I Island
high$territory_code[high$territory_code == "ATS"] <- "ATA" # South Orkney Islands

# Antigua and Barbuda (collapse all)
high$territory_code[high$territory_code == "ACA"] <- "ATG" # Antigua
high$territory_code[high$territory_code == "ACB"] <- "ATG" # Barbuda

# Austrialia (recode)
high$territory_code[high$territory_code == "AUZ"] <- "AUS-main" # Australia
high$territory_code[high$territory_code == "AUA"] <- "AUS-main" # Tasmania
high$territory_code[high$territory_code == "HMD"] <- "AUS-other" # Heard Island and McDonald Islands
high$territory_code[high$territory_code == "AUM"] <- "AUS-other" # Macquarie Island
high$territory_code[high$territory_code == "CXR"] <- "AUS-other" # Christmas Island
high$territory_code[high$territory_code == "CCK"] <- "AUS-other" # Cocos Islands
high$territory_code[high$territory_code == "NFK"] <- "AUS-other" # Norfolk Island
high$territory_code[high$territory_code == "ATC"] <- "AUS-other" # Ashmore and Cartier Islands
high$territory_code[high$territory_code == "CSI"] <- "AUS-other" # Coral Sea Islands

# Belgium (collapse all)
high$territory_code[high$territory_code == "BFR"] <- "BEL" # Flanders Region
high$territory_code[high$territory_code == "BWR"] <- "BEL" # Walloon Region
high$territory_code[high$territory_code == "BCR"] <- "BEL" # Brussels Capital Region

# Bosnia and Herzegovina (collapse all)
high$territory_code[high$territory_code == "BIS"] <- "BIH" # Republic Srpska
high$territory_code[high$territory_code == "BHF"] <- "BIH" # Bosnia and Herzegovina
high$territory_code[high$territory_code == "BHB"] <- "BIH" # Brcko District

# Chile (recode)
high$territory_code[high$territory_code == "CHX"] <- "CHL-main" # Chile
high$territory_code[high$territory_code == "CHP"] <- "CHL-other" # Easter Island
high$territory_code[high$territory_code == "CHS"] <- "CHL-other" # Isla Sala y Gomez

# China (collapse all)
high$territory_code[high$territory_code == "CHI"] <- "CHN" # China
high$territory_code[high$territory_code == "CHH"] <- "CHN" # Hainan
high$territory_code[high$territory_code == "HKG"] <- "CHN" # Hong Kong
high$territory_code[high$territory_code == "MAC"] <- "CHN" # Macao
high$territory_code[high$territory_code == "PFA"] <- "CHN" # Paracel Islands

# Cuba (collapse all)
high$territory_code[high$territory_code == "CUB"] <- "CUB" # Cuba
high$territory_code[high$territory_code == "USG"] <- "CUB" # US Naval Base

# Denmark (recode)
high$territory_code[high$territory_code == "DNK"] <- "DNK-main" # Denmark
high$territory_code[high$territory_code == "DNB"] <- "DNK-main" # Bornholm
high$territory_code[high$territory_code == "GRL"] <- "DNK-other" # Greenland
high$territory_code[high$territory_code == "FRO"] <- "DNK-other" # Faroe Islands

# East Timor (collapse all)
high$territory_code[high$territory_code == "TLX"] <- "TLS" # East Timor
high$territory_code[high$territory_code == "TLP"] <- "TLS" # Pante Makasar

# Ecuador (recode)
high$territory_code[high$territory_code == "ECD"] <- "ECU-main" # Ecuador
high$territory_code[high$territory_code == "ECG"] <- "ECU-other" # Galapagos Islands

# Equatorial Guinea (collapse all)
high$territory_code[high$territory_code == "GNK"] <- "GNQ" # Bioko
high$territory_code[high$territory_code == "GNR"] <- "GNQ" # Rio Muni
high$territory_code[high$territory_code == "GNA"] <- "GNQ" # Annobon

# Finland (collapse all)
high$territory_code[high$territory_code == "FIN"] <- "FIN" # Finland
high$territory_code[high$territory_code == "ALD"] <- "FIN" # Aland

# France (recode)
high$territory_code[high$territory_code == "FXX"] <- "FRA-main" # France
high$territory_code[high$territory_code == "FXC"] <- "FRA-main" # Corsica
high$territory_code[high$territory_code == "MYT"] <- "FRA-other" # Mayotte
high$territory_code[high$territory_code == "REU"] <- "FRA-other" # Reunion
high$territory_code[high$territory_code == "MTQ"] <- "FRA-other" # Martinique
high$territory_code[high$territory_code == "GLP"] <- "FRA-other" # Guadeloupe
high$territory_code[high$territory_code == "GUF"] <- "FRA-other" # French Guiana
high$territory_code[high$territory_code == "CLP"] <- "FRA-other" # Clipperton Island
high$territory_code[high$territory_code == "PYF"] <- "FRA-other" # French Polynesia
high$territory_code[high$territory_code == "NCL"] <- "FRA-other" # New Caledonia
high$territory_code[high$territory_code == "BLM"] <- "FRA-other" # Saint Barthelemy
high$territory_code[high$territory_code == "MAF"] <- "FRA-other" # Saint Martin
high$territory_code[high$territory_code == "SPM"] <- "FRA-other" # Saint Pierre and Miquelon
high$territory_code[high$territory_code == "WLF"] <- "FRA-other" # Wallis and Futuna
high$territory_code[high$territory_code == "JUI"] <- "FRA-other" # Juan De Nova Island
high$territory_code[high$territory_code == "FSA"] <- "FRA-other" # French Southern Antarctic Lands
high$territory_code[high$territory_code == "EUI"] <- "FRA-other" # Europa Island
high$territory_code[high$territory_code == "BSI"] <- "FRA-other" # Bassas da India
high$territory_code[high$territory_code == "TEI"] <- "FRA-other" # Tromelin Island
high$territory_code[high$territory_code == "GOI"] <- "FRA-other" # Glorioso Islands

# Georgia (collapse all)
high$territory_code[high$territory_code == "GEG"] <- "GEO" # Georgia
high$territory_code[high$territory_code == "GEA"] <- "GEO" # Ajaria

# India (recode)
high$territory_code[high$territory_code == "INX"] <- "IND-main" # India
high$territory_code[high$territory_code == "INN"] <- "IND-other" # Nicobar Islands
high$territory_code[high$territory_code == "INA"] <- "IND-other" # Andaman Islands
high$territory_code[high$territory_code == "INL"] <- "IND-other" # Lakshadweep

# Iraq (collapse all)
high$territory_code[high$territory_code == "IRR"] <- "IRQ" # Iraq
high$territory_code[high$territory_code == "IRK"] <- "IRQ" # Iraqi Kurdistan

# Palestine (collapse all)
high$territory_code[high$territory_code == "GAZ"] <- "PSE" # Gaza
high$territory_code[high$territory_code == "WEB"] <- "PSE" # West Bank

# Italy (collapse all)
high$territory_code[high$territory_code == "ITX"] <- "ITA" # Italy
high$territory_code[high$territory_code == "ITP"] <- "ITA" # Pantelleria
high$territory_code[high$territory_code == "ITY"] <- "ITA" # Sicily
high$territory_code[high$territory_code == "ITD"] <- "ITA" # Sardinia
high$territory_code[high$territory_code == "ITI"] <- "ITA" # Isole Pelagie

# Japan (collapse all)
high$territory_code[high$territory_code == "JPX"] <- "JPN" # Japan
high$territory_code[high$territory_code == "JPB"] <- "JPN" # Bonin Islands
high$territory_code[high$territory_code == "JPK"] <- "JPN" # Hokkaido
high$territory_code[high$territory_code == "JPY"] <- "JPN" # Kyushu
high$territory_code[high$territory_code == "JPS"] <- "JPN" # Shikoku
high$territory_code[high$territory_code == "JPH"] <- "JPN" # Honshu
high$territory_code[high$territory_code == "JPO"] <- "JPN" # Nanseishoto
high$territory_code[high$territory_code == "JPI"] <- "JPN" # Izushoto
high$territory_code[high$territory_code == "JPV"] <- "JPN" # Volcano Islands
high$territory_code[high$territory_code == "JPB"] <- "JPN" # Bonin Islands

# Kazakhstan (collapse all)
high$territory_code[high$territory_code == "KAZ"] <- "KAZ" # Kazakhstan
high$territory_code[high$territory_code == "KAB"] <- "KAZ" # Baykonur Cosmodrome

# Netherlands (recode)
high$territory_code[high$territory_code == "NLX"] <- "NLD-main" # Netherlands
high$territory_code[high$territory_code == "NLY"] <- "NLD-other" # Caribbean Netherlands
high$territory_code[high$territory_code == "SXM"] <- "NLD-other" # Sint Maarten
high$territory_code[high$territory_code == "CUW"] <- "NLD-other" # Curacao
high$territory_code[high$territory_code == "ABW"] <- "NLD-other" # Aruba

# New Zealand (recode)
high$territory_code[high$territory_code == "NZS"] <- "NZL-main" # South Island
high$territory_code[high$territory_code == "NZN"] <- "NZL-main" # North Island
high$territory_code[high$territory_code == "NZA"] <- "NZL-other" # Sub-Antarctic Islands
high$territory_code[high$territory_code == "NZC"] <- "NZL-other" # Chatham Islands
high$territory_code[high$territory_code == "TKL"] <- "NZL-other" # Tokelau
high$territory_code[high$territory_code == "NIU"] <- "NZL-other" # Niue
high$territory_code[high$territory_code == "COK"] <- "NZL-other" # Cook Islands
high$territory_code[high$territory_code == "NZK"] <- "NZL-other" # Kermadec Island

# North Korea (collapse all)
high$territory_code[high$territory_code == "PRK"] <- "PRK" # North Korea
high$territory_code[high$territory_code == "KNZ"] <- "PRK" # DMZ

# Norway (recode)
high$territory_code[high$territory_code == "NOW"] <- "NOR-main" # Norway
high$territory_code[high$territory_code == "NJM"] <- "NOR-other" # Jan Mayen
high$territory_code[high$territory_code == "NSV"] <- "NOR-other" # Svalbard
high$territory_code[high$territory_code == "BVT"] <- "NOR-other" # Bouvet Island

# Papua New Guinea (collapse all)
high$territory_code[high$territory_code == "PNX"] <- "PNG" # Papua New Guinea
high$territory_code[high$territory_code == "PNB"] <- "PNG" # Bougainville

# Portugal (recode)
high$territory_code[high$territory_code == "PRX"] <- "PRT-main" # Portugal
high$territory_code[high$territory_code == "PMD"] <- "PRT-other" # Madeira
high$territory_code[high$territory_code == "PAZ"] <- "PRT-other" # Azores

# Serbia (collapse all)
high$territory_code[high$territory_code == "SRV"] <- "SRB" # Serbia
high$territory_code[high$territory_code == "SRS"] <- "SRB" # Vojvodina

# Russia (recode)
high$territory_code[high$territory_code == "RUA"] <- "RUS-main" # Russia (Asia)
high$territory_code[high$territory_code == "RUE"] <- "RUS-main" # Russia (Europe)
high$territory_code[high$territory_code == "RUK"] <- "RUS-other" # Kaliningrad
high$territory_code[high$territory_code == "RUC"] <- "RUS-other" # Crimea

# Sao Tome and Principe (collapse all)
high$territory_code[high$territory_code == "STA"] <- "STP" # Principe
high$territory_code[high$territory_code == "STS"] <- "STP" # Sao Tome

# Somalia
high$territory_code[high$territory_code == "SOX"] <- "SOM" # Somalia
high$territory_code[high$territory_code == "SOP"] <- "SOM" # Puntland

# South Africa (recode)
high$territory_code[high$territory_code == "ZAX"] <- "ZAF-main" # South Africa
high$territory_code[high$territory_code == "ZAI"] <- "ZAF-other" # Prince Edward Islands

# South Korea (collapse all)
high$territory_code[high$territory_code == "KOX"] <- "KOR" # South Korea
high$territory_code[high$territory_code == "KXI"] <- "KOR" # South Korea (Islands)
high$territory_code[high$territory_code == "KNX"] <- "KOR" # DMZ
high$territory_code[high$territory_code == "KOU"] <- "KOR" # Ulleungdo
high$territory_code[high$territory_code == "KOJ"] <- "KOR" # Jejudo
high$territory_code[high$territory_code == "KOB"] <- "KOR" # Baengnyeongdo
high$territory_code[high$territory_code == "KOD"] <- "KOR" # Dokdo

# Spain (recode)
high$territory_code[high$territory_code == "ESX"] <- "ESP-main" # Spain
high$territory_code[high$territory_code == "ESI"] <- "ESP-main" # Balearic Islands
high$territory_code[high$territory_code == "SEM"] <- "ESP-main" # Melilla
high$territory_code[high$territory_code == "SEC"] <- "ESP-main" # Ceuta
high$territory_code[high$territory_code == "ESC"] <- "ESP-other" # Canary Islands

# Syria (collapse all)
high$territory_code[high$territory_code == "SYX"] <- "SYR" # Syria
high$territory_code[high$territory_code == "SYU"] <- "SYR" # UNDOF

# Trinidad and Tobago (collapse all)
high$territory_code[high$territory_code == "TTD"] <- "TTO" # Trinidad
high$territory_code[high$territory_code == "TTG"] <- "TTO" # Tobago

# United Kingdom (recode)
high$territory_code[high$territory_code == "WLS"] <- "GBR-main" # Wales
high$territory_code[high$territory_code == "SCT"] <- "GBR-main" # Scotland
high$territory_code[high$territory_code == "NIR"] <- "GBR-main" # Northern Ireland
high$territory_code[high$territory_code == "ENG"] <- "GBR-main" # England
high$territory_code[high$territory_code == "IMN"] <- "GBR-main" # Isle of Man
high$territory_code[high$territory_code == "JEY"] <- "GBR-main" # Jersey
high$territory_code[high$territory_code == "GGG"] <- "GBR-main" # Guernsey (Guernsey)
high$territory_code[high$territory_code == "GGS"] <- "GBR-main" # Sark (Guernsey)
high$territory_code[high$territory_code == "GGA"] <- "GBR-main" # Alderney (Guernsey)
high$territory_code[high$territory_code == "GGH"] <- "GBR-main" # Herm (Guernsey)
high$territory_code[high$territory_code == "GIB"] <- "GBR-other" # Gibralter
high$territory_code[high$territory_code == "AIA"] <- "GBR-other" # Anguilla
high$territory_code[high$territory_code == "BMU"] <- "GBR-other" # Bermuda
high$territory_code[high$territory_code == "VGB"] <- "GBR-other" # British Virgin Islands
high$territory_code[high$territory_code == "FLK"] <- "GBR-other" # Falkland Islands
high$territory_code[high$territory_code == "MSR"] <- "GBR-other" # Montserrat
high$territory_code[high$territory_code == "PCN"] <- "GBR-other" # Pitcairn Islands
high$territory_code[high$territory_code == "CYM"] <- "GBR-other" # Cayman Islands
high$territory_code[high$territory_code == "SGX"] <- "GBR-other" # South Sandwich Islands
high$territory_code[high$territory_code == "SGG"] <- "GBR-other" # South Georgia
high$territory_code[high$territory_code == "SHS"] <- "GBR-other" # Saint Helena
high$territory_code[high$territory_code == "BAC"] <- "GBR-other" # Ascension
high$territory_code[high$territory_code == "SHT"] <- "GBR-other" # Tristan da Cunha
high$territory_code[high$territory_code == "TCA"] <- "GBR-other" # Turks and Caicos Islands
high$territory_code[high$territory_code == "IOT"] <- "GBR-other" # British Indian Ocean Terriotry
high$territory_code[high$territory_code == "WSB"] <- "GBR-other" # Akrotiri Sovereign Base Area
high$territory_code[high$territory_code == "IOD"] <- "GBR-other" # Diego Garcia Naval Support Facility
high$territory_code[high$territory_code == "ESB"] <- "GBR-other" # Dkekelia Sovereign Base Area

# Tanzania (collapse all)
high$territory_code[high$territory_code == "TZA"] <- "TZA" # Tanzania
high$territory_code[high$territory_code == "TZZ"] <- "TZA" # Zanzabar

# United States (recode)
high$territory_code[high$territory_code == "USB"] <- "USA-main" # United States
high$territory_code[high$territory_code == "USK"] <- "USA-main" # Alaska
high$territory_code[high$territory_code == "USH"] <- "USA-main" # Hawaii
high$territory_code[high$territory_code == "GUM"] <- "USA-other" # Guam
high$territory_code[high$territory_code == "PRI"] <- "USA-other" # Puerto Rico
high$territory_code[high$territory_code == "ASM"] <- "USA-other" # American Samoa
high$territory_code[high$territory_code == "MNP"] <- "USA-other" # Northern Mariana Islands
high$territory_code[high$territory_code == "VIR"] <- "USA-other" # US Virgin Islands
high$territory_code[high$territory_code == "JQI"] <- "USA-other" # Johnston Atoll (Minor Outlying Islands)
high$territory_code[high$territory_code == "DQI"] <- "USA-other" # Jarvis Island (Minor Outlying Islands)
high$territory_code[high$territory_code == "FQI"] <- "USA-other" # Baker Island  (Minor Outlying Islands)
high$territory_code[high$territory_code == "HQI"] <- "USA-other" # Howland Island (Minor Outlying Islands)
high$territory_code[high$territory_code == "WQI"] <- "USA-other" # Wake Atoll (Minor Outlying Islands)
high$territory_code[high$territory_code == "MQI"] <- "USA-other" # Midway Islands (Minor Outlying Islands)
high$territory_code[high$territory_code == "BQI"] <- "USA-other" # Navassa Island (Minor Outlying Islands)
high$territory_code[high$territory_code == "LQI"] <- "USA-other" # Palmyra Atoll (Minor Outlying Islands)
high$territory_code[high$territory_code == "KQI"] <- "USA-other" # Kingdman Reef (Minor Outlying Islands)

# Yemen (collapse all)
high$territory_code[high$territory_code == "YEM"] <- "YEM" # Yemen
high$territory_code[high$territory_code == "YES"] <- "YEM" # Suqutra

##################################################
# collapse
##################################################

# collapse by ADMIN code
high <- high %>% 
  dplyr::group_by(territory_code) %>% 
  dplyr::summarize(
    state_name = state_name[1],
    state_code = state_code[1],
    continent = stringr::str_c(unique(continent), collapse = ", "),
    UN_region = stringr::str_c(unique(UN_region), collapse = ", "),
    UN_subregion = stringr::str_c(unique(UN_subregion), collapse = ", "),
    geometry = sf::st_union(geometry)
  )

##################################################
# recode regions
##################################################

# continent
high$continent[high$territory_code == "ATA"] <- "Antarctica"
high$continent[high$territory_code == "ESP-main"] <- "Europe"
high$continent[high$territory_code == "USA-main"] <- "North America"

# UN region
high$UN_region[high$territory_code == "ATA"] <- "Antarctica"
high$UN_region[high$territory_code == "ESP-main"] <- "Europe"
high$UN_region[high$territory_code == "USA-main"] <- "Americas"

# UN subregion
high$UN_subregion[high$territory_code == "ATA"] <- "Antarctica"
high$UN_subregion[high$territory_code == "ESP-main"] <- "Southern Europe"
high$UN_subregion[high$territory_code == "FRA-main"] <- "Western Europe"
high$UN_subregion[high$territory_code == "GBR-main"] <- "Northern Europe"
high$UN_subregion[high$territory_code == "USA-main"] <- "Northern America"

##################################################
# export data
##################################################

# select variables
high <- dplyr::select(high, state_name, state_code, territory_code, continent, UN_region, UN_subregion, geometry)

# export data
write.csv(high, "data/high-resolution-map.csv")

###########################################################################
# end R script
###########################################################################
