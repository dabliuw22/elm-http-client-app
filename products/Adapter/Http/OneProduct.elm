module Adapter.Http.OneProduct exposing (Model, Msg(..), init, update, view)

import Adapter.Http.Api exposing (products)
import Adapter.Json.Products exposing (decoder)
import Domain.Products
    exposing
        ( Product
        , ProductId
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
        , div
        , table
        , text
        , th
        , tr
        )
import Html.Attributes exposing (href)
import Http
import RemoteData exposing (RemoteData, WebData)


type alias Model =
    { product : WebData Product }


type Msg
    = FetchProduct ProductId
    | ProductReceived (WebData Product)


init : String -> ProductId -> ( Model, Cmd Msg )
init api id =
    ( { product = RemoteData.Loading }, fetchProduct api id )


view : Model -> Html Msg
view model =
    div []
        [ viewProduct model
        , br [] []
        , div []
            [ a [ href "/products" ] [ text "All Products" ] ]
        ]


update : String -> Msg -> Model -> ( Model, Cmd Msg )
update api msg model =
    case msg of
        FetchProduct id ->
            ( { model | product = RemoteData.Loading }, fetchProduct api id )

        ProductReceived response ->
            ( { model | product = response }, Cmd.none )


fetchProduct : String -> ProductId -> Cmd Msg
fetchProduct api id =
    Http.get
        { url = api ++ products ++ "/" ++ idToString id
        , expect = decoder |> Http.expectJson (RemoteData.fromResult >> ProductReceived)
        }


viewProduct : Model -> Html Msg
viewProduct model =
    case model.product of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure error ->
            div [] [ text "Failure" ]

        RemoteData.Success product ->
            table [] [ tableHeader, tableBody product ]


tableHeader : Html Msg
tableHeader =
    tr []
        [ th [] [ text "id" ]
        , th [] [ text "name" ]
        , th [] [ text "stock" ]
        , th [] [ text "created" ]
        ]


tableBody : Product -> Html Msg
tableBody product =
    let
        id =
            idToString product.id
    in
    tr []
        [ th [] [ a [ href ("/products/" ++ id) ] [ text id ] ]
        , th [] [ text (nameToString product.name) ]
        , th [] [ text (stockToString product.stock) ]
        , th [] [ text (createdAtToString product.createdAt) ]
        , th [] [ a [ href ("/products/" ++ id ++ "/update") ] [ text "Update" ] ]
        ]
