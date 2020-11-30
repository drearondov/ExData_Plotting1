library("tidyverse")
library("lubridate")
library("gridExtra")


# LOADING THE DATA
file <- "data/household_power_consumption.txt"

power_consumption <- read_delim(
    file, ";",
    col_names = TRUE, na = "?",
    col_types = cols(Date = col_date(format("%d/%m/%Y")))
)

two_day <- filter(
    power_consumption,
    Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")
)

two_day <- two_day %>%
    mutate(DateTime = as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"))

# MAKING PLOTS
plot_1 <- ggplot(two_day, aes(Global_active_power)) +
    geom_histogram(binwidth = 0.5, colour = "#A11C17", fill = "#CC241D") +
    ggtitle("Global Active Power") +
    xlab("Global Active Power (kilowatts)") +
    ylab("Frecuency") +
    theme_classic()

# SAVING THE PLOTS
ggsave("plot1.png", plot = plot_1, scale = 5, width = 1.6, height = 1.6, units = "in", dpi = 300)