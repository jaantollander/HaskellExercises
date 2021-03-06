-- Problem 31
-- Determine whether a given integer number is prime.

-- div 7 2 = 3
-- mod 7 3 = 1
-- mod 7 2 = 1

-- | https://en.wikipedia.org/wiki/Primality_test#Pseudocode
isPrime :: Integral a => a -> Bool
isPrime n
  | n <= 1 = False
  | n <= 3 = True
  | ((mod n 2) == 0) || ((mod n 3) == 0) = False
  | otherwise = primetest n 5
  where
    primetest :: Integral a => a -> a -> Bool
    primetest n i
      | i^2 > n = True
      | ((mod n i) == 0) || ((mod n (i + 2)) == 0) = False
      | otherwise = primetest n (i+6)


-- Problem 32
-- Determine the greatest common divisor of two positive integer numbers. Use
-- Euclid's algorithm.
-- https://en.wikipedia.org/wiki/Euclidean_algorithm
myGCD :: Integral a => a -> a -> a
myGCD a b
  | b == 0 = a
  | otherwise = myGCD b (a `mod` b)


-- Problem 33
-- Determine whether two positive integer numbers are coprime. Two numbers are
-- coprime if their greatest common divisor equals 1.
coprime :: Integral a => a -> a -> Bool
coprime a b = gcd a b == 1


-- Problem 34
-- Calculate Euler's totient function phi(m).
-- Euler's so-called totient function phi(m) is defined as the number of
-- positive integers r (1 <= r < m) that are coprime to m.
totient :: Integral a => a -> a
totient 1 = 1
totient m = sum [value (coprime r m) | r <- [1..(m-1)]]
  where
    value :: Integral a => Bool -> a
    value a
      | a = 1
      | otherwise = 0


-- Problem 35
-- Determine the prime factors of a given positive integer. Construct a flat
-- list containing the prime factors in ascending order.
-- https://en.wikipedia.org/wiki/Integer_factorization
-- https://en.wikipedia.org/wiki/Trial_division
primeFactors :: Integral a => a -> [a]
primeFactors n = primeFactors' n 2
  where
    primeFactors' :: Integral a => a -> a -> [a]
    primeFactors' n f
      | n <= 1 = []
      | (mod n f) == 0 = f:(primeFactors' (div n f) f)
      | otherwise = primeFactors' n (f+1)


-- Problem 36
-- Determine the prime factors of a given positive integer.
-- Construct a list containing the prime factors and their multiplicity.
prime_factors_mult :: Integral a => a -> [(a, Int)]
prime_factors_mult n = collect_all $ primeFactors n
  where
    -- collect [3, 3, 5, 7]
    -- ((3, 2), [5, 7])
    -- collect [5, 7]
    -- ((5, 1), [7])
    -- collect [7]
    -- ((7, 1), [])
    collect :: Integral a => [a] -> ((a, Int), [a])
    collect list@(x:xs) =
      let (h, list') = break (/=x) list
      in ((x, length h), list')

    collect_all :: Integral a => [a] -> [(a, Int)]
    collect_all [] = []
    collect_all list =
      let (element, list') = collect list
      in element:(collect_all list')


-- Problem 37
-- Calculate Euler's totient function phi(m) (improved).
-- See problem 34 for the definition of Euler's totient function. If the list
-- of the prime factors of a number m is known in the form of problem 36 then
-- the function phi(m) can be efficiently calculated as follows: Let ((p1 m1)
-- (p2 m2) (p3 m3) ...) be the list of prime factors (and their multiplicities)
-- of a given number m. Then phi(m) can be calculated with the following
-- formula:
phi :: Int -> Int
phi m = product [(p-1) * p ^ (m-1) | (p, m) <- prime_factors_mult m]


-- Problem 39
-- A list of prime numbers.
-- Given a range of integers by its lower and upper limit, construct a list of
-- all prime numbers in that range.
-- https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
primes :: Integral a => a -> [a]
primes end = primes' end 2 [2..end]
  where
    primes' :: Integral a => a -> a -> [a] -> [a]
    primes' end prime list
      | prime^2 > end = list
      | otherwise =
        let list' = filter (\x -> (mod x prime) /= 0) list
        in prime:(primes' end (head list') list')

primesR :: Integral a => a -> a -> [a]
primesR start end = dropWhile (<start) (primes end)


-- Problem 40
-- Goldbach's conjecture says that every positive even number greater than 2 is
-- the sum of two prime numbers.
-- https://en.wikipedia.org/wiki/Goldbach%27s_conjecture
-- p = primes n
-- candidate prime for pair p2' = n - p1
-- test p2' is prime (p2' ∈ p)
goldbach :: Integral a => a -> [(a, a)]
goldbach n
  |(n > 2) && (even n) = goldbach' n (primes n)
  | otherwise = error "n should even number larger than 2"
  where
    goldbach' :: Integral a => a -> [a] -> [(a, a)]
    goldbach' _ [] = []
    goldbach' n candidates@(p:ps)
      | isPrime p2 = (p, p2):(goldbach' n ps)
      | otherwise  = goldbach' n ps
      where
         p2 = n - p
