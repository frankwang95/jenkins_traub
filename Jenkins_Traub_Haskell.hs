module Main where


---------- COMPLEX NUMBERS ----------

data Complex = C {re :: Double, img:: Double}
	deriving (Show, Eq)

cAdd :: Complex -> Complex -> Complex
cAdd (C a b) (C c d) = C (a + c) (b + d)

cMult :: Complex -> Complex -> Complex
cMult (C a b) (C c d) = C (a*c - b*d) (a*d + b*c)

cSMult :: Double -> Complex -> Complex
cSMult d (C a b) = C (a*d) (b*d)

cSub :: Complex -> Complex -> Complex 
cSub a b = cAdd a $ cSMult (-1) b

cDiv :: Complex -> Complex -> Complex
cDiv (C a b) (C c d) = C ((a*c + b*d)/(c*c + d*d)) ((b*c - a*d)/(c*c + d*d))

fromReal :: Double -> Complex
fromReal = flip C 0


---------- POLYNOMIALS ----------

type Poly = [Complex] --finite lists only

pAdd :: Poly -> Poly -> Poly
pAdd (x:xs) (y:ys) = cAdd x y : pAdd ys xs
pAdd [] ys = ys
pAdd xs [] = xs

pSMult :: Complex -> Poly -> Poly
pSMult s = map (cMult s)

pEval :: Complex -> Poly -> Complex
pEval x (a:as) = a `cAdd` (x `cMult` pEval x as)
pEval _ [] = C 0 0

pD :: Poly -> Poly
pD (x:xs) = zipWith (cMult.fromReal) [1..] xs


--------- JENKINS-TRAUB ----------

sS :: [Complex]
sS = map fromReal [0..]

h0 :: Poly -> Complex -> Complex
h0 p c = pEval c $ pD p

hSeq :: Poly -> [Complex -> Complex]
hSeq p = zipWith (\x y -> y x)sS $ hAdvF [\s -> h0 p]
	where
		hAdvF xss@(x:xs) = hAdvF $ (\s z -> h0 p z) : xss


--------- TESTING ----------

pT = [C 1 0, C 1 0, C 1 0]


---------- TODO ----------
-- Simplify \x y -> y x defintion in hSeq
-- Insert proper hAdvF function
-- Use correct sS sequence -- What is necessary??