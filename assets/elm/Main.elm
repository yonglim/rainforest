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
            -- viewError message
            div []
                [ h3 [] [ text "Error!" ]
                , div [] [ text message ]
                ]

        Nothing ->
            div []
                [ h3 [] [ text "List of Products" ]
                , div [] [ text model.dataFromServer ]
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
                | errorMessage = Just "Ooops ... we got problem getting data from the server"
              }
            , Cmd.none
            )
