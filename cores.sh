#!/bin/bash

#the output from the usr/bin/time command looks like this:

# Run the program and capture the output of /usr/bin/time
output=$(/usr/bin/time ./DOSP 1000000 4)
#output = "        0.22 real         1.65 user         0.03 sys"
echo $output

# Use awk to extract the decimal values and store them in variables
real=$(echo "$output" | awk '{print $1}')
user=$(echo "$output" | awk '{print $3}')
sys=$(echo "$output" | awk '{print $5}')

# Calculate the number of cores using the formula (user + sys) / real
cores=$(awk "BEGIN {print ($user + $sys) / $real}")

# Print the values to verify
echo "Real: $real"
echo "User: $user"
echo "Sys: $sys"
echo "Cores: $cores"