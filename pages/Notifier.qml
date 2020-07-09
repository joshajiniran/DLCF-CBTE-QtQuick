import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup {
    id: popup
    anchors.centerIn: Overlay.overlay
    dim: true
    focus: true
    
    property alias msgTxt: msg.text
    
    signal closeBtnClicked
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 6
        
        Label {
            text: qsTr("Info.")
            font.pixelSize: 16
            color: "deeppink"
            horizontalAlignment: Text.AlignHCenter
        }
        
        Label {
            id: msg
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            text: qsTr("Lorem ipsum dolor...")
        }
        
        Button {
            id: popupCloseBtn
            Layout.fillWidth: true
            text: qsTr("OK")
            focus: true
            onClicked: {
                popup.close()
                popup.closeBtnClicked()
            }
        }
    }
}
