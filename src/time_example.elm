module Main exposing (..)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second, minute)


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    Time


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( newTime, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick


view : Model -> Html Msg
view model =
    let
        secondsAngle =
            turns (Time.inMinutes model)

        minutesAngle =
            turns (Time.inHours model)

        hoursAngle =
            (Time.inHours model / 24) |> turns
    in
        svg [ viewBox "0 0 100 100", width "300px" ]
            [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
            , line [ x1 "50", y1 "50", x2 (getHandX secondsAngle 40), y2 (getHandY secondsAngle 40), stroke "#023963" ] []
            , line [ x1 "50", y1 "50", x2 (getHandX minutesAngle 40), y2 (getHandY minutesAngle 40), stroke "#023963", strokeWidth "2" ] []
            , line [ x1 "50", y1 "50", x2 (getHandX hoursAngle 25), y2 (getHandY hoursAngle 25), stroke "#023963", strokeWidth "3" ] []
            ]


getHandX : Float -> Float -> String
getHandX angle length =
    toString (50 + length * cos angle)


getHandY : Float -> Float -> String
getHandY angle length =
    toString (50 + length * sin angle)
