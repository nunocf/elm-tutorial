module Main exposing (..)

import Html exposing (Html, img, div, button, h2, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (src, type_, placeholder, style)
import Http
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { topic : String, gifUrl : String, error : String }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" "", getRandomGif "waiting" )



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)
    | TopicChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TopicChanged newTopic ->
            ( { model | topic = newTopic }, Cmd.none )

        MorePlease ->
            ( model, getRandomGif model.topic )

        NewGif (Ok newUrl) ->
            ( { model | gifUrl = newUrl, error = "" }, Cmd.none )

        NewGif (Err error) ->
            ( { model | gifUrl = "", error = toString error }, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ div [] [ input [ type_ "text", onInput TopicChanged, placeholder "Search for a topic" ] [ text model.topic ] ]
            , div [ myStyle ] [ img [ src model.gifUrl ] [] ]
            , button [ onClick MorePlease ] [ text " Moar!!" ]
            ]
        , viewError model.error
        ]


viewError : String -> Html Msg
viewError error =
    div [] [ text error ]


myStyle : Html.Attribute msg
myStyle =
    style [ ( "max-width", "200px" ) ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
