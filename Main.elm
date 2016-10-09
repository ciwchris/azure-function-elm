module Main exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http


-- import Json.Decode as Json

import Task


name : String
name =
    ""


type Msg
    = GenerateAccountCard
    | NameChange String
    | HandleRawResponse (Result Http.RawError Http.Response)
    | HandleResponse (Result Http.Error Http.Response)


never : Never -> a
never n =
    never n


init : ( String, Cmd Msg )
init =
    ( "", Cmd.none )


getAccountCard : Cmd Msg
getAccountCard =
    let
        request =
            Http.send Http.defaultSettings
                { verb = "GET"
                , headers =
                    [ ( "Origin", "https://stcu-pdf-test.azurewebsites.net" ) ]
                    -- , url = "https://stcu-pdf-test.azurewebsites.net/api/HttpTriggerCSharp1?code=awzikdgobcj6rk3r7no1po9726lu16h18&name=test"
                , url = "https://stcu-pdf-test.azurewebsites.net/api/AccountCard?code=gh8q4v7a8n8j6j6myxb87r7cnwwzb7gfu&name=test"
                , body = Http.empty
                }
    in
        request
            |> Task.toResult
            |> Task.perform never HandleRawResponse


update : Msg -> String -> ( String, Cmd Msg )
update msg name =
    case msg of
        GenerateAccountCard ->
            ( name, getAccountCard )

        NameChange name ->
            ( name, Cmd.none )

        HandleRawResponse newUrl ->
            ( name, Cmd.none )

        HandleResponse _ ->
            ( name, Cmd.none )


view : String -> Html Msg
view name =
    div []
        [ h2 [] [ text "Enter your name" ]
        , input [ type' "text", onInput NameChange ] []
        , button [ onClick GenerateAccountCard ] [ text "Create" ]
        ]


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \n -> Sub.none
        }
