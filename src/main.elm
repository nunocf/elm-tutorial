module Main exposing (..)

import Html exposing (Html, div, h1, text, button, img)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Random exposing (..)


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { die1Face : Int
    , die2Face : Int
    }



-- UPDATE


type Msg
    = Roll
    | NewFace ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace doubleDieGenerator )

        NewFace ( newFace1, newFace2 ) ->
            ( { die1Face = newFace1, die2Face = newFace2 }, Cmd.none )


dieGenerator : Random.Generator Int
dieGenerator =
    Random.int 1 6


doubleDieGenerator : Random.Generator ( Int, Int )
doubleDieGenerator =
    Random.pair dieGenerator dieGenerator



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ img [ src ("../die_faces/" ++ (toString model.die1Face) ++ ".png") ] []
        , img [ src ("../die_faces/" ++ (toString model.die2Face) ++ ".png") ] []
        , button [ onClick Roll ] [ text "Roll" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { die1Face = 1, die2Face = 1 }, Cmd.none )
