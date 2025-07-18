import "../config"

// icons for... pretty much everything
CustomText {
    property real fill
    property int grade: -25

    font.family: "Material Symbols Rounded"
    font.pointSize: 20
    font.variableAxes: ({
            // TODO: copy this to appicons?
            FILL: fill.toFixed(1),
            GRAD: grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
