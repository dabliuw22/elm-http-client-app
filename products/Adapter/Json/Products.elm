module Adapter.Json.Products exposing
    ( collection
    , collectionEncoder
    , decoder
    , encoder
    )

import Domain.Products
    exposing
        ( Product
        , ProductCreatedAt(..)
        , ProductId(..)
        , ProductName(..)
        , ProductStock(..)
        )
import Json.Decode
    exposing
        ( Decoder
        , float
        , list
        , map
        , string
        , succeed
        )
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode


decoder : Decoder Product
decoder =
    succeed Product
        |> required "product_id" idDecoder
        |> required "product_name" nameDecoder
        |> required "product_stock" stockDecoder
        |> required "product_created_at" createdAtDecoder


collection : Decoder (List Product)
collection =
    list decoder


idDecoder : Decoder ProductId
idDecoder =
    map ProductId string


nameDecoder : Decoder ProductName
nameDecoder =
    map ProductName string


stockDecoder : Decoder ProductStock
stockDecoder =
    map ProductStock float


createdAtDecoder : Decoder ProductCreatedAt
createdAtDecoder =
    map ProductCreatedAt string


collectionEncoder : List Product -> Encode.Value
collectionEncoder products =
    Encode.list encoderAll products


idEncoder : ProductId -> Encode.Value
idEncoder (ProductId id) =
    Encode.string id


createdAtEncoder : ProductCreatedAt -> Encode.Value
createdAtEncoder (ProductCreatedAt createdAt) =
    Encode.string createdAt


encoderAll : Product -> Encode.Value
encoderAll product =
    Encode.object
        [ ( "product_id", idEncoder product.id )
        , ( "product_name", nameEncoder product.name )
        , ( "product_stock", stockEncoder product.stock )
        , ( "product_created_at", createdAtEncoder product.createdAt )
        ]


encoder : ( ProductName, ProductStock ) -> Encode.Value
encoder ( name, stock ) =
    Encode.object
        [ ( "product_name", nameEncoder name )
        , ( "product_stock", stockEncoder stock )
        ]


nameEncoder : ProductName -> Encode.Value
nameEncoder (ProductName name) =
    Encode.string name


stockEncoder : ProductStock -> Encode.Value
stockEncoder (ProductStock stock) =
    Encode.float stock
