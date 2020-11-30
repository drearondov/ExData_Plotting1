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
plot_2 <- ggplot(two_day, aes(DateTime, Global_active_power)) +
    geom_line(colour = "#333333", size = 0.1) +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") +
    ylab("Global Active Power (kilowatts)") +
    theme_classic()

colors <- c("Sub_metering_1" = "#282828", "Sub_metering_2" = "#CC241D", "Sub_metering_3" = "#4E898A")

plot_3 <- ggplot(two_day, aes(x = DateTime)) +
    geom_line(aes(y = Sub_metering_1, color = "Sub_metering_1"), size = 0.1) +
    geom_line(aes(y = Sub_metering_2, color = "Sub_metering_2"), size = 0.1) +
    geom_line(aes(y = Sub_metering_3, color = "Sub_metering_3"), size = 0.1) +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") +
    labs(y = "Energy sub metering", color = "Legend") +
    scale_color_manual(values = colors) +
    theme_minimal() +
    theme(
    legend.position = c(.95, .95),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(6, 6, 6, 6)
    )

plot_4 <- ggplot(two_day, aes(DateTime, Voltage)) +
    geom_line(colour = "#333333", size = 0.1) +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") +
    xlab("datetime") +
    ylab("Voltage") +
    theme_classic()

plot_5 <- ggplot(two_day, aes(DateTime, Global_reactive_power)) +
    geom_line(colour = "#333333", size = 0.1) +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") +
    xlab("datetime") +
    ylab("Global_reactive_power") +
    theme_classic()

multi_plot <- grid.arrange(plot_2, plot_4, plot_3, plot_5, nrow = 2)

# SAVING THE PLOTS
ggsave("plot4.png", plot = multi_plot, scale = 5, width = 1.6, height = 1.6, units = "in", dpi = 300)