# ---- load and preprocess ----

# simulated data 


size.sim.df <- read.csv('../model/modelFitting/simulateDataFromParameters/simulated_data/E_size.csv') %>%
  mutate(present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         size=ifelse(easy,5,3),
         confidence=2*confidence-1);

# minimal human data

size.minimal.df <- read.csv('../model/data/E_size_2.csv') %>%
  mutate(present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         size=ifelse(easy,5,3));

# set as num

size.minimal.df$size <- as.numeric(as.character(size.minimal.df$size))
size.sim.df$size <- as.numeric(as.character(size.sim.df$size))

detection_colors = c('#377eb8', '#e41a1c');
labels = c('Present','Absent')

# why does se not work anymore? here's your own
se <- function(x) {
  sd(x) / sqrt(length(x))
}



### panel A: errors ###
plot_errors_by_size <- function(human_df, sim_df, size_levels, file_name) {
  
  sim_errors <- sim_df %>%
    dplyr::group_by(subj_id,size,present) %>%
    dplyr::summarise(err = 1-mean(correct))
  
  sim_errors_mean <- sim_errors %>%
    dplyr::group_by(size,present) %>%
    dplyr::summarise(se=se(err),
                     err=mean(err))
  
  human_errors <- human_df %>%
    dplyr::group_by(subj_id,size,present) %>%
    dplyr::summarise(err = 1-mean(correct))
  
  human_errors_mean <- human_errors %>%
    dplyr::group_by(size,present) %>%
    dplyr::summarise(se=se(err),
                     err=mean(err))
  
  errors_mean <- merge(human_errors_mean,
                       sim_errors_mean,
                       by=c('size','present'),
                       suffixes = c('.human','.sim'))
  
  errors_mean %>%
    ggplot(aes(x=size,y=err.human,color=present,shape=present, fill=present))+
    scale_shape_manual(values=c(4,16))+
    geom_errorbar(aes(ymin=err.human-se.human,ymax=err.human+se.human),width=0.01)+
    scale_color_manual(values=detection_colors)+
    scale_fill_manual(values=detection_colors)+
    geom_rect(aes(xmin=size-0.2,xmax=size+0.2,ymin=err.sim-se.sim, ymax=err.sim+se.sim),alpha=0.3,color='NA')+
    geom_point(size=2)+
    geom_line()+
    theme_classic() +
    theme(legend.position='none') +
    scale_x_continuous(breaks=size_levels,name='size', trans = 'reverse')+ # reverse so it goes big left hard right (for sort of consistency ig)
    scale_y_continuous(name='error rate', limits = c(0,0.2)) 
  
  ggsave(file_name, width=2.2,height=2.2, dpi=600)
}

plot_errors_by_size(size.minimal.df, size.sim.df, c(3,5), 'figures/size_error_predictions.png')

### panel B: RTs ###

plot_RT_by_size <- function(human_df, sim_df, size_levels, file_name) {
  
  sim_RT <- sim_df %>%
    dplyr::filter(correct==1)%>%
    dplyr::group_by(subj_id,size,present) %>%
    dplyr::summarise(RT = median(rt))
  
  sim_RT_mean <- sim_RT %>%
    dplyr::group_by(size,present) %>%
    dplyr::summarise(se=se(RT),
                     RT=mean(RT))
  
  human_RT <- human_df %>%
    dplyr::filter(correct==1)%>%
    dplyr::group_by(subj_id,size,present) %>%
    dplyr::summarise(RT = median(rt))
  
  human_RT_mean <- human_RT %>%
    dplyr::group_by(size,present) %>%
    dplyr::summarise(se=se(RT),
                     RT=mean(RT))
  
  RT_mean <- merge(human_RT_mean,
                   sim_RT_mean,
                   by=c('size','present'),
                   suffixes = c('.human','.sim'))
  
  bar_scale <- size_levels[2]-size_levels[1];
  
  
  RT_mean %>%
    ggplot(aes(x=size,y=RT.human,color=present,shape=present, fill=present))+
    scale_shape_manual(values=c(4,16))+
    geom_errorbar(aes(ymin=RT.human-se.human,ymax=RT.human+se.human),width=0.01)+
    scale_color_manual(values=detection_colors)+
    scale_fill_manual(values=detection_colors)+
    geom_rect(aes(xmin=size-0.2,xmax=size+0.2,ymin=RT.sim-se.sim, ymax=RT.sim+se.sim),alpha=0.3,color='NA')+
    geom_point(size=2)+
    geom_line()+
    theme_classic() +
    theme(legend.position='none') +
    scale_x_continuous(breaks=size_levels,name='size', trans = 'reverse')+
    scale_y_continuous(name='RT (sec)', limits=c(1.5,2.5)) 
  
  ggsave(file_name, width=2.2,height=2.2, dpi=600)
}

plot_RT_by_size(size.minimal.df, size.sim.df, c(3,5), 'figures/size_RT_predictions.png')

### panel C: confidence ###

plot_confidence_by_size <- function(human_df, sim_df, size_levels, file_name) {
  
  sim_confidence <- sim_df %>%
    dplyr::filter(correct==1)%>%
    dplyr::group_by(subj_id,size,present) %>%
    dplyr::summarise(confidence = mean(confidence))
  
  sim_confidence_mean <- sim_confidence %>%
    dplyr::group_by(size,present) %>%
    dplyr::summarise(se=se(confidence),
                     confidence=mean(confidence))
  
  human_confidence <- human_df %>%
    dplyr::filter(correct==1)%>%
    dplyr::group_by(subj_id,size,present) %>%
    dplyr::summarise(confidence = mean(confidence))
  
  human_confidence_mean <- human_confidence %>%
    dplyr::group_by(size,present) %>%
    dplyr::summarise(se=se(confidence),
                     confidence=mean(confidence))
  
  confidence_mean <- merge(human_confidence_mean,
                           sim_confidence_mean,
                           by=c('size','present'),
                           suffixes = c('.human','.sim'))
  
  
  confidence_mean %>%
    ggplot(aes(x=size,y=confidence.human,color=present,shape=present, fill=present))+
    scale_shape_manual(values=c(4,16))+
    geom_errorbar(aes(ymin=confidence.human-se.human,ymax=confidence.human+se.human),width=0.01)+
    scale_color_manual(values=detection_colors)+
    scale_fill_manual(values=detection_colors)+
    geom_rect(aes(xmin=size-0.2,xmax=size+0.2,ymin=confidence.sim-se.sim, ymax=confidence.sim+se.sim),alpha=0.3,color='NA')+
    geom_point(size=2)+
    geom_line()+
    theme_classic() +
    theme(legend.position='none') +
    scale_x_continuous(breaks=size_levels,name='size', trans = 'reverse')+
    scale_y_continuous(name='confidence', limits=c(0.6,0.9)) 
  
  ggsave(file_name, width=2.2,height=2.2, dpi=600)
}

plot_confidence_by_size(size.minimal.df, size.sim.df, c(3,5), 'figures/size_confidence_predictions.png')