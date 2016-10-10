module Main exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options exposing (nop, attribute)
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
        (if model.name == "" then
            (Debug.log "prevent" { preventDefault = True, stopPropagation = True })
         else
            (Debug.log "allow" { preventDefault = False, stopPropagation = False })
        )
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
        , onWithOptions
            "submit"
            (if model.name == "" then
                (Debug.log "prevent" { preventDefault = True, stopPropagation = True })
             else
                (Debug.log "allow" { preventDefault = False, stopPropagation = False })
            )
            (Json.succeed FormSubmit)
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
                      -- , if model.name == "" then
                      --     Button.disabled
                      --   else
                      --     Material.Options.nop
                    ]
                    [ text "Create" ]
                ]
            ]
        ]
        |> Material.Scheme.top


main : Program Never
main =
    Html.App.program
        { init = ( model, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
