// Actor0 - The Main Actor which returns the result finally

// Actor1 - ComputeSquares for each number from 1 to N + K - 1

// Actor2 - Calculate the sum of k consequtive sqaure numbers

// Actor3 - Verifies if the number is sqaure or not

// Cores used = (user time + sys time) / real time

// /usr/bin/time ./DOSP 10000000 3 - macOS

// .\measure_time.ps1 -ProgramPath ".\DOSP.exe" -Arguments "arg1 arg2" - Windows powershell

use "collections"
use "math"

class Math

  fun ceil(x: F64): USize =>
    let i = x.trunc().i64()

    if (x > 0) and (x > i.f64()) then
      return (i + 1).usize()
    else
      return i.usize()
    end
  
  fun sqrt(n: USize): F64 =>
    if n == 0 then return 0 end
    if n == 1 then return 1 end

    var left: USize = 1
    var right: USize = n

    while left <= right do
      let mid = left + ((right - left) / 2)
      let mid_squared = mid * mid

      if mid_squared == n then
        return mid.f64()
      elseif mid_squared < n then
        left = mid + 1
      else
        right = mid - 1
      end
    end

    right.f64()


actor Calculator
  let _env: Env
  let _total: USize
  let _chunk_size: USize
  let _summers: Array[Summer]

  new create(env: Env, n: USize, k: USize) =>
    _env = env
    _total = n
    // _chunk_size = Math.ceil(Math.sqrt(_total)) // Adjust this based on your system and problem size
    if n <= 1000 then
      _chunk_size = n
    else 
      _chunk_size = Math.ceil(Math.sqrt(n))
    end

    _summers = Array[Summer]

    let num_summers = ((n - 1) / _chunk_size) + 1
    for i in Range(0, num_summers) do
      _summers.push(Summer(env, k, i * _chunk_size))
    end

    for i in Range(0, num_summers) do
      let start = (i * _chunk_size) + 1
      let endp = if ((i + 1) * _chunk_size) > n then n else (i + 1) * _chunk_size end
      try
        _summers(i)?.calculate_chunk(start, endp)
      end
    end

actor Summer
  let _env: Env
  let _k: USize
  let _offset: USize
  let _queue: Array[U64]
  var _sum: U64
  var _index: USize
  let _checker: PerfectSquareChecker

  new create(env: Env, k: USize, offset: USize) =>
    _env = env
    _k = k
    _offset = offset
    _queue = Array[U64](_k)
    _sum = 0
    _index = 0
    _checker = PerfectSquareChecker(env)

  be calculate_chunk(start: USize, endp: USize) =>
    for i in Range(start, endp + 1) do
      let square = (i.u64() * i.u64())
      add_square(square, start)
    end

  fun ref add_square(square: U64, start: USize) =>
    if _queue.size() == _k then
      try
        _sum = _sum - _queue.shift()?
      end
    end

    _queue.push(square)
    _sum = _sum + square

    if _queue.size() == _k then
      _checker.check_perfect_square(_sum, _offset + _index)
      _index = _index + 1
    end

actor PerfectSquareChecker
  let _env: Env
  let _results: Array[Bool]

  new create(env: Env) =>
    _env = env
    _results = Array[Bool]

  be check_perfect_square(n: U64, index: USize) =>
    let result = is_perfect_square(n)

    if result == true then
      _env.out.print((index + 1).string())
    end

    _results.push(result)

  fun is_perfect_square(n: U64): Bool =>
    if n == 0 then return true end
    if n == 1 then return true end

    var left: U64 = 1
    var right: U64 = n

    while left <= right do
      let mid = left + ((right - left) / 2)
      let mid_squared = mid * mid

      if mid_squared == n then
        return true
      elseif mid_squared < n then
        left = mid + 1
      else
        right = mid - 1
      end
    end

    false

actor Main
  new create(env: Env) =>
    try
      let n = env.args(1)?.usize()?
      let k = env.args(2)?.usize()?
      Calculator(env, n + k, k) // to correct to start at first number of k series till n
    else
      env.out.print("Please provide valid numbers N and K as arguments.")
    end