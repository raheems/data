
# Sun Sep  9 10:09:02 2018 ------------------------------

library(tidyverse)

fpath = "/Users/enayetraheem/Dropbox/MyBooks/AppliedStatDataScience/"
fname = "data-resource_2018_08_06_Detail Information of Teacher_DU_Working.xlsx"

f = paste(fpath, fname, sep = "")
f

df <- readxl::read_excel(f, sheet = 1, range = "B8:Y30")
dim(df)

for (i in 2:133){
  new_df = readxl::read_excel(f, sheet = i, range = "B8:Y30")
  df = rbind(df, new_df)
}

dim(df)


# Remove all columns with NA
df <- df %>%
  discard(~all(is.na(.x))) %>%
  map_df(~.x)

# Drop X__6
df <- df %>% select(-X__6)

# Remove all rows with all NAs
df <- df[!apply(is.na(df), 1, all),]

# Cleaning the data
names(df)

df <- df %>%
  select(-`Name of University`, -`Working Status`) %>%
  mutate(
    year = 2017
  ) %>%
  rename(
    id = Sl.,
    Faculty_Name = `Teacher Name`,
    Faculty = `Faculty/ School`,
    Appointment = `Appointment Type`,
    Highest_Degree = `Higher Education`,
    Year = year
  ) %>%
  mutate(
    Faculty = str_trim(str_replace(Faculty, "Faculty of", "")),
    Faculty = str_trim(str_replace(Faculty, "&", "and")),
    Department = str_trim(str_replace(Department, "Department of", "")),
    is_phd = ifelse(Highest_Degree == "PhD", "Yes",
                    ifelse(Highest_Degree == "Not Available", NA, "No")),
    # reorder factor variable
    is_phd = factor(is_phd, levels = c("Yes", "No")),

    # Reorder Designation variable
    Designation = fct_relevel(Designation, "Professor", "Associate Professor",
                              "Assistant Professor", "Lecturer", "Others")

  )

dim(df)
names(df)

# Save the file
write_excel_csv(df, "du_faculty_2017.csv")

#
