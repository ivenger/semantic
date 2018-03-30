{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Data.Abstract.ModuleTable
( ModuleName
, ModuleTable (..)
, moduleTableLookup
, moduleTableMember
, moduleTableInsert
, fromList
) where

import Data.Abstract.Module
import qualified Data.Map as Map
import Data.Semigroup
import Prologue
import GHC.Generics (Generic1)

newtype ModuleTable a = ModuleTable { unModuleTable :: Map.Map ModuleName a }
  deriving (Eq, Foldable, Functor, Generic1, Monoid, Ord, Semigroup, Show, Traversable)

moduleTableLookup :: ModuleName -> ModuleTable a -> Maybe a
moduleTableLookup k = Map.lookup k . unModuleTable

moduleTableMember :: ModuleName -> ModuleTable a -> Bool
moduleTableMember k = Map.member k . unModuleTable

moduleTableInsert :: ModuleName -> a -> ModuleTable a -> ModuleTable a
moduleTableInsert k v = ModuleTable . Map.insert k v . unModuleTable


-- | Construct a 'ModuleTable' from a list of 'Module's.
fromList :: [Module term] -> ModuleTable [Module term]
fromList modules = let m = ModuleTable (Map.fromListWith (<>) (map toEntry modules)) in traceShow m m
  where toEntry m = (modulePath m, [m])
