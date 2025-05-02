

## Data

Data from Exp. 1, including raw behavioural data, parameter estimates and simulated data from the model, is available [on OSF](https://osf.io/ma6ux/files/osfstorage).

Raw behavioural data from Exp. 2 is also available [on OSF](https://osf.io/fhn7v/files/osfstorage).

These files can be downloaded into their right places by running [`downloadFromOSF.R`](https://github.com/self-model/confidenceInAbsenceSize/blob/main/analysis/downloadFromOSF.R) from the analysis subdirectory.

## Analysis Scripts
A fully reproducible data-to-results-section code (in R and Rmarkdown), is available in the ['analysis'](https://github.com/self-model/confidenceInAbsenceSize/blob/main/analysis/results.Rmd) subdirectory. 

## Experiment demos

You can try Experiment 1 (size) by clicking [here](https://self-model.github.io/confidenceInAbsenceSize/experiments/demos/exp1)

You can try Experiment 2 (prospective confidence) by clicking [here](https://self-model.github.io/confidenceInAbsenceSize/experiments/demos/exp2)

## Pre-registration and pre-registration time-locking 🕝🔒

OSF pre-registrations are available for [Exp. 1](https://osf.io/r62nm) and [Exp. 2](https://osf.io/z652f).

To ensure preregistration time-locking (in other words, that preregistration preceded data collection), we employed [randomization-based preregistration](https://medium.com/@mazormatan/cryptographic-preregistration-from-newton-to-fmri-df0968377bb2). We used the SHA256 cryptographic hash function to translate our preregistered protocol folder (including the pre-registration document) to a string of 256 bits. These bits were then combined with the unique identifiers of single subjects, and the resulting string was used as seed for initializing the Mersenne Twister pseudorandom number generator prior to determining all random aspects of the experiment, including the order of trials, occluder positions, and random noise in the stimulus itself. This way, experimental randomization was causally dependent on, and therefore could not have been determined prior to, the specific contents of our preregistration document ([Mazor, Mazor & Mukamel, 2019](https://doi.org/10.1111/ejn.14278)).

### Exp. 1
[protocol folder](https://github.com/self-model/confidenceInAbsenceSize/blob/main/experiments/size/protocolFolder.zip)

protocol sum: 5c3ed4305256f8e945a9efec12fe5e6c8a7c1576607c7c32061a0c5a50d82d60

[relevant pre-registration lines of code](https://github.com/self-model/confidenceInAbsenceSize/blob/183abbcbf5b29e2ef29ea3359c7a9fa2b796db7f/experiments/size/webpage/index-size.html#L558-L570)

### Exp. 2
[protocol folder](https://github.com/self-model/confidenceInAbsenceSize/blob/183abbcbf5b29e2ef29ea3359c7a9fa2b796db7f/experiments/prospective/protocol_folder.zip)

protocol sum: 7463799c7fd4953c82d6143176f825985aa27ad742e98737d0100adfb758b1d8

[relevant pre-registration lines of code](https://github.com/self-model/confidenceInAbsenceSize/blob/183abbcbf5b29e2ef29ea3359c7a9fa2b796db7f/experiments/prospective/webpage/index-size.html#L655-L666)



