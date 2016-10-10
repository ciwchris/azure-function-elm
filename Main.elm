module Main exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options exposing (nop, attribute, css)
import Material.Grid
import Json.Decode as Json


type alias Model =
    { name : String
    , submitted : Bool
    , action : String
    , mdl : Material.Model
    }


model : Model
model =
    { name = ""
    , submitted = False
    , action = ""
    , mdl = Material.model
    }


type Msg
    = NameChange String
    | FormSubmit
    | Mdl (Material.Msg Msg)


onSubmit : Model -> Msg -> Attribute Msg
onSubmit model message =
    onWithOptions
        "submit"
        { preventDefault = False, stopPropagation = False }
        (Json.succeed message)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NameChange name ->
            ( { model | name = name }, Cmd.none )

        FormSubmit ->
            ( { model | submitted = True }, Cmd.none )

        Mdl msg' ->
            Material.update msg' model


view : Model -> Html Msg
view model =
    Html.form
        [ target "_blank"
        , method "GET"
        , action "https://stcu-pdf-test.azurewebsites.net/api/AccountCard"
        , onSubmit model FormSubmit
        ]
        [ Material.Grid.grid []
            [ Material.Grid.cell []
                [ input
                    [ type' "hidden"
                    , Html.Attributes.name "code"
                    , value "gh8q4v7a8n8j6j6myxb87r7cnwwzb7gfu"
                    ]
                    []
                , input
                    [ type' "hidden"
                    , Html.Attributes.name "name"
                    , value model.name
                    , required True
                    ]
                    []
                , Textfield.render
                    Mdl
                    [ 0 ]
                    model.mdl
                    [ Textfield.label "Enter your name"
                    , Textfield.floatingLabel
                    , Textfield.value model.name
                    , if model.name == "" && model.submitted then
                        Textfield.error ""
                      else
                        Material.Options.nop
                    , Textfield.onInput NameChange
                    ]
                ]
            , Material.Grid.cell []
                [ Button.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Button.raised
                    , Button.colored
                    , Button.ripple
                    , if model.name == "" then
                        Material.Options.nop
                      else
                        Material.Options.css "visibility" "hidden"
                    , onPreventClick FormSubmit
                    ]
                    [ text "Create" ]
                , Button.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Button.raised
                    , Button.colored
                    , Button.ripple
                    , if model.name == "" then
                        Material.Options.css "visibility" "hidden"
                      else
                        Material.Options.nop
                    , Button.onClick FormSubmit
                    ]
                    [ text "Create" ]
                ]
            ]
        ]
        |> Material.Scheme.top


onPreventClickHtml : Msg -> Attribute Msg
onPreventClickHtml msg =
    onWithOptions
        "click"
        { preventDefault = True, stopPropagation = True }
        (Json.succeed msg)


onPreventClick : Msg -> Property Msg
onPreventClick message =
    Material.Options.set
        (\options -> { options | onClick = Just (onPreventClickHtml message) })


type alias Property m =
    Material.Options.Property (Config m) m


type alias Config m =
    { ripple : Bool
    , onClick : Maybe (Attribute m)
    , disabled : Bool
    , type' : Maybe String
    }


main : Program Never
main =
    Html.App.program
        { init = ( model, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
