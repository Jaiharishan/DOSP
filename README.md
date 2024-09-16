# Lucas Square Pyramid

## Team members
- Jaiharishan Arunagiri Veerakumar - 62333614
- Vishal Karthikeyan Setti - 47670880

## Optimal Work Unit Size

The optimal work unit size for our implementation is 1000 when n≤1000; otherwise, it is the square root of 𝑛 workers per sub-problem request. We determined this optimal size through trial and error, testing various large and small values of 𝑛.

## Results for lucas 1000000 4

The result of running our program with the inputs `1000000 4` is:

No result

## Performance Metrics

We ran the program using the command:
- For macOS - /usr/bin/time ./DOSP 1000000 4
- For Windows Powershell - .\measure_time.ps1 -ProgramPath ".\DOSP.exe" -Arguments "1000000 4"

The results were:
- Real time: 0.03 seconds
- User time: 0.21 seconds
- Sys time : 0.01 seconds

The ratio of CPU time (User + Sys) to Real time is 0.22 seconds. This ratio indicates that our implementation effectively utilized 7.34 ~ approx 7 cores for parallel computation.

## Largest Problem Solved

The largest problem we managed to solve with our implementation was:

- Inputs: n = 1000000000 2
- Number of workers: sqaure root (1000000000) ~ 31,623

This demonstrates the scalability and efficiency of our pony-based parallel implementation.
