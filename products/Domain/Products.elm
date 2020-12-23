module Domain.Products exposing
    ( Product
    , ProductCreatedAt(..)
    , ProductId(..)
    , ProductName(..)
    , ProductStock(..)
    , createdAtToString
    , idToString
    , nameToString
    , stockToString
    )


type alias Product =
    { id : ProductId
    , name : ProductName
    , stock : ProductStock
    , createdAt : ProductCreatedAt
    }


type ProductId
    = ProductId String


type ProductName
    = ProductName String


type ProductStock
    = ProductStock Float


type ProductCreatedAt
    = ProductCreatedAt String


idToString : ProductId -> String
idToString (ProductId id) =
    id


nameToString : ProductName -> String
nameToString (ProductName name) =
    name


stockToString : ProductStock -> String
stockToString (ProductStock stock) =
    String.fromFloat stock


createdAtToString : ProductCreatedAt -> String
createdAtToString (ProductCreatedAt createdAt) =
    createdAt
