import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.11

import "logic/Database.js" as JS

ApplicationWindow {
    id: window
    visible: true
    visibility: "Maximized"
    title: qsTr("CBTExaminer")
    color: "white"
    
    header: ToolBar {
        id: overlayHeader
        contentHeight: toolButton.implicitHeight
        
        RowLayout {
            anchors.fill: parent
            
            ToolButton {
                id: toolButton
                text: stackView.depth > 2 ? "\u25C0" : ""
                font.pixelSize: Qt.application.font.pixelSize * 1.6
                Layout.alignment: Qt.AlignLeft 
                onClicked: {
                    if (stackView.depth > 2) {
                        stackView.pop()
                    }
                }
            }
            
            Label {
                text: stackView.currentItem.title
                Layout.alignment: Qt.AlignCenter
            }
            
            ToolButton {
                id: exitBtn
                text: "X"
                font.pixelSize: Qt.application.font.pixelSize * 1.4
                Layout.alignment: Qt.AlignRight
                onClicked: Qt.quit()
            }
        }
    }
    
    StackView {
        id: stackView
        initialItem: "qrc:/pages/SplashScreen.qml"
        anchors.fill: parent
    }
    
    Component.onCompleted: {
        JS.dbInit()
    }
}
