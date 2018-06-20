module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)


-- Entry point


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Model =
    { dataFromServer : List Product
    , errorMessage : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( { dataFromServer = []
      , errorMessage = Nothing
      }
    , Cmd.none
    )


type alias Product =
    { id : Int
    , productName : String
    , stock : Int
    , sellingPrice : Float
    }


dataDecoder : Decoder (List Product)
dataDecoder =
    field "data" (list productDecoder)


productDecoder : Decoder Product
productDecoder =
    map4
        Product
        (field "id" int)
        (field "productName" string)
        (field "stock" int)
        (field "sellingPrice" float)



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Get data from server" ]
        , displayData model
        ]


displayData : Model -> Html Msg
displayData model =
    case model.errorMessage of
        Just message ->
            viewError message

        Nothing ->
            displayProductList model.dataFromServer


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error msg: " ++ errorMessage)
            ]


displayProductList : List Product -> Html Msg
displayProductList productList =
    div []
        [ h3 [] [ text "List of Products" ]
        , ul [] (List.map displayProduct productList)
        ]


displayProduct : Product -> Html Msg
displayProduct product =
    li [] [ text (product.productName ++ " : " ++ toString product.stock ++ " selling price : " ++ toString product.sellingPrice) ]


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error (List Product))



-- Update


httpCommand : Cmd Msg
httpCommand =
    dataDecoder
        -- list productDecoder
        |> Http.get "http://0.0.0.0:4000/api/products/"
        |> Http.send DataReceived


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model
            , httpCommand
              -- , Http.send DataReceived
              --     (Http.get "http://0.0.0.0:4000/api/products/" (list productDecoder))
            )

        DataReceived (Ok productList) ->
            ( { model | dataFromServer = productList, errorMessage = Nothing }, Cmd.none )

        DataReceived (Err httpError) ->
            ( { model
                | errorMessage = Just (createErrorMessage httpError)
              }
            , Cmd.none
            )


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message
