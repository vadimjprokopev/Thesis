main :: IO ()
main = print . simplify $ deriviate E

data Derivable a = Product (Derivable a) (Derivable a)
                  | Division (Derivable a) (Derivable a)
                  | Sum (Derivable a) (Derivable a)
                  | Sub (Derivable a) (Derivable a)
                  | Power (Derivable a) (Derivable a)
                  | Log (Derivable a)
                  | Cos (Derivable a)
                  | Sin (Derivable a)
                  | Neg (Derivable a)
                  | Const a
                  | E
                  | X
                  deriving (Eq)

deriviate::(Num a) => Derivable a -> Derivable a
deriviate X = Const 1
deriviate E = Const 0
deriviate (Power E a) = Product (Power E a) (deriviate a)
deriviate (Power a b) = Product (deriviate (Product b (Log a))) (Power a b)
deriviate (Log a) = Product (Division (Const 1) a) (deriviate a)
deriviate (Cos a) = Product (Neg (Sin a)) (deriviate a)
deriviate (Sin a) = Product (Cos a) (deriviate a)
deriviate (Neg a) = Neg (deriviate a)
deriviate (Const _) = Const 0
deriviate (Sum a b) = Sum (deriviate a) (deriviate b)
deriviate (Sub a b) = Sub (deriviate a) (deriviate b)
deriviate (Product a b) = Sum (Product (deriviate a) b) (Product a (deriviate b))
deriviate (Division a b) = Division (Sub (Product (deriviate a) b) (Product a (deriviate b))) (Power b (Const 2))

simplify::(Eq a, Num a)=> Derivable a -> Derivable a
simplify (Product a b)
  | Const 0 == simplify a || Const 0 == simplify b = Const 0
  | Const 1 == simplify a = simplify b
  | Const 1 == simplify b = simplify a
  | otherwise = Product (simplify a) (simplify b)
simplify (Sum a b)
  | Const 0 == simplify a = simplify b
  | Const 0 == simplify b = simplify a
  | otherwise = Sum (simplify a) (simplify b)
simplify (Const a) = Const a
simplify (Log a) = Log (simplify a)
simplify (Cos a) = Cos (simplify a)
simplify (Sin a) = Sin (simplify a)
simplify (Neg a) = Neg (simplify a)
simplify E = E
simplify X = X
simplify (Power a b)
  | Const 0 == simplify b = Const 1
  | Const 1 == simplify b = simplify a
  | otherwise = Power (simplify a) (simplify b)
simplify (Sub a b)
  | Const 0 == simplify a = Neg (simplify b)
  | Const 0 == simplify b = simplify a
  | otherwise = Sub (simplify a) (simplify b)
simplify (Division a b)
  | Const 0 == simplify a = Const 0
  | otherwise = Division (simplify a) (simplify b)

instance Show a => Show (Derivable a) where
  show (Sum a b) = "(" ++ show a ++ " + " ++ show b ++ ")"
  show (Sub a b) = "(" ++ show a ++ " - " ++ show b ++ ")"
  show (Product a b) = "(" ++ show a ++ " * " ++ show b ++ ")"
  show (Division a b) = "(" ++ show a ++ ") / (" ++ show b ++ ")"
  show (Power x a) = "(" ++ show x ++ " ^ " ++ show a ++ ")"
  show (Const a) = show a
  show (Log x) = "ln" ++ show x
  show (Cos x) = "cos(" ++ show x ++ ")"
  show (Sin x) = "sin(" ++ show x ++ ")"
  show (Neg x) = "(-" ++ show x ++ ")"
  show E = "e"
  show X = "x"
