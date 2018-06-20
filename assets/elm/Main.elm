module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http


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
    { dataFromServer : String
    , errorMessage : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( { dataFromServer = ""
      , errorMessage = Nothing
      }
    , Cmd.none
    )



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
            viewdataFromServer model.dataFromServer


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


viewdataFromServer : String -> Html Msg
viewdataFromServer dataFromServer =
    div []
        [ h3 [] [ text "List of Products" ]
        , div [] [ text dataFromServer ]
        ]


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error String)



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, Http.send DataReceived (Http.getString "http://0.0.0.0:4000/api/products/") )

        DataReceived (Ok data) ->
            ( { model | dataFromServer = data }, Cmd.none )

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
