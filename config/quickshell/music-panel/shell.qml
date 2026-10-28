import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Widgets

PanelWindow {
    id: panel

    property bool panelOpen: false

    // ============================================================
    // PLAYER SPOTIFY
    // ============================================================

    property var player: {
        let players = Mpris.players.values

        for (let i = 0; i < players.length; i++) {
            if (players[i].identity &&
                players[i].identity.toLowerCase().includes("spotify")) {
                return players[i]
            }
        }

        return players.length > 0 ? players[0] : null
    }

    // ============================================================
    // CAVA
    // ============================================================

    property var audioLevels: []

    // ============================================================
    // CORES PYwal
    // ============================================================

    property var walColors: ({
        color0: "#1a0e22",
        color1: "#c4a7e7",
        color2: "#9ccfd8",
        color3: "#ebbcba",
        color4: "#f6c177",
        color5: "#31748f",
        color6: "#e0def4",
        color7: "#908caa",
        color8: "#6e6a86",
        color9: "#c4a7e7",
        color10: "#9ccfd8",
        color11: "#ebbcba",
        color12: "#f6c177",
        color13: "#31748f",
        color14: "#e0def4",
        color15: "#908caa"
    })

    // ============================================================
    // ARQUIVO DE CORES DO PYWAL
    // ============================================================

    FileView {
        id: walFile

        path: Quickshell.env("HOME") +
              "/.cache/wal/colors.json"

        watchChanges: true
        blockLoading: true

        onLoaded: {
            panel.loadWalColors()
        }

        onFileChanged: {
            reload()
        }
    }

    function loadWalColors() {
        try {
            let data = JSON.parse(walFile.text())

            if (data.colors) {
                panel.walColors = {
                    color0: data.colors.color0 || panel.walColors.color0,
                    color1: data.colors.color1 || panel.walColors.color1,
                    color2: data.colors.color2 || panel.walColors.color2,
                    color3: data.colors.color3 || panel.walColors.color3,
                    color4: data.colors.color4 || panel.walColors.color4,
                    color5: data.colors.color5 || panel.walColors.color5,
                    color6: data.colors.color6 || panel.walColors.color6,
                    color7: data.colors.color7 || panel.walColors.color7,
                    color8: data.colors.color8 || panel.walColors.color8,
                    color9: data.colors.color9 || panel.walColors.color9,
                    color10: data.colors.color10 || panel.walColors.color10,
                    color11: data.colors.color11 || panel.walColors.color11,
                    color12: data.colors.color12 || panel.walColors.color12,
                    color13: data.colors.color13 || panel.walColors.color13,
                    color14: data.colors.color14 || panel.walColors.color14,
                    color15: data.colors.color15 || panel.walColors.color15
                }
            }
        } catch (error) {
            console.log("Erro ao carregar cores do Pywal:", error)
        }
    }

    // ============================================================
    // JANELA
    // ============================================================

    anchors {
        top: true
        left: true
        right: true
    }

    margins.top: 32

    implicitHeight: panelOpen ? 390 : 0

    exclusiveZone: 0
    aboveWindows: true

    color: "transparent"

    visible: panelOpen

    // ============================================================
    // FUNÇÕES DO PAINEL
    // ============================================================

    function toggle() {
        panelOpen = !panelOpen
    }

    function open() {
        panelOpen = true
    }

    function close() {
        panelOpen = false
    }

    // ============================================================
    // IPC
    // ============================================================

    IpcHandler {
        target: "music"

        function toggle() {
            panel.toggle()
        }

        function open() {
            panel.open()
        }

        function close() {
            panel.close()
        }
    }

    // ============================================================
    // ATUALIZAÇÃO SUAVE DO PROGRESSO
    // ============================================================

    FrameAnimation {
        running:
            panelOpen &&
            player !== null &&
            player.isPlaying

        onTriggered: {
            if (player)
                player.positionChanged()
        }
    }

    // ============================================================
    // CAVA
    // ============================================================

    Process {
        id: cavaProcess

        command: [
            "cava",
            "-p",
            Quickshell.env("HOME") +
            "/.config/cava/music-panel"
        ]

        running:
            panelOpen &&
            player !== null &&
            player.isPlaying

        stdout: SplitParser {
            splitMarker: "\n"

            onRead: data => {
                let values = data
                    .trim()
                    .split(";")
                    .map(v => parseFloat(v))
                    .filter(v => !isNaN(v))

                if (values.length > 0) {
                    panel.audioLevels = values
                }
            }
        }

        onRunningChanged: {
            if (!running) {
                panel.audioLevels = []
            }
        }
    }

    // ============================================================
    // PAINEL PRINCIPAL
    // ============================================================

    Rectangle {
        id: panelBackground

        anchors.horizontalCenter:
            parent.horizontalCenter

        width: 760
        height: 360

        radius: 24

        color: walColors.color0

        border.width: 1
        border.color: walColors.color8

        opacity:
            panelOpen
                ? 1
                : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        // ========================================================
        // ÁREA DA CAPA
        // ========================================================

        Item {
            id: albumArea

            width: 300
            height: 300

            anchors.left:
                parent.left

            anchors.leftMargin: 30

            anchors.verticalCenter:
                parent.verticalCenter

            // ====================================================
            // BARRAS DO CAVA
            // ====================================================

            Repeater {
                model: 48

                delegate: Rectangle {
                    id: visualBar

                    property real angle:
                        index * (360 / 48)

                    property real radians:
                        angle * Math.PI / 180

                    property real audioValue:
                        index < panel.audioLevels.length
                            ? Math.max(
                                0,
                                Math.min(
                                    100,
                                    panel.audioLevels[index]
                                )
                              ) / 100
                            : 0

                    property real innerRadius: 90

                    property real minLength: 12

                    property real maxGrowth: 62

                    property real barLength:
                        player && player.isPlaying
                            ? minLength +
                              audioValue * maxGrowth
                            : minLength

                    width: 6

                    height: barLength

                    radius: width / 2

                    color: walColors.color4

                    antialiasing: true

                    x:
                        albumArea.width / 2
                        + Math.cos(radians)
                          * (
                              innerRadius +
                              barLength / 2
                            )
                        - width / 2

                    y:
                        albumArea.height / 2
                        + Math.sin(radians)
                          * (
                              innerRadius +
                              barLength / 2
                            )
                        - height / 2

                    rotation:
                        angle + 90

                    transformOrigin:
                        Item.Center

                    opacity:
                        player && player.isPlaying
                            ? 1
                            : 0.45

                    Behavior on height {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on x {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on y {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }
            }

            // ====================================================
            // CAPA CIRCULAR
            // ====================================================

            ClippingRectangle {
                id: albumClip

                width: 170
                height: 170

                anchors.centerIn:
                    parent

                radius:
                    width / 2

                color:
                    walColors.color0

                border.width: 2

                border.color:
                    walColors.color4

                antialiasing: true

                // =================================================
                // IMAGEM
                // =================================================

                Image {
                    id: albumArt

                    anchors.fill:
                        parent

                    source:
                        player &&
                        player.trackArtUrl
                            ? player.trackArtUrl
                            : ""

                    fillMode:
                        Image.PreserveAspectCrop

                    asynchronous: true

                    cache: true

                    smooth: true

                    // =============================================
                    // ROTAÇÃO DA CAPA
                    // =============================================

                    RotationAnimation {
                        target:
                            albumArt

                        property:
                            "rotation"

                        from: 0

                        to: 360

                        duration: 20000

                        loops:
                            Animation.Infinite

                        running:
                            panelOpen &&
                            player !== null &&
                            player.isPlaying

                        easing.type:
                            Easing.Linear
                    }
                }

                // =================================================
                // PLACEHOLDER
                // =================================================

                Text {
                    anchors.centerIn:
                        parent

                    visible:
                        !player ||
                        !player.trackArtUrl

                    text:
                        "♫"

                    font.family:
                        "Rec Mono Linear Nerd Font"

                    font.pixelSize:
                        48

                    color:
                        walColors.color4
                }
            }
        }

        // ========================================================
        // INFORMAÇÕES DA MÚSICA
        // ========================================================

        Column {
            id: musicInfo

            anchors.left:
                albumArea.right

            anchors.leftMargin:
                25

            anchors.right:
                parent.right

            anchors.rightMargin:
                35

            anchors.top:
                parent.top

            anchors.topMargin:
                55

            spacing:
                7

            // ====================================================
            // TÍTULO
            // ====================================================

            Text {
                width:
                    parent.width

                text:
                    player &&
                    player.trackTitle
                        ? player.trackTitle
                        : "Nenhuma música"

                color:
                    walColors.color6

                font.family:
                    "Rec Mono Linear Nerd Font"

                font.pixelSize:
                    22

                font.bold:
                    true

                elide:
                    Text.ElideRight
            }

            // ====================================================
            // ARTISTA
            // ====================================================

            Text {
                width:
                    parent.width

                text:
                    player &&
                    player.trackArtist
                        ? player.trackArtist
                        : "Spotify"

                color:
                    walColors.color4

                font.family:
                    "Rec Mono Linear Nerd Font"

                font.pixelSize:
                    14

                elide:
                    Text.ElideRight
            }

            // ====================================================
            // ÁLBUM
            // ====================================================

            Text {
                width:
                    parent.width

                text:
                    player &&
                    player.trackAlbum
                        ? player.trackAlbum
                        : ""

                color:
                    walColors.color7

                font.family:
                    "Rec Mono Linear Nerd Font"

                font.pixelSize:
                    12

                elide:
                    Text.ElideRight
            }
        }

        // ========================================================
        // GIF DECORATIVO
        // ========================================================

        AnimatedImage {
            id: decorativeGif

            source:
                "file:///home/Snow/Downloads/gifs/4.gif"

            width: 300
            height: 300

            anchors.right:
                parent.right

            anchors.rightMargin:
                -70

            anchors.bottom:
                parent.bottom

            anchors.bottomMargin:
                20

            fillMode:
                Image.PreserveAspectFit

            playing:
                panelOpen

            smooth: true
        }

        // ========================================================
        // CONTROLES
        // ========================================================

        Row {
            id: controls

            anchors.left:
                musicInfo.left

            anchors.top:
                musicInfo.bottom

            anchors.topMargin:
                30

            spacing:
                25

            // ====================================================
            // ANTERIOR
            // ====================================================

            Text {
                text:
                    "󰒮"

                color:
                    walColors.color6

                font.family:
                    "Rec Mono Linear Nerd Font"

                font.pixelSize:
                    26

                MouseArea {
                    anchors.fill:
                        parent

                    cursorShape:
                        Qt.PointingHandCursor

                    onClicked: {
                        if (player)
                            player.previous()
                    }
                }
            }

            // ====================================================
            // PLAY / PAUSE
            // ====================================================

            Text {
                text:
                    player &&
                    player.isPlaying
                        ? "󰏤"
                        : "󰐊"

                color:
                    walColors.color4

                font.family:
                    "Rec Mono Linear Nerd Font"

                font.pixelSize:
                    30

                MouseArea {
                    anchors.fill:
                        parent

                    cursorShape:
                        Qt.PointingHandCursor

                    onClicked: {
                        if (player) {
                            if (player.isPlaying)
                                player.pause()
                            else
                                player.play()
                        }
                    }
                }
            }

            // ====================================================
            // PRÓXIMA
            // ====================================================

            Text {
                text:
                    "󰒭"

                color:
                    walColors.color6

                font.family:
                    "Rec Mono Linear Nerd Font"

                font.pixelSize:
                    26

                MouseArea {
                    anchors.fill:
                        parent

                    cursorShape:
                        Qt.PointingHandCursor

                    onClicked: {
                        if (player)
                            player.next()
                    }
                }
            }
        }

        // ========================================================
        // BARRA DE PROGRESSO
        // ========================================================

        Item {
            id: progressArea

            anchors.left:
                musicInfo.left

            anchors.right:
                musicInfo.right

            anchors.bottom:
                parent.bottom

            anchors.bottomMargin:
                50

            height:
                20

            property real progress:
                player &&
                player.length > 0
                    ? Math.max(
                        0,
                        Math.min(
                            1,
                            player.position /
                            player.length
                        )
                      )
                    : 0

            // ====================================================
            // FUNDO
            // ====================================================

            Rectangle {
                id: progressBackground

                anchors.left:
                    parent.left

                anchors.right:
                    parent.right

                anchors.verticalCenter:
                    parent.verticalCenter

                height:
                    5

                radius:
                    height / 2

                color:
                    walColors.color8
            }

            // ====================================================
            // PROGRESSO
            // ====================================================

            Rectangle {
                id: progressValue

                width:
                    progressArea.width *
                    progressArea.progress

                height:
                    5

                anchors.left:
                    parent.left

                anchors.verticalCenter:
                    parent.verticalCenter

                radius:
                    height / 2

                color:
                    walColors.color4
            }

            // ====================================================
            // CLIQUE NA BARRA
            // ====================================================

            MouseArea {
                anchors.fill:
                    parent

                cursorShape:
                    Qt.PointingHandCursor

                onClicked: mouse => {
                    if (
                        player &&
                        player.length > 0
                    ) {
                        let value =
                            Math.max(
                                0,
                                Math.min(
                                    1,
                                    mouse.x / width
                                )
                            )

                        player.position =
                            value * player.length
                    }
                }
            }
        }

        // ========================================================
        // TEMPO ATUAL
        // ========================================================

        Text {
            id: currentTime

            anchors.left:
                musicInfo.left

            anchors.bottom:
                parent.bottom

            anchors.bottomMargin:
                22

            text: {
                if (!player)
                    return "0:00"

                let seconds =
                    Math.floor(
                        player.position
                    )

                let minutes =
                    Math.floor(
                        seconds / 60
                    )

                seconds =
                    seconds % 60

                return minutes +
                    ":" +
                    (
                        seconds < 10
                            ? "0"
                            : ""
                    ) +
                    seconds
            }

            color:
                walColors.color7

            font.family:
                "Rec Mono Linear Nerd Font"

            font.pixelSize:
                11
        }

        // ========================================================
        // DURAÇÃO
        // ========================================================

        Text {
            id: totalTime

            anchors.right:
                musicInfo.right

            anchors.bottom:
                parent.bottom

            anchors.bottomMargin:
                22

            text: {
                if (!player)
                    return "0:00"

                let seconds =
                    Math.floor(
                        player.length
                    )

                let minutes =
                    Math.floor(
                        seconds / 60
                    )

                seconds =
                    seconds % 60

                return minutes +
                    ":" +
                    (
                        seconds < 10
                            ? "0"
                            : ""
                    ) +
                    seconds
            }

            color:
                walColors.color7

            font.family:
                "Rec Mono Linear Nerd Font"

            font.pixelSize:
                11
        }

        // ========================================================
        // STATUS
        // ========================================================

        Text {
            anchors.right:
                parent.right

            anchors.top:
                parent.top

            anchors.rightMargin:
                20

            anchors.topMargin:
                15

            text:
                player &&
                player.isPlaying
                    ? "●"
                    : "○"

            color:
                player &&
                player.isPlaying
                    ? walColors.color4
                    : walColors.color8

            font.pixelSize:
                10
        }
    }
}