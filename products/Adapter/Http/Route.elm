module Adapter.Http.Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser
    exposing
        ( (</>)
        , Parser
        , custom
        , map
        , oneOf
        , parse
        , s
        , string
        , top
        )


type Route
    = NotFound
    | Products
    | Product String
    | NewProduct
    | DeleteProduct String
    | UpdateProduct String


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        _ ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Products top -- /
        , map Products (s "products") -- /products
        , map NewProduct (s "products" </> s "new") -- /products/new
        , map DeleteProduct (s "products" </> string </> s "delete") -- /products/{product_id}/delete
        , map UpdateProduct (s "products" </> string </> s "update") -- /products/{product_id}/update
        , map Product (s "products" </> string) -- /products/{product_id}
        ]
