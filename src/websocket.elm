module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import WebSocket


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { input : String, messages : List String }


init : ( Model, Cmd Msg )
init =
    ( Model "" [], Cmd.none )



-- UPDATE


type Msg
    = NewMessage String
    | Input String
    | Send


update : Msg -> Model -> ( Model, Cmd Msg )
update msg { input, messages } =
    case msg of
        NewMessage newMessage ->
            ( Model input (newMessage :: messages), Cmd.none )

        Input string ->
            ( Model string messages, Cmd.none )

        Send ->
            ( Model "" messages, WebSocket.send "ws://echo.websocket.org" input )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://echo.websocket.org" NewMessage



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] (List.reverse (List.map viewMessage model.messages))
        , input [ type_ "text", placeholder "type your message here", onInput Input ] []
        , button [ onClick Send ] [ text "Send" ]
        ]


viewMessage : String -> Html Msg
viewMessage msg =
    div [] [ text msg ]
