import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import List
import Json.Decode as Decode
import Json.Encode as Encode

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
  , userName : String
  }

init : (Model, Cmd Msg)
init =
  ( Model "" "" ""
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
  | NewUser String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PostChatMessage ->

      if String.isEmpty model.userName
      then
        let
          message = model.userMessage
        in
          { model | userMessage = "" , userName = message} ! [WebSocket.send "ws://localhost:3000/" ( (encodeChat (ChatMessage "login" message)))]
      else
        let
          message =  model.userMessage
        in
          { model | userMessage = "" } ! [WebSocket.send "ws://localhost:3000/" ((encodeChat (ChatMessage "message" message)))]


    UpdateUserMessage message ->
      { model | userMessage = message } ! []

    NewChatMessage message ->
        case (Decode.decodeString decodeChat message ) of
          Err msg->
            { model | userMessage = msg } ! []
          Ok chatMessage ->
            { model | chatMessage = chatMessage.content } ! []

    _ ->
      { model | chatMessage = "We will have our technical debt - one way or the other" } ! []



decodeChat : Decode.Decoder ChatMessage
decodeChat =
    Decode.map2 ChatMessage
        (Decode.field "command" Decode.string)
        (Decode.field "content" Decode.string)

encodeChat : ChatMessage -> String
encodeChat chatMessage =
  Encode.encode 4 (Encode.object
    [ ("command", Encode.string chatMessage.command)
    , ("content", Encode.string chatMessage.content)
    ])

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
