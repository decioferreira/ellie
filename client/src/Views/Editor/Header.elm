module Views.Editor.Header
    exposing
        ( Config
        , SaveOption(..)
        , view
        )

import Extra.Html as Html
import Html exposing (Html, button, div, h1, header, span, text)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Shared.Icons as Icons
import Views.Editor.Header.Styles as Styles


type SaveOption
    = Save
    | Update
    | Fork
    | Saving


type alias Config msg =
    { compileButtonEnabled : Bool
    , embedLinkButtonEnabled : Bool
    , saveButtonEnabled : Bool
    , saveButtonOption : SaveOption
    , buttonsVisible : Bool
    , onSave : msg
    , onCompile : msg
    , onFormat : msg
    , onAbout : msg
    , onEmbedLink : msg
    }


viewLogo : Html msg
viewLogo =
    div [ Styles.logo ]
        [ text "Ellie" ]


viewButton : msg -> Bool -> Html msg -> String -> Html msg
viewButton clickMsg isDisabled icon label =
    button
        [ Styles.button
        , onClick clickMsg
        , disabled isDisabled
        ]
        [ div [ Styles.buttonInner ]
            [ span [ Styles.buttonIcon ]
                [ icon ]
            , span [ Styles.buttonText ]
                [ text label ]
            ]
        ]


viewSaveButton : Config msg -> Html msg
viewSaveButton config =
    case config.saveButtonOption of
        Fork ->
            viewButton
                config.onSave
                (not config.saveButtonEnabled)
                Icons.forkRepo
                "Fork"

        Update ->
            viewButton
                config.onSave
                (not config.saveButtonEnabled)
                Icons.cloudOutline
                "Update"

        Save ->
            viewButton
                config.onSave
                (not config.saveButtonEnabled)
                Icons.cloudOutline
                "Save"

        Saving ->
            viewButton
                config.onSave
                True
                Icons.loading
                "Saving..."


viewCompileButton : Config msg -> Html msg
viewCompileButton config =
    viewButton
        config.onCompile
        (not config.compileButtonEnabled)
        Icons.playOutline
        "Compile"


viewFormatButton : Config msg -> Html msg
viewFormatButton config =
    viewButton
        config.onFormat
        False
        Icons.format
        "Format"


viewAboutButton : Config msg -> Html msg
viewAboutButton config =
    viewButton
        config.onAbout
        False
        Icons.lightning
        "About"


viewEmbedLinkButton : Config msg -> Html msg
viewEmbedLinkButton config =
    viewButton
        config.onEmbedLink
        (not config.embedLinkButtonEnabled)
        Icons.share
        "Share"


view : Config msg -> Html msg
view config =
    header [ Styles.header ]
        [ div [ Styles.headerGroup ]
            [ viewLogo
            , Html.viewIfLazy config.buttonsVisible (\() -> viewCompileButton config)
            , Html.viewIfLazy config.buttonsVisible (\() -> viewSaveButton config)
            , Html.viewIfLazy config.buttonsVisible (\() -> viewFormatButton config)
            , Html.viewIfLazy config.buttonsVisible (\() -> viewEmbedLinkButton config)
            ]
        , div [ Styles.headerGroup ]
            [ viewAboutButton config
            ]
        ]
