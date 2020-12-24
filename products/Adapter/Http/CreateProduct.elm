module Adapter.Http.CreateProduct exposing (Model, Msg(..), init, update, view)

import Adapter.Http.Api exposing (products)
import Adapter.Json.Products exposing (encoder)
import Domain.Products
    exposing
        ( Product
        , ProductName(..)
        , ProductStock(..)
        , nameToString
        )
import Html
    exposing
        ( Html
        , a
        , br
        , button
        , div
        , form
        , h1
        , input
        , text
        )
import Html.Attributes exposing (href, type_)
import Html.Events exposing (onClick, onInput)
import Http


type alias Model =
    { name : ProductName
    , stock : ProductStock
    , created : Bool
    , error : Bool
    }


type Msg
    = AddName ProductName
    | AddStock ProductStock
    | CreateProduct
    | ValidateProduct
    | ProductCreated (Result Http.Error String)


init : ( Model, Cmd Msg )
init =
    ( { name = ProductName ""
      , stock = ProductStock 0
      , created = False
      , error = False
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "New Product" ]
        , viewForm
        , br [] []
        , div []
            [ a [ href "/products" ] [ text "All Products" ] ]
        , br [] []
        , div []
            [ let
                msg =
                    if model.created then
                        "Created"

                    else
                        "Not Created"
              in
              text msg
            ]
        ]


update : String -> Msg -> Model -> ( Model, Cmd Msg )
update api msg model =
    case msg of
        AddName name ->
            ( { model | name = name }, Cmd.none )

        AddStock stock ->
            ( { model | stock = stock }, Cmd.none )

        ValidateProduct ->
            if isValid model then
                update api CreateProduct model

            else
                ( model, Cmd.none )

        CreateProduct ->
            ( model, createProduct api model.name model.stock )

        ProductCreated response ->
            case response of
                Ok _ ->
                    ( { model | created = True }, Cmd.none )

                Err _ ->
                    ( { model | error = True }, Cmd.none )


isValid : Model -> Bool
isValid { name, stock } =
    not (String.isEmpty (nameToString name))


createProduct : String -> ProductName -> ProductStock -> Cmd Msg
createProduct api name stock =
    let
        tuple =
            ( name, stock )
    in
    Http.request
        { method = "POST"
        , headers = []
        , url = api ++ products
        , body = Http.jsonBody (encoder tuple)
        , expect = Http.expectString ProductCreated
        , timeout = Nothing
        , tracker = Nothing
        }


viewForm : Html Msg
viewForm =
    form []
        [ div []
            [ text "Name"
            , br [] []
            , input [ type_ "text", onInput (\name -> AddName (ProductName name)) ] []
            ]
        , div []
            [ text "Stock"
            , br [] []
            , input [ type_ "number", onInput (\stock -> AddStock (ProductStock (getStock stock))) ] []
            ]
        , div []
            [ button [ type_ "button", onClick ValidateProduct ]
                [ text "Submit" ]
            ]
        ]


getStock : String -> Float
getStock input =
    let
        value =
            String.toFloat input
    in
    case value of
        Just v ->
            v

        _ ->
            0
