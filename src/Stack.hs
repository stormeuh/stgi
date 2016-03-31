module Stack (
    Stack,
    push,
    pushMany,
    pop,
    popN,
    peek,
    size
) where



import           Data.Monoid



newtype Stack a = Stack [a]

push :: a -> Stack a -> Stack a
push x (Stack xs) = Stack (x:xs)

pushMany :: [a] -> Stack a -> Stack a
pushMany xs stack = Stack xs <> stack

pop :: Stack a -> Maybe (a, Stack a)
pop (Stack (x:xs)) = Just (x, Stack xs)
pop _ = Nothing

popN :: Int -> Stack a -> Maybe ([a], Stack a)
popN n _ | n < 0 = Nothing
popN 0 s = Just ([], s)
popN n (Stack []) = Nothing
popN n (Stack (x:xs)) = do
    (pops, stack) <- popN (n-1) (Stack xs)
    Just (x : pops, stack)


peek :: Stack a -> Maybe a
peek = fmap fst . pop

size :: Stack a -> Int
size (Stack s) = length s

instance Monoid (Stack a) where
    mempty = Stack []
    Stack xs `mappend` Stack ys = Stack (xs ++ ys)
