import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

Page {
    title: qsTr("CBTExaminer")
    
    background: Rectangle {
        color: "white"
    }
    
    Label {
        id: label
        text: qsTr("GDPSS BAKORI Softwares")
        font.pointSize: 20
        font.bold: true
        color: "hotpink"
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
    }
    
    Image {
        id: image
        anchors.centerIn: parent
        source: "../img/logo.jpg"
    }
    
    BusyIndicator {
        id: busyIndicator
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10
    }
    
    Timer {
        id: timer
        interval: 1000 // TODO: reset splash timer
        repeat: false
        running: true
        
        onTriggered: stackView.push("qrc:/pages/Login.qml")
    }
}
