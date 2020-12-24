module Adapter.Http.ListProducts exposing (Model, Msg(..), init, update, view)

import Adapter.Http.Api exposing (products)
import Adapter.Json.Products exposing (collection, collectionEncoder)
import Adapter.Storage.ProductsPort exposing (storeProducts)
import Domain.Products
    exposing
        ( Product
        , createdAtToString
        , idToString
        , nameToString
        , stockToString
        )
import Html
    exposing
        ( Html
        , a
        , br
        , button
        , div
        , table
        , text
        , th
        , tr
        )
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Json.Encode as Encode
import RemoteData exposing (RemoteData, WebData)


type alias Products =
    List Product


type alias Model =
    { products : WebData Products
    }


type Msg
    = FetchProducts
    | ProductsReceived (WebData Products)


init : String -> ( Model, Cmd Msg )
init api =
    ( { products = RemoteData.NotAsked }, fetchProducts api )


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick FetchProducts ] [ text "Get Products" ]
            , viewProducts model
            ]
        , br [] []
        , div []
            [ a [ href "/products/new" ] [ text "New Product" ] ]
        ]


update : String -> Msg -> Model -> ( Model, Cmd Msg )
update api msg model =
    case msg of
        FetchProducts ->
            ( { model | products = RemoteData.Loading }, fetchProducts api )

        ProductsReceived response ->
            ( { model | products = response }, saveProducts response )


fetchProducts : String -> Cmd Msg
fetchProducts api =
    Http.get
        { url = api ++ products
        , expect = collection |> Http.expectJson (RemoteData.fromResult >> ProductsReceived)
        }


saveProducts : WebData Products -> Cmd msg
saveProducts response =
    case response of
        RemoteData.Success products ->
            collectionEncoder products
                |> Encode.encode 0
                |> storeProducts

        _ ->
            Cmd.none


viewProducts : Model -> Html Msg
viewProducts model =
    case model.products of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            div [] [ text "Failure" ]

        RemoteData.Success products ->
            table [] ([ tableHeader ] ++ List.map viewProduct products)


viewProduct : Product -> Html Msg
viewProduct product =
    let
        id =
            idToString product.id
    in
    tr []
        [ th [] [ a [ href ("/products/" ++ id) ] [ text id ] ]
        , th [] [ text (nameToString product.name) ]
        , th [] [ text (stockToString product.stock) ]
        , th [] [ text (createdAtToString product.createdAt) ]
        , th [] [ a [ href ("/products/" ++ id ++ "/delete") ] [ text "Delete" ] ]
        , th [] [ a [ href ("/products/" ++ id ++ "/update") ] [ text "Update" ] ]
        ]


tableHeader : Html Msg
tableHeader =
    tr []
        [ th [] [ text "id" ]
        , th [] [ text "name" ]
        , th [] [ text "stock" ]
        , th [] [ text "created" ]
        ]
