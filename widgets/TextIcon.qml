import "../config"

CustomText {
    property real fill
    property int grade: -25

    font.family: "Material Symbols Rounded"
    font.pointSize: 20
    font.variableAxes: ({
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
