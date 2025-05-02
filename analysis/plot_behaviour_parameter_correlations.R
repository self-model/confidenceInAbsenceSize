# ---- load and preprocess ----

size.parameters <- read.table('../model/modelFitting/bestParameters/size/best_parameters_from_E_size_fit.csv', header=FALSE, sep=',') %>%
  mutate(alpha=V8**2,
         belalpha=V9**2,
         gamma = V5,
         diffalpha = belalpha-alpha)

size.minimal.df <- read.csv('../model/data/E_size_2.csv') %>%
  mutate(present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         size=ifelse(easy,5,3));

size.confidence_effects <- size.minimal.df%>%
  dplyr::group_by(subj_id,present) %>%
  dplyr::summarise(diff = (mean(confidence[correct==1 & easy==1])-mean(confidence[correct==1 & easy==0]))/sd(confidence[correct==1]))%>%
  spread(key=present,value=diff)

corr_data <- bind_cols(size.parameters, size.confidence_effects) %>%
  select(alpha,belalpha,present, absent) 

# Reshape to long format
df_long <- corr_data %>%
  pivot_longer(cols = c(alpha, belalpha), names_to = "parameter", values_to = "param_value") %>%
  pivot_longer(cols = c(present, absent), names_to = "behavior", values_to = "behavior_value") %>%
  mutate(
    parameter = factor(parameter, levels = c("alpha", "belalpha"),
                       labels = c(
                         "alpha" = "alpha~'(true visibility)'",
                         "belalpha" = "bar(alpha)~'(believed visibility)'"
                       )),
    behavior = factor(behavior, levels = c("absent", "present"))
  )


# Plot
ggplot(df_long, aes(x = behavior_value, y = param_value, color = behavior)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_grid(parameter ~ behavior, labeller = labeller(parameter = label_parsed)) +
  scale_color_manual(
    values = c(
      present = "#377eb8",
      absent = "#e41a1c"
    )
  ) +
  labs(
    x = expression(Delta * "confidence: (small-big)/sd"),
    y=''
  ) +
  theme_minimal(base_size = 12) +  # Base font size
  theme(
    legend.position = "none",                    # No legend
    panel.grid = element_blank(),                # Remove gridlines
    panel.border = element_rect(color = "black", fill = NA, size = 0.8),  # Add black frame
    strip.text = element_text(size = 14, face = "bold"),  # Bigger facet labels
    strip.background = element_blank()           # Optional: remove background of strip labels
  )

ggsave('figures/size_confidence_parameter_correlations.png', width=4,height=5,dpi=300)