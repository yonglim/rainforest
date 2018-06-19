module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


-- Entry point


main : Program Never Model Msg
main =
    beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }



-- Model


type alias Model =
    { value : Int }


initialModel : Model
initialModel =
    { value = 0 }



-- View


view : Model -> Html Msg
view model =
    div []
        [ span []
            [ h4 [] [ text "Increment / Decrement button" ]
            , button [ onClick Decrement ] [ text "-" ]
            , span [] [ text (toString model.value) ]
            , button [ onClick Increment ] [ text "-" ]
            ]
        , div []
            [ button [ onClick <| SetValue 0 ] [ text "Reset" ] ]
        ]



-- Update


type Msg
    = Increment
    | Decrement
    | SetValue Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | value = model.value + 1 }

        Decrement ->
            { model | value = max 0 <| model.value - 1 }

        SetValue val ->
            { model | value = val }
