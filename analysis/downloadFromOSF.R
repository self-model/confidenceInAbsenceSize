# Exp. 1
# raw df
osf_retrieve_file("q8dny") %>%
  osf_download('../experiments/size/data/', conflicts='skip')

# fitted parameters
osf_retrieve_file("5jyr9") %>%
  osf_download('../model/modelFitting/bestParameters/size', conflicts='skip')

# simulated data
osf_retrieve_file("j7y65") %>%
  osf_download('../model/modelFitting/simulateDataFromParameters/simulated_data/', conflicts='skip')

# Exp. 2
# raw df
osf_retrieve_file("fxkuh") %>%
  osf_download('../experiments/prospective/data/', conflicts='skip')