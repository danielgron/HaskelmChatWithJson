import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import List

main: Program Never Model Msg
main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

 -- MODEL
type alias Model =
  { chatMessage : String
  , userMessage : String
  }

init : (Model, Cmd Msg)
init =
  ( Model "" ""
  , Cmd.none
  )

type alias ChatMessage =
  { command: String
  , content: String
  }

-- UPDATE
type Msg
  = PostChatMessage
  | UpdateUserMessage String
  | NewChatMessage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PostChatMessage ->
      let
        message = model.userMessage
      in
        { model | userMessage = "" } ! [WebSocket.send "ws://localhost:3000/" message]

    UpdateUserMessage message ->
      { model | userMessage = message } ! []

    NewChatMessage message ->
        { model | chatMessage = message } ! []

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "message..."
            , autofocus True
            , value model.userMessage
            , onInput UpdateUserMessage
            ] []
    , button [ onClick PostChatMessage ] [ text "Submit" ]
    , div [] [ text model.chatMessage ]
  ]

 -- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://localhost:3000" NewChatMessage
